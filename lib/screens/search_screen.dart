import 'package:beatbox/custom_class/custom_widget.dart';
import 'package:beatbox/database/functions.dart';
import 'package:beatbox/database/model/song_model.dart';
import 'package:beatbox/screens/home_page.dart';
import 'package:beatbox/screens/intro_screen.dart';
import 'package:beatbox/screens/now_playing_screen.dart';
import 'package:beatbox/screens/playlist/add_to_playlist.dart';
import 'package:beatbox/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  }) ;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<HiveSongModel> searchlist = allSongsNotifier.value;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Search',
          gradientColors: const [Colors.blue, Colors.purple],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        body: CustomBackground(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Kprimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: search,
                    onChanged: (value) {
                      setState(() {
                        searchlist = allSongs
                            .where(
                              (element) => element.name!.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                            )
                            .toList();
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                Expanded(
                  child: searchlist.isEmpty
                      ? const Center(
                          child: Text(
                            'No such songs found...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchlist.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: QueryArtworkWidget(
                                      artworkClipBehavior: Clip.none,
                                      artworkHeight: 70,
                                      artworkWidth: 70,
                                      nullArtworkWidget: Image.asset(
                                        'assets/images/dummy.jpg',
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                      ),
                                      id: searchlist[index].id!,
                                      type: ArtworkType.AUDIO,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        audioConverter(searchlist, index);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NowPlayingScreen(
                                              music: searchlist[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 70,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Kprimary,
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            searchlist[index].name!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                          ),
                                          subtitle: Text(
                                            searchlist[index].artist ?? 'unknown',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
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
                                                  child: fav.value.contains(allSongs[index])
                                                      ? const Text('Remove from favorites')
                                                      : const Text('Add to favorites'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'playlist',
                                                  child: Text('Add to playlist'),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value) {
                                              if (value == 'favorites') {
                                                if (fav.value.contains(allSongs[index])) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Confirmation'),
                                                        content: const Text(
                                                            'Are you sure you want to remove the song from favorites?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              removeFromFav(allSongs[index].id!);
                                                             
                                                                                                                            Navigator.of(context).pop();
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: const Text(
                                                                    'Song is removed from favorites successfully',
                                                                    style: TextStyle(color: Colors.black),
                                                                  ),
                                                                  backgroundColor: Colors.red,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Remove',
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  addToFavorites(allSongs[index].id!);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                        'Song added to favorites successfully',
                                                        style: TextStyle(color: Colors.black),
                                                      ),
                                                      backgroundColor: const Color.fromARGB(255, 136, 151, 136),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else if (value == 'playlist') {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => AddToPlaylistsScreen(
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
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: KPprimary, 
      ),
    );
  }
}
