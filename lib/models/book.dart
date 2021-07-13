import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Data model for a single book.
class Book {
  String id;
  String title;
  String author;
  DateTime date;
  String genre;
  String description;
  Timestamp createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.genre,
    required this.description,
    required this.createdAt,
  });

  /// Ensure type safety by converting via json in backend communication.
  Book.fromJson(Map<String, Object?> json)
      : this(
          id: '',
          title: json['title']! as String,
          author: json['author']! as String,
          date:
              DateTime.parse((json['date']! as Timestamp).toDate().toString()),
          genre: json['genre']! as String,
          description: json['description']! as String,
          createdAt: json['createdAt'] as Timestamp,
        );

  /// Converts a book into a Json object.
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'date': Timestamp.fromDate(date),
      'genre': genre,
      'description': description,
      'createdAt': createdAt,
    };
  }

  /// Enables search for books based on title, author, genre or publication year/month.
  bool contains(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        author.toLowerCase().contains(query.toLowerCase()) ||
        DateFormat('M.y')
            .format(date)
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()) ||
        genre.toLowerCase().contains(query.toLowerCase());
  }
}
