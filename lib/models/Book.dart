import 'package:flutter/material.dart';

/// Data Model for a single book
class Book {
  final String title;
  final String author;
  final String date;
  final String genre;
  final String description;

  Book({
    required this.title,
    required this.author,
    required this.date,
    required this.genre,
    required this.description,
  });

  // Enable search for books based on title, author, genre or description
  bool contains(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        author.toLowerCase().contains(query.toLowerCase()) ||
        description.toLowerCase().contains(query.toLowerCase()) ||
        genre.toLowerCase().contains(query.toLowerCase());
  }

}