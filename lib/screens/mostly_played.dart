import 'package:beatbox/custom_class/custom_widget.dart';
import 'package:beatbox/database/functions.dart';
import 'package:beatbox/database/model/song_model.dart';

import 'package:beatbox/screens/now_playing_screen.dart';
import 'package:beatbox/widgets/mini_player.dart';
import 'package:flutter/material.dart';


class MostlyPlayed extends StatelessWidget {
  const MostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Mostly Played',
          gradientColors: [Colors.blue, Colors.purple],
        ),
        body: CustomBackground(
          child: ValueListenableBuilder(
            valueListenable: mostPlayedList,
            builder: (context, value, child) {
              if (mostPlayedList.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Please play some songs...',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: mostPlayedList.value.length,
                  itemBuilder: (context, index) {
                    final song = mostPlayedList.value[index];
                    return CustomSongListTile(
                      song: song,
                      onTap: () {
                        audioConverter(mostPlayedList.value, index);
                        navigateToNowPlayingScreen(context, song);
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

  void navigateToNowPlayingScreen(BuildContext context, HiveSongModel song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(music: song),
      ),
    );
  }
}
