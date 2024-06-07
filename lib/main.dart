
import 'package:beatbox/database/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider package
import 'screens/intro_screen.dart';


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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({
     super.key,  // Add the named key parameter
  });
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Music App',
      
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:const IntroPage(), // Set MainPage as the initial route
    );
  }
}
