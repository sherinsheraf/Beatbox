
import 'package:beatbox/custom_class/custom_widget.dart';
import 'package:beatbox/database/functions.dart';
import 'package:beatbox/database/model/song_model.dart';
import 'package:beatbox/screens/intro_screen.dart';
import 'package:beatbox/screens/now_playing_screen.dart';
import 'package:beatbox/screens/search_screen.dart';
import 'package:beatbox/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<HiveSongModel>> allSongsNotifier = ValueNotifier([]);

final OnAudioQuery _audioQuery = OnAudioQuery();

class HomePage extends StatefulWidget {
  const HomePage({
    super.key, // Include key as a super parameter
  });

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
          gradientColors: const [Colors.blue, Colors.purple],
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
  return CustomBackground(
    child: Row(
      children: [
        Expanded(
          child: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(),
            builder: (BuildContext context, AsyncSnapshot<List<SongModel>> allsongs) {
              if (allsongs.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (allsongs.hasError) {
                return Center(
                  child: Text(
                    "Error: ${allsongs.error}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else if (allsongs.data == null || allsongs.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No Songs Found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, index) => CustomSongListTile(
                    song: allSongs[index],
                    onTap: () {
                      audioConverter(allSongs, index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NowPlayingScreen(music: allSongs[index]),
                        ),
                      );
                    },
                    onSelected: (String value) {
                      if (value == 'favorites') {
                        handleFavorite(allSongs[index], context);
                      } else if (value == 'playlist') {
                        handlePlaylist(allSongs[index], context);
                      }
                    },
                  ),
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemCount: allsongs.data!.length,
                );
              }
            },
          ),
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
