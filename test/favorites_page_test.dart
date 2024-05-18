import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mp5/models/favorites.dart';
import 'package:mp5/views/favorites_page.dart';

class MockFavorites extends Mock implements Favorites {}

void main() {
   testWidgets('Favorites Page', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => Favorites(),
      child: const MaterialApp(
        home: FavoritesPage(),
      ),
    ));

    expect(find.byType(FavoritesPage), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
 });

  testWidgets('FavoriteItemTile', (WidgetTester tester) async {
    final itemName = 'Test Item';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteItemTile(itemName),
        ),
      ),
    );

    expect(find.byType(FavoriteItemTile), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.text(itemName), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
 });

  testWidgets('Remove from favorites', (WidgetTester tester) async {
    final favorites = Favorites();
    favorites.add('Test Item');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: favorites,
        child: const MaterialApp(
          home: Scaffold(
            body: FavoriteItemTile('Test Item'),
          ),
        ),
      ),
    );

    expect(favorites.items.length, 1);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(favorites.items.length, 0);
 });

  testWidgets('Remove all from favorites', (WidgetTester tester) async {
    final favorites = Favorites();
    favorites.add('Test Item 1');
    favorites.add('Test Item 2');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: favorites,
        child: MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: favorites.items.length,
              itemBuilder: (context, index) {
                return FavoriteItemTile(favorites.items[index]);
              },
            ),
          ),
        ),
      ),
    );

    expect(favorites.items.length, 2);
    await tester.tap(find.byType(IconButton).first);
    await tester.tap(find.byType(IconButton).last);
    await tester.pumpAndSettle();
    expect(favorites.items.length, 0);
 });
}