

import 'package:beatbox/screens/favourites.dart';
import 'package:beatbox/screens/homePage.dart';
import 'package:beatbox/screens/mostlyPlayed.dart';
import 'package:beatbox/screens/playlist/playlist.dart';
import 'package:beatbox/screens/recentlyPlayed.dart';
import 'package:beatbox/utils/colors.dart';
import 'package:beatbox/widgets/miniPlayer.dart';
import 'package:flutter/material.dart';

final ValueNotifier<int> _currentIndex = ValueNotifier(0);

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({super.key});

  final screen = [
    const HomePage(),
    const RecentlyPlayed(),
    const Playlist(),
    const MostlyPlayed(),
    const MyFavorites(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (context, updatedIndex, child) {
            return screen[updatedIndex];
          },
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Kprimary),
        child: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (BuildContext context, int updatedindex, child) {
            return BottomNavigationBar(
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black,
              currentIndex: updatedindex,
              // Set the background color to purple
              onTap: (index) {
                _currentIndex.value = index;
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 28,
                  ),
                  label: 'Home', //got to allsongs
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.library_music,
                    size: 28,
                  ),
                  label: 'Recent',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.playlist_add,
                    size: 28,
                  ),
                  label: 'PlayList',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    size: 28,
                  ),
                  label: 'Mosly Played ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    size: 28,
                  ),
                  label: 'Favorite',
                ),
              ],
            );
          },
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}