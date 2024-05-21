import 'package:beatbox/database/functions.dart';
import 'package:beatbox/database/model/songModel.dart';
import 'package:beatbox/widgets/navigationBottomBar.dart';
import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'homePage.dart';
import 'package:google_fonts/google_fonts.dart';

late List<HiveSongModel> allSongs;

class IntroPage extends StatefulWidget {
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
            'assets/Images/background.jpg', // Replace with your background image path
            fit: BoxFit.cover,
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text: Get your favourite
                Text(
                  'Explore Your Perfect Soundtrack',
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Text: Play music
                Text(
                  'Discover. Play. Repeat',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 40),
                // Button: Get Connected
                ElevatedButton(
                  onPressed: () {
                    // Navigate to HomePage when button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        // Call the goToHome function
                        goToHome(context);
                        // Return the HomePage widget
                        return HomePage();
                      }),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 131, 16, 83), // Background color
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20), // Padding
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Rounded corners
                      ),
                    ),
                  ),
                  child: Text(
                    'Get Connected',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
