import 'package:beatbox/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
//import 'package:google_fonts/google_fonts.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final String title;
  final List<Widget>? actions; 
  final List<Color> gradientColors;
  final Widget? leading; // Optional actions parameter

  CustomAppBar({required this.title,required this.gradientColors, this.leading,this.actions});
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      actions: actions,
      backgroundColor: Kprimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50),
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
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? TextStyle(),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////



class GradientContainer extends StatelessWidget {
  final Widget child;

  const GradientContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [Colors.blue, Colors.purple], // Replace with your gradient colors
        ),
      ),
      child: child,
    );
  }
}

class SongTile extends StatelessWidget {
  final SongModel song;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onAddToFavorites;
  final VoidCallback onRemoveFromFavorites;
  final VoidCallback onAddToPlaylist;

  const SongTile({
    Key? key,
    required this.song,
    required this.isFavorite,
    required this.onTap,
    required this.onAddToFavorites,
    required this.onRemoveFromFavorites,
    required this.onAddToPlaylist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: KBprimary,
        ),
        child: ListTile(
          leading: ClipRRect(
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
              id: song.id,
              type: ArtworkType.AUDIO,
            ),
          ),
          title: SizedBox(
            height: 20,
            child: Text(
              song.title,
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
                  child: isFavorite
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
                isFavorite ? onRemoveFromFavorites() : onAddToFavorites();
              } else if (value == 'playlist') {
                onAddToPlaylist();
              }
            },
          ),
        ),
      ),
    );
  }
}






