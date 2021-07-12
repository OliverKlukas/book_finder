import 'package:book_finder/controller/firebase_connection.dart';
import 'package:book_finder/views/library_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  // Initialize firebase connection before starting the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      home: LibraryView(),
    );
  }
}
