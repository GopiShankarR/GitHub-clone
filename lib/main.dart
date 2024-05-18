import 'package:flutter/material.dart';
import 'views/github.dart';
import 'package:provider/provider.dart';
import '../models/favorites.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Favorites())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Github',
        home: Github(),
      ),
    )
  );
}
