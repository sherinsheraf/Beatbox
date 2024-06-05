import 'package:beatbox/database/functions.dart';
import 'package:beatbox/database/model/song_model.dart';

import 'package:beatbox/screens/playlist/add_to_playlist.dart';
import 'package:beatbox/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

//import 'package:google_fonts/google_fonts.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final String title;
  final List<Widget>? actions; 
  final List<Color> gradientColors;
  final Widget? leading; // Optional actions parameter

  const CustomAppBar({
    super.key,  // Using the super parameter shorthand for key
    required this.title,
    required this.gradientColors,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      actions: actions,
      backgroundColor: Kprimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: MixPrimary,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

      }
      

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CustomText({
     super.key, 
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? const TextStyle(),
    );
  }
}


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor; // Add this property
  final Color textColor; // Add this property

  const CustomButton({
     super.key, 
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color.fromARGB(255, 56, 0, 22), // Default Maroon color
    this.textColor = Colors.white, // Default text color
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Background color
        foregroundColor: textColor, // Text color
      ),
      child: Text(text),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////


class CustomBackground extends StatelessWidget {
  final Widget child;

const CustomBackground({
    super.key,  // Using the super parameter shorthand for key
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: MixPrimary,
        ),
      ),
      child: child,
    );
  }
}
class CustomSongListTile extends StatelessWidget {
  final HiveSongModel song;
  final VoidCallback onTap;
  final Function(String) onSelected;

  const CustomSongListTile({
    super.key,
    required this.song,
    required this.onTap,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                'assets/images/music.jpg',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              id: song.id!,
              type: ArtworkType.AUDIO,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Kprimary,
                ),
                child: ListTile(
                  title: SizedBox(
                    height: 20,
                    child: Text(
                      song.name ?? '',
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
                      song.artist ?? 'unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                          child: fav.value.contains(song)
                              ? const Text('Remove from favorites')
                              : const Text('Add to favorites'),
                        ),
                        const PopupMenuItem(
                          value: 'playlist',
                          child: Text('Add to playlist'),
                        ),
                      ];
                    },
                    onSelected: onSelected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void handleFavorite(HiveSongModel song, BuildContext context) {
  if (fav.value.contains(song)) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to remove the song from favorites?'),
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
                removeFromFav(song.id!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Song removed from favorites successfully',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor:const Color.fromARGB(255, 250, 248, 248),
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
    addToFavorites(song.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Song added to favorites successfully',
          style: TextStyle(color: Color.fromARGB(255, 247, 241, 241)),
        ),
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
void handlePlaylist(HiveSongModel song, BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AddToPlaylistsScreen(music: song),
    ),
  );
}
