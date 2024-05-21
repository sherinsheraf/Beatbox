import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider package
import 'screens/introScreen.dart';
import 'package:beatbox/database/model/songModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  
  if (!Hive.isAdapterRegistered(HiveSongModelAdapter().typeId)) {
    Hive.registerAdapter(HiveSongModelAdapter());
  }
   if (!Hive.isAdapterRegistered(FavoriteModelAdapter().typeId)) {
      Hive.registerAdapter(FavoriteModelAdapter());
    }
     if (!Hive.isAdapterRegistered(PlayListModelAdapter().typeId)) {
      Hive.registerAdapter(PlayListModelAdapter());
    }

  await Hive.openBox<HiveSongModel>('songs');
  
  // Add a song to the database
 // await MainPage.addSongToDatabase('Song Name', 'Artist Name', 180, 1, 'song_uri');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Music App',
      
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroPage(), // Set MainPage as the initial route
    );
  }
}
