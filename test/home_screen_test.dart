// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mp5/models/favorites.dart';
import 'package:mp5/views/home_screen.dart';

class MockClient extends Mock implements http.Client {}

class MockHttpClient extends Fake implements Client {
 final Map<String, String> data;

 MockHttpClient(this.data);

 @override
 Future<String> get(Uri url) async {
    final String urlString = url.toString();
    final String responseString = data[urlString]!;

    if (responseString == null) {
      throw Exception('No mock data found for URL: $urlString');
    }

    return Future.value(responseString);
 }
}

class Client {
  final http.Client httpClient;

  Client({required this.httpClient});

  Future<String> get(Uri url) async {
      final response = await httpClient.get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data');
      }
  }
}

void main() {
  testWidgets('HomeScreen displays app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => Favorites(),
        child: MaterialApp(
          home: HomeScreen(true, 'testUser', 'test@example.com'),
        ),
      ),
    );

    expect(find.text('Github'), findsOneWidget);
  });

  group('HTTP requests', () {
    final Map<String, String> data = {
      'https://api.example.com/data': '{"data": "example data"}',
      'https://api.example.com/user': '{"username": "exampleuser", "email": "exampleuser@example.com"}',
    };

    final client = MockHttpClient(data);

    test('should return mock data for correct URL', () async {
      final response = await client.get(Uri.parse('https://api.example.com/data'));
      expect(response, data['https://api.example.com/data']);
    });
  });
  
}