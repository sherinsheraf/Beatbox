
import 'package:beatbox/class/first.dart';
import 'package:beatbox/database/functions.dart';

import 'package:beatbox/database/model/songModel.dart';

import 'package:beatbox/screens/playlist/addToPlaylist.dart';
import 'package:beatbox/utils/colors.dart';
import 'package:beatbox/screens/introScreen.dart';
import 'package:beatbox/screens/nowPlayingScreen.dart';
import 'package:beatbox/screens/searchScreen.dart';
import 'package:beatbox/screens/settings/settingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<HiveSongModel>> allSongsNotifier = ValueNotifier([]);

final OnAudioQuery _audioQuery = OnAudioQuery();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<HiveSongModel> searchlist = allSongsNotifier.value;
TextEditingController search = TextEditingController();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    fetchSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<HiveSongModel>('songs');
    // ignore: unused_local_variable
    List<HiveSongModel> songs = box.values.toList();

    return SafeArea(
      child: Scaffold(
       appBar: CustomAppBar(
          title: 'Beat Box',
          gradientColors: [Colors.blue, Colors.purple],
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              color: Colors.white,
            ),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }
    

  
   Widget _buildBody(BuildContext context) {
    return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: MixPrimary)),
          child: Row(
            children: [
              Expanded(
                child: FutureBuilder<List<SongModel>>(
                    future:
                        _audioQuery.querySongs(), // Use _audioQuery directly
                    builder: (BuildContext context,
                        AsyncSnapshot<List<SongModel>> allsongs) {
                      if (allsongs.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (allsongs.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${allsongs.error}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (allsongs.data == null ||
                          allsongs.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Songs Found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return ListView.separated(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: QueryArtworkWidget(
                                    artworkClipBehavior: Clip.none,
                                    artworkHeight: 50,
                                    artworkWidth: 50,
                                    nullArtworkWidget: Image.asset(
                                      'assets/Images/music.jpg',
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ),
                                    id: allSongs[index].id!,
                                    type: ArtworkType.AUDIO,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      audioConverter(allSongs,
                                          index); // Uncomment this line if needed
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NowPlayingScreen(
                                                    music: allSongs[index],
                                                  )));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: KBprimary,
                                      ),
                                      child: ListTile(
                                        title: SizedBox(
                                          height: 20,
                                          child: Text(
                                            allsongs.data![index].title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        subtitle: SizedBox(
                                          height: 20,
                                          child: Text(
                                            allsongs.data![index].artist ??
                                                'unknown',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            maxLines: 1,
                                          ),
                                        ),
                                        trailing: PopupMenuButton(
                                          icon: const Icon(
                                            Icons.more_vert,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              PopupMenuItem(
                                                value: 'favorites',
                                                child: fav.value.contains(
                                                        allSongs[index])
                                                    ? const Text(
                                                        'Remove from favorites')
                                                    : const Text(
                                                        'Add to favorites'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'playlist',
                                                child: Text('Add to playlist'),
                                              ),
                                            ];
                                          },
                                          onSelected: (String value) {
                                            if (value == 'favorites') {
                                              if (fav.value
                                                  .contains(allSongs[index])) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Confirmation'),
                                                      content: const Text(
                                                          'Are you sure you want to remove the song from favorites?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            removeFromFav(
                                                                allSongs[index]
                                                                    .id!);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content:
                                                                    const Text(
                                                                  'Song is removed from favorites successfully',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                backgroundColor:
                                                                    Colors.red,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                addToFavorites(
                                                    allSongs[index].id!);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                      'Song added to favorites successfully',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else if (value == 'playlist') {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddToPlaylistsScreen(
                                                    music: allSongs[index],
                                                ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          itemCount: allsongs.data!.length,
                        );
                      }
                    }),
              ),
            ],
          ),
    );
  }
}
Future<void> fetchSongs() async {
  List<SongModel> fetchSong = await audioQuery.querySongs();
  List<HiveSongModel> songs = [];
  for (SongModel element in fetchSong) {
    songs.add(
      HiveSongModel(
        name: element.displayNameWOExt,
        artist: element.artist,
        duration: element.duration,
        id: element.id,
        uri: element.uri,
      ),
    );
  }

  // Set the new song list to the notifier
  allSongsNotifier.value = songs;
}
