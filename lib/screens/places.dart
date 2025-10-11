import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/providers/user_places.dart';
import 'package:flutter_favorite_places_app/screens/add_place.dart';
import 'package:flutter_favorite_places_app/widgets/places_list.dart';

// Like statless widget for riverpod
class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  // Not set initially when class is instantiated
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    // Loads places from DB, updates state of provider, and places that in the future variable
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    // Stores the list of places when riverpod detects a place was added through the AddPlaceScreen
    final List<Place> userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Pushes AddPlaceScreen onto the stack (displaying add place screen)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PlacesList(
                  places: userPlaces,
                ),
        ),
      ),
    );
  }
}
