import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:flutter_favorite_places_app/models/place.dart';

// This should be changed to a dart style getter I think?
Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  // Second parameter for join is the database name (that I chose)
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, verison) {
      return db.execute(
        'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    // Should be increased if the query ever changes, so that a new DB file
    // is created if the DB structure changes
    version: 1,
  );
  return db;
}

// Riverpod notifier to be used for adding favorite places
class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [];

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    // Get OS specific data storage path (using path_provider)
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    // Get only the name of the file (ex. foo.dart)
    final fileName = path.basename(image.path);
    // Path MUST include target path AND file name
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatabase();
    final values = {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    };
    db.insert('user_places', values);

    state = [newPlace, ...state];
  }
}

// Provides a 'provider' that stores a List<Place>
final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  UserPlacesNotifier.new,
);
