import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Data Model for a single book
class Book {
  String id;
  String title;
  String author;
  DateTime date;
  String genre;
  String description;

  /// Constructor for book to define required properties
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.genre,
    required this.description,
  });

  /// Ensure typeSafety by converting via json in backend communication
  Book.fromJson(Map<String, Object?> json)
      : this(
    id: '',
    title: json['title']! as String,
    author: json['author']! as String,
    date: DateTime.parse((json['date']! as Timestamp).toDate().toString()),
    genre: json['genre']! as String,
    description: json['description']! as String,
  );

  /// Convert book to Json object
  Map<String, Object?> toJson(){
    return {
      'id': id,
      'title': title,
      'author': author,
      'date': Timestamp.fromDate(date),
      'genre': genre,
      'description': description,
    };
  }

  /// Enable search for books based on substrings of title, author, genre or publication year/month
  bool contains(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        author.toLowerCase().contains(query.toLowerCase()) ||
        DateFormat('M.y').format(date).toString().toLowerCase().contains(query.toLowerCase()) ||
        genre.toLowerCase().contains(query.toLowerCase());
  }
}
