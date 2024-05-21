import 'package:beatbox/database/functions.dart';
import 'package:beatbox/utils/colors.dart';
import 'package:beatbox/widgets/miniPlayer.dart';
import 'package:beatbox/screens/nowPlayingScreen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  @override
  void initState() {
    //setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Kprimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: MixPrimary, // Assuming MixPrimary is a List<Color>
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'My favorites',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: MixPrimary)),
          child: ValueListenableBuilder(
            valueListenable: fav,
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                    child: fav.value.isEmpty
                        ? const Center(
                            child: Text('No favorite songs available'),
                          )
                        : ListView.builder(
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
                                            'assets/Images/dummy.jpg',
                                            fit: BoxFit.cover,
                                            width: 70,
                                            height: 70,
                                          ),
                                          id: fav.value[index].id!,
                                          type: ArtworkType.AUDIO),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          audioConverter(fav.value, index);

                                          // Move the navigation to NowPlayingScreen here
                                          navigateToNowPlayingScreen();
                                        },
                                        child: Container(
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Kprimary),
                                          child: ListTile(
                                            title: Text(
                                              fav.value[index].name!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              maxLines: 1,
                                            ),
                                            subtitle: Text(
                                                fav.value[index].artist ??
                                                    'unknown',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                maxLines: 1),
                                            trailing: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (fav.value.contains(
                                                      fav.value[index])) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
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
                                                                removeFromFav(fav
                                                                    .value[
                                                                        index]
                                                                    .id!);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Song is removed from favorites successfully'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
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
                                                        fav.value[index].id!);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Song added to favorites successfully'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: fav.value.length),
                  ),
                ],
              );
            },
          ),
        ),
        bottomSheet: const MiniPlayer(),
      ),
    );
  }

  void navigateToNowPlayingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NowPlayingScreen(),
      ),
    );
  }
}
