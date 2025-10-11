import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:flutter_favorite_places_app/models/place.dart';

// Riverpod notifier to be used for adding favorite places
class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [];

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
    state = [newPlace, ...state];
  }
}

// Provides a 'provider' that stores a List<Place>
final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  UserPlacesNotifier.new,
);
