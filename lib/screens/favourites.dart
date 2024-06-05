import 'package:beatbox/database/functions.dart';
import 'package:beatbox/database/model/song_model.dart';
import 'package:beatbox/widgets/mini_player.dart';
import 'package:beatbox/screens/now_playing_screen.dart';
import 'package:flutter/material.dart';


// Import the custom widgets and functions
import 'package:beatbox/custom_class/custom_widget.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'My Favorites',
          gradientColors: [Colors.blue, Colors.purple],
        ),
        body: CustomBackground(
          child: ValueListenableBuilder(
            valueListenable: fav,
            builder: (context, value, child) {
              if (fav.value.isEmpty) {
                return const Center(
                  child: Text('No favorite songs available'),
                );
              } else {
                return ListView.builder(
                  itemCount: fav.value.length,
                  itemBuilder: (context, index) {
                    final song = fav.value[index];
                    return CustomSongListTile(
                      song: song,
                      onTap: () {
                        audioConverter(fav.value, index);
                        navigateToNowPlayingScreen(song);
                      },
                      onSelected: (value) {
                        if (value == 'favorites') {
                          handleFavorite(song, context);
                        } else if (value == 'playlist') {
                          handlePlaylist(song, context);
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        bottomSheet: const MiniPlayer(),
      ),
    );
  }

  void navigateToNowPlayingScreen(HiveSongModel song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(music: song),
      ),
    );
  }
}
