import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/favorites.dart';

void main() {
  late Favorites favorites;

  setUp(() {
    favorites = Favorites();
  });

  test('Adding an item should increase the items list', () {
    final itemToAdd = 'Item 1';
    favorites.add(itemToAdd);
    expect(favorites.items.contains(itemToAdd), true);
  });

  test('Removing an added item should decrease the items list', () {
    final itemToAdd = 'Item 2';
    favorites.add(itemToAdd);
    expect(favorites.items.contains(itemToAdd), true);

    favorites.remove(itemToAdd);
    expect(favorites.items.contains(itemToAdd), false);
  });

  test('Removing a non-existing item should not change the items list', () {
    final itemToAdd = 'Item 3';
    final nonExistingItem = 'Non-existent';

    favorites.add(itemToAdd);
    expect(favorites.items.contains(itemToAdd), true);

    favorites.remove(nonExistingItem);
    expect(favorites.items.contains(itemToAdd), true);
  });

  test('Calling remove on an empty list should not throw an error', () {
    final nonExistingItem = 'Non-existent';

    expect(() => favorites.remove(nonExistingItem), returnsNormally);
  });

  test('Items list should initially be empty', () {
    expect(favorites.items.isEmpty, true);
  });
}
