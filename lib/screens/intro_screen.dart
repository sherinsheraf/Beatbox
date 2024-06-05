import 'package:beatbox/custom_class/custom_widget.dart';
import 'package:beatbox/database/model/song_model.dart';
import 'package:beatbox/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:beatbox/database/functions.dart';

import 'package:beatbox/widgets/navigation_bottom_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';

late List<HiveSongModel> allSongs;

class IntroPage extends StatefulWidget {
  const IntroPage({
   super.key, // Add the named key parameter
  });
  
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/images/background.jpg', // Replace with your background image path
            fit: BoxFit.cover,
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text: Get your favourite
                CustomText(
                  text: 'Explore Your Perfect Soundtrack',
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
               const  SizedBox(height: 10),
                // Text: Play music
                CustomText(
                  text: 'Discover. Play. Repeat',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ),
               const SizedBox(height: 40),
                // Button: Get Connected
                CustomButton(
                  text: 'Beat Box',
                  backgroundColor:const Color.fromARGB(255, 99, 23, 90), // Maroon color
                  textColor:const Color.fromARGB(255, 250, 248, 250),
                  onPressed: () {
                    // Navigate to HomePage when button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        // Call the goToHome function
                        goToHome(context);
                        // Return the HomePage widget
                        return const HomePage();
                      } ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initializeApp() async {
    bool hasStoragePermission = false;
    await Future.delayed(const Duration(seconds: 1));
    hasStoragePermission = await CheckPermission.checkAndRequestPermissions();
    if (hasStoragePermission) {
      //---------------------------SongFetch-------------------------
      List<SongModel> fetchSong = await audioQuery.querySongs();
      setState(() {
        allSongs = fetchSong
            .map((element) => HiveSongModel(
                  name: element.displayNameWOExt,
                  artist: element.artist,
                  duration: element.duration,
                  id: element.id,
                  uri: element.uri,
                ))
            .toList();
      });
    }
  }
}

Future<void> goToHome(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 0));
 
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (BuildContext context) => BottomNavigationScreen()),
  );
  await fetchForRecentlyPlayed(allSongs);
  await favFetch();
  await fetchForMostlyPlayed(allSongs);
}
