// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiUrl = "https://api.github.com";
const String webUrl = "https://github.com";
List<dynamic> repositoriesInfo = [];

class RepositoryInformation extends StatefulWidget {
  String username;
  final dynamic repo;
  RepositoryInformation(this.username, this.repo, {super.key});

  @override
  State<RepositoryInformation> createState() => _RepositoryInformationState();
}

class _RepositoryInformationState extends State<RepositoryInformation> {
  Map<String, dynamic> repositoryData = {};

  @override
  void initState() {
    super.initState();
    fetchUserRepositoryInformation(widget.username, widget.repo).then((data) {
      setState(() {
        repositoryData = data;
      });
    }).catchError((error) {
      repositoryData = {};
    });
  }

  Future<Map<String, dynamic>> fetchUserRepositoryInformation(String username, dynamic repo) async {
    final response = await http.get(Uri.parse('$apiUrl/repos/$username/$repo'));
    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load necessary information');
    }
  }

  String _formatDate(String date) {
    String formattedDateTime = date.substring(0, date.length - 5);
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repository Information's of ${widget.username}"),
      ),
      body: repositoryData.isNotEmpty
        ? GridView.count(
          crossAxisCount: 3,
          children: [
            _buildInfoCard('Repository', repositoryData['name']),
            _buildInfoCard('Owner', repositoryData['owner']['login']),
            _buildInfoCard('Description', repositoryData['description'] ?? 'No description available'),
            _buildInfoCard('Language', repositoryData['language'] ?? 'Unknown'),
            _buildInfoCard('Stars', repositoryData['stargazers_count'].toString()),
            _buildInfoCard('Watchers', repositoryData['watchers_count'].toString()),
            _buildInfoCard('Last Updated At', _formatDate(DateTime.parse(repositoryData['updated_at']).toUtc().toString())),
            _buildInfoCard('Last Pushed Date', _formatDate(DateTime.parse(repositoryData['pushed_at']).toUtc().toString())),
          ],
        )
      : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: Colors.blue,
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}