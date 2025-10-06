import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_favorite_places_app/models/place.dart';

class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [];

  void addPlace(String title) {
    final newPlace = Place(title: title);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  UserPlacesNotifier.new,
);
