// ignore_for_file: unnecessary_null_comparison, must_be_immutable, unused_local_variable, unused_import, use_build_context_synchronously, unnecessary_string_interpolations

import 'dart:io';
import 'package:mp5/utils/session_manager.dart';

import '../views/github.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_data.dart';
import '../views/login_screen.dart';
import '../views/repository.dart';
import '../views/repository_information.dart';
import 'package:provider/provider.dart';
import '../models/favorites.dart';
import '../views/favorites_page.dart';

const String apiUrl = "https://api.github.com/users";
const String webUrl = "https://github.com";
List<dynamic> repositories = [];

class GithubAPI {
  static Future<List<dynamic>> fetchUserRepositories(String username) async {
    final response = await http.get(Uri.parse('$apiUrl/$username/repos'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return List.empty();
      }
}

class HomeScreen extends StatefulWidget {
  String username;
  bool isLoggedIn;
  String email;
  HomeScreen(this.isLoggedIn, this.username, this.email, {super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }


   Future<void> fetchRepositories() async {
    try {
      final data = await GithubAPI.fetchUserRepositories(widget.username);
      setState(() {
        repositories = data;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var favoritesList = Provider.of<Favorites>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Github"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search here for more repositories',
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${widget.username}'),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                 backgroundImage: NetworkImage(repositories.isNotEmpty ? repositories[0]['owner']['avatar_url'] : "https://example.com/profile-image.jpg"),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              selected: selectedIndex == 1,
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FavoritesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              selected: selectedIndex == 4,
              onTap: () {
                SessionManager.clearSession();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ));
              },
            ),
          ],
        ),
      ),
      body: RepositoryListView(
        repositories: repositories,
        username: widget.username,
        favoritesList: favoritesList,
      ),
    );
  }
}

class RepositoryListView extends StatelessWidget {
  final List<dynamic> repositories;
  final String username;
  final Favorites favoritesList;

  RepositoryListView({
    required this.repositories,
    required this.username,
    required this.favoritesList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repo = repositories[index];
        return ListTile(
          title: Text(repo['name']),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => RepositoryInformation(username, repo['name']),
            ));
          },
          trailing: IconButton(
            key: Key('icon_${repo['name']}'),
            icon: favoritesList.items.contains(repo['name'])
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            onPressed: () {
              !favoritesList.items.contains(repo['name'])
                  ? favoritesList.add(repo['name'])
                  : favoritesList.remove(repo['name']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(favoritesList.items.contains(repo['name'])
                      ? 'Added to favorites.'
                      : 'Removed from favorites.'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}


class DataSearch extends SearchDelegate<String> {

  @override
  Widget buildResults(BuildContext context) {
    var favoritesList = Provider.of<Favorites>(context);
    return FutureBuilder<List<dynamic>>(
      future: GithubAPI.fetchUserRepositories(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          final repositories = snapshot.data!;
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              final repo = repositories[index];
              return ListTile(
                title: Text(repo['name']),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => RepositoryInformation(query, repo['name']),
                  ));
                },
                trailing: IconButton(
              key: Key('icon_${repo['name']}'),
              icon: favoritesList.items.contains(repo['name'])
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                !favoritesList.items.contains(repo['name'])
                    ? favoritesList.add(repo['name'])
                    : favoritesList.remove(repo['name']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(favoritesList.items.contains(repo['name'])
                        ? 'Added to favorites.'
                        : 'Removed from favorites.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
              );
            },
          );
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = [];
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final repo = repositories[index];
        return ListTile(
          title: Text(repo['name']),
          onTap: () {
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }
}