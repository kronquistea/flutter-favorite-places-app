import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_favorite_places_app/models/place.dart';

// Riverpod notifier to be used for adding favorite places
class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [];

  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(
      title: title,
      image: image,
      location: location,
    );
    state = [newPlace, ...state];
  }
}

// Provides a 'provider' that stores a List<Place>
final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  UserPlacesNotifier.new,
);
