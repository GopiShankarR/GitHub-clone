import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mp5/views/home_screen.dart';
import 'package:mp5/models/favorites.dart';

void main() {
  group('Home Screen Test', () {
    testWidgets('Home Page Scrollable test', (WidgetTester tester) async {
      final List<Map<String, dynamic>> mockRepositories = [
        {'name': 'Repo1'},
        {'name': 'Repo2'},
        {'name': 'Repo3'},
        {'name': 'Repo4'},
        {'name': 'Repo5'},
        {'name': 'Repo6'},
        {'name': 'Repo7'},
        {'name': 'Repo8'},
        {'name': 'Repo9'},
        {'name': 'Repo10'},
        {'name': 'Repo11'},
        {'name': 'Repo12'},
        {'name': 'Repo13'},
        {'name': 'Repo14'},
        {'name': 'Repo15'},
        {'name': 'Repo16'},
        {'name': 'Repo17'},
        {'name': 'Repo18'},
        {'name': 'Repo19'},
        {'name': 'Repo20'},
        {'name': 'Repo21'},
        {'name': 'Repo22'},
        {'name': 'Repo23'},
        {'name': 'Repo24'},
        {'name': 'Repo25'},
        {'name': 'Repo26'},
        {'name': 'Repo27'},
        {'name': 'Repo28'},
        {'name': 'Repo29'},
        {'name': 'Repo30'},
        {'name': 'Repo31'},
        {'name': 'Repo32'},
        {'name': 'Repo33'},
        {'name': 'Repo34'},
        {'name': 'Repo35'},
        {'name': 'Repo36'},
      ];
      Favorites favorites = Favorites();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<Favorites>(
              create: (_) => Favorites(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
                body: RepositoryListView(
              repositories: mockRepositories,
              username: '',
              favoritesList: favorites,
            )),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.dragUntilVisible(
        find.text('Repo36'), find.byType(ListView), const Offset(0, -1000)
      );  
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Repo36'), findsOneWidget);
    });
  });
}
