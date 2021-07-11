import 'package:book_finder/views/library_view.dart';
import 'package:flutter/material.dart';

void main() {
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
