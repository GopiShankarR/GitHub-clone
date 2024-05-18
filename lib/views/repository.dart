// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../views/favorites_page.dart';
import 'package:provider/provider.dart';
import '../models/favorites.dart';

const String apiUrl = "https://api.github.com/users";
const String webUrl = "https://github.com";

class Repository extends StatefulWidget {
  String loggedInUsername;
  Repository(this.loggedInUsername, {super.key});

  @override
  State<Repository> createState() => _RepositoryState();
}

class _RepositoryState extends State<Repository> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (_) => Favorites(),
      child: Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
        centerTitle: true,
        actions: [
          IconButton(
            key: const ValueKey('Favorites'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                  const FavoritesPage())
                );
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => ItemTile(index),
      )
    ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final int itemNo;

  const ItemTile(this.itemNo, {super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
        ),
        title: Text(
          'Item $itemNo',
          key: Key('text_$itemNo'),
        ),
      ),
    );
  }
}
