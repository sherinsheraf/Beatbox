

import 'package:beatbox/database/model/song_model.dart';
import 'package:beatbox/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class CheckPermission {
  static Future<bool> checkAndRequestPermissions({bool retry = false}) async {
    bool hasPermission = false;
    hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    return hasPermission;
  }
}

final OnAudioQuery audioQuery = OnAudioQuery();

class SongFetch {
  permissionRequest() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}

 fetchForRecentlyPlayed(List<HiveSongModel> allSongs) async {
  Box<int> recentDb = await Hive.openBox('recent');
  List<HiveSongModel> recentTemp = [];
  for (int element in recentDb.values) {
    for (HiveSongModel song in allSongs) {
      if (element == song.id) {
        recentTemp.add(song);
        break;
      }
    }
  }
  recentList.value = recentTemp.reversed.toList();
}

favFetch() async {
  List<FavoriteModel> favsongcheck = [];
  Box<FavoriteModel> favdb = await Hive.openBox('fav_DB');
  favsongcheck.addAll(favdb.values);
  for (var favs in favsongcheck) {
    int count = 0;
    for (var songs in allSongs) {
      if (favs.id == songs.id) {
        fav.value.insert(0, songs);
        break;
      } else {
        count++;
      }
    }
    if (count == allSongs.length) {
      var key = favs.key;
      favdb.delete(key);
    }
  }
 // fav.notifyListeners();
}

List<Audio> audioList = [];
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
bool notification = true;

audioConverter(List<HiveSongModel> songs, int index) async {
  audioList.clear();
  assetsAudioPlayer.stop();

  for (int i = 0; i < songs.length; i++) {
    audioList.add(
      Audio.file(
        songs[i].uri!,
        metas: Metas(
          title: songs[i].name,
          artist: songs[i].artist,
          id: songs[i].id.toString(),
        ),
      ),
    );
  }
  await assetsAudioPlayer.open(
    Playlist(audios: audioList, startIndex: index),
    showNotification: notification,
    notificationSettings: const NotificationSettings(
      stopEnabled: false,
    ),
    headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
  );
  assetsAudioPlayer.setLoopMode(LoopMode.playlist);
}

findCurrentSong(int playingId) {
  for (var element in allSongs) {
    if (element.id == playingId) {
      currentPlayingsong = element;
      break;
    }
  }
}

HiveSongModel? currentPlayingsong;

void addToDb({required List<HiveSongModel> songs}) async {
  final musicDb = await Hive.openBox('songs_db');
  int id = 0;

  if (musicDb.length < 1) {
    for (HiveSongModel s in songs) {
      musicDb.add(HiveSongModel(
          name: s.name,
          artist: s.artist,
          uri: s.uri,
          duration: s.duration,
          id: id));
    }
    id++;
  }

  getSongs();
}

Future<List<HiveSongModel>> getSongs() async {
  final musicDb = await Hive.openBox('songs_db');
  List<HiveSongModel> songs = [];
  if (songs.isEmpty) {
    for (HiveSongModel s in musicDb.values) {
      // print('this is form db ${s.title}');
      songs.add(s);
    }
  }

  // for (SongsModel s in songs) {
  //   print('this is form songs${s.title}');
  // }
  return songs;
}



// Favorites screen
final Logger logger = Logger();
ValueNotifier<List<HiveSongModel>> fav = ValueNotifier([]);

Future<void> addToFavorites(int id) async {
  
  try {
    final favDB = await Hive.openBox<FavoriteModel>('fav_DB');

    // Check if the item is already in the favorites database
    if (!favDB.containsKey(id)) {
      await favDB.put(id, FavoriteModel(id: id));
    }

    // Avoid duplicate entries in the favorites list
    if (fav.value.any((element) => element.id == id)) {
      return; // Item is already in the favorites list
    }

    // Find the song in allSongs and add it to the favorites
    for (var element in allSongs) {
      if (element.id == id) {
        fav.value = List.from(fav.value)..add(element);
        break; // Exit the loop once the item is found and added
      }
    }
     //fav.notifyListeners();
  } catch (e) {
    // Handle potential errors, like issues with the database
      logger.e('Error adding to favorites: $e');
}
  }
  


Future<void> removeFromFav(int id) async {
  try {
    final favDB = await Hive.openBox<FavoriteModel>('fav_DB');

    // Delete from the database
    await favDB.delete(id);

    // Remove from the favorites list
    fav.value = fav.value.where((element) => element.id != id).toList();
  } catch (e) {
    // Handle potential errors, like issues with the database
    logger.e ("Error removing from favorites: $e");
  }
}

bool favoriteChecking(int data) {
  for (var element in fav.value) {
    if (data == element.id) {
      return true;
    }
  }
  return false;
}








//RecentPlay Screen

ValueNotifier<List<HiveSongModel>> recentList = ValueNotifier([]);

recentadd(HiveSongModel song) async {
 
  Box<int> recentDb = await Hive.openBox('recent');
  List<int> temp = [];
  temp.addAll(recentDb.values);
  if (recentList.value.contains(song)) {
    recentList.value.remove(song);
    recentList.value.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentDb.deleteAt(i);
        recentDb.add(song.id as int);
        break;
      }
    }
  } else {
    recentList.value.insert(0, song);
    recentDb.add(song.id as int);
  }
  if (recentList.value.length > 10) {
    recentList.value = recentList.value.sublist(0, 10);
    recentDb.deleteAt(0);
  }
}




//mostlyplayed
fetchForMostlyPlayed(List<HiveSongModel> allSongs) async {
  final Box<int> mostPlayedDB = await Hive.openBox('MostPlayed');
  if (mostPlayedDB.isEmpty) {
    for (HiveSongModel elements in allSongs) {
      mostPlayedDB.put(elements.id, 0);
    }
  } else {
    for (int id in mostPlayedDB.keys) {
      int count = mostPlayedDB.get(id) ?? 0;
      if (count > 4) {
        for (HiveSongModel element in allSongs) {
          if (element.id == id) {
            mostPlayedList.value.add(element);
            break;
          }
        }
      }
    }
    if (mostPlayedList.value.length > 10) {
      mostPlayedList.value = mostPlayedList.value.sublist(0, 10);
    }
  }
}
ValueNotifier<List<HiveSongModel>> mostPlayedList =
    ValueNotifier<List<HiveSongModel>>([]);

mostplayedadd(HiveSongModel song) async {
  final Box<int> mostPlayedDB = await Hive.openBox('MostPLayed');
  int count = (mostPlayedDB.get(song.id) ?? 0) + 1;
  mostPlayedDB.put(song.id, count);
  if (count > 4 && !mostPlayedList.value.contains(song)) {
    mostPlayedList.value.add(song);
  }
  if (mostPlayedList.value.length > 10) {
    mostPlayedList.value = mostPlayedList.value.sublist(0, 10);
  }
}



//playlist

ValueNotifier<List<PlayListModel>> playlistnotifier = ValueNotifier([]);
void createNewPlaylist(String name) {
  // print(playlistnotifier);
  bool check = false;
  for (var element in playlistnotifier.value) {
    if (element.playListName == name) {
      check = true;
    }
  }
  if (check == false) {
    PlayListModel item = PlayListModel(playListName: name);
    addPlaylistItemToDB(item);
    playlistnotifier.value = [...playlistnotifier.value, item];
    //  print(playlistnotifier);
  }
}

//addToPlaylist
void addPlaylistItemToDB(PlayListModel item) async {
  final playlistDB = await Hive.openBox<PlayListModel>('playlist');
  playlistDB.add(item);
  retrieveAllPlaylists();
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  playlistnotifier.notifyListeners();
}

//getPlaylist
Future<void> retrieveAllPlaylists() async {
  final playlistDB = await Hive.openBox<PlayListModel>('playlist');
  playlistnotifier.value.clear();
  playlistnotifier.value.addAll(playlistDB.values);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  playlistnotifier.notifyListeners();
}

void deletePlaylistByIndex(int index) async {
  String? playlistName = playlistnotifier.value[index].playListName;
  final playlistDB = await Hive.openBox<PlayListModel>('playlist');
  for (PlayListModel elements in playlistDB.values) {
    if (elements.playListName == playlistName) {
      var key = elements.key;
      playlistDB.delete(key);
    }
  }
  playlistnotifier.value.removeAt(index);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  playlistnotifier.notifyListeners();
}

Future<void> renamePlaylistByIndex(int index, String newname) async {
  String? playListname = playlistnotifier.value[index].playListName;
  final playListDB = await Hive.openBox<PlayListModel>('PlayList');
  for (PlayListModel element in playListDB.values) {
    if (element.playListName == playListname) {
      var key = element.key;
      element.playListName = newname;
      playListDB.put(key, element);
    }
  }
  playlistnotifier.value[index].playListName = newname;
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  playlistnotifier.notifyListeners();
}

void addSongToPlaylistAndShowSnackbar(
   HiveSongModel song, String name, BuildContext context) {
  // ignore: unused_local_variable
  int indx = 0;
  bool check = false;
  List<HiveSongModel> forThisPlayList = [];

  for (var element in playlistnotifier.value) {
    if (element.playListName == name) {
      forThisPlayList = element.playlist ?? forThisPlayList;
      break;
    }
    indx++;
  }

  for (var element in forThisPlayList) {
    if (element.id == song.id) {
      check = true;
      break;
    }
  }

  if (check == false) {
    forThisPlayList.add(song);
    PlayListModel thisPlaylist =
        PlayListModel(playListName: name, playlist: forThisPlayList);
    addPlaylistToDB(thisPlaylist);

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Song added to playlist successfully',
          style: TextStyle(color: Color.fromARGB(255, 253, 251, 251)),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 8, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    Navigator.pop(context);
  } else {
    // Show error snackbar if song already exists in the playlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'The song is already added to the playlist',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 252, 250, 250),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    Navigator.pop(context);
  }
}

void addPlaylistToDB(PlayListModel playListItem) async {
  final playListDB = await Hive.openBox<PlayListModel>('PlayList');
  int index = 0;
  for (var element in playListDB.values) {
    if (element.playListName == playListItem.playListName) {
      break;
    }
    index++;
  }
  playListDB.putAt(index, playListItem);
  retrieveAllPlaylists();
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  playlistnotifier.notifyListeners();
}

void removeSongFromPlaylistAndNotify(
   HiveSongModel song, String playlisname, int index) async {
  final playlistDB = await Hive.openBox<PlayListModel>('PlayList');
  List<HiveSongModel> newlist;

  for (var element in playlistDB.values) {
    if (element.playListName == playlisname) {
      for (var elements in element.playlist!) {
        if (song.id == elements.id) {
          element.playlist!.remove(elements);
          newlist = element.playlist!;
          final newplaylist =
              PlayListModel(playListName: playlisname, playlist: newlist);
          playlistDB.putAt(index, newplaylist);
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          playlistnotifier.notifyListeners();
          break;
        }
      }
    }
  }
}