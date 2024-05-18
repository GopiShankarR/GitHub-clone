import 'package:flutter/material.dart';

/// The [Favorites] class holds a list of favorite items saved by the user.
class Favorites extends ChangeNotifier {
  final List<String> _favoriteItems = [];

  List<String> get items => _favoriteItems;

  void add(String itemName) {
    _favoriteItems.add(itemName);
    notifyListeners();
  }

  void remove(String itemName) {
    _favoriteItems.remove(itemName);
    notifyListeners();
  }
}
