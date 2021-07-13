import 'package:book_finder/views/library_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // Ensure WidgetsBindings are initialized before Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FlutterFire before using any Firebase services.
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(
          primarySwatch:
              Colors.blueGrey, // Main Color Schema for non-white colored items.
          iconTheme: IconThemeData(
            // Ensure AppBar icons are visible on white backgrounds.
            color: Colors.black,
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )),
      home: LibraryView(),
    );
  }
}
