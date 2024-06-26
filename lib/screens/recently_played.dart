import 'package:beatbox/custom_class/custom_widget.dart';
import 'package:beatbox/database/functions.dart';
import 'package:beatbox/widgets/mini_player.dart';
import 'package:beatbox/screens/now_playing_screen.dart';
import 'package:flutter/material.dart';


class RecentlyPlayed extends StatelessWidget {
  const RecentlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Recently Played',
          gradientColors:  [Colors.blue, Colors.purple],
        ),
        body: _buildBody(context),
        bottomSheet: const MiniPlayer(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomBackground(
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: recentList,
              builder: (context, value, child) {
                if (recentList.value.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'Please play some songs...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final song = recentList.value[index];
                      return CustomSongListTile(
                        song: song,
                        onTap: () {
                          audioConverter(recentList.value, index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NowPlayingScreen(
                                music: song,
                              ),
                            ),
                          );
                        },
                        onSelected: (String value) {
                          if (value == 'favorites') {
                            handleFavorite(song, context);
                          } else if (value == 'playlist') {
                            handlePlaylist(song, context);
                          }
                        },
                      );
                    },
                    itemCount: recentList.value.length,
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
