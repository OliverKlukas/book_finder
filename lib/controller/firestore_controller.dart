import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Database controller that enables all Firestore-related backend operations.
class FirestoreController {
  /// Firestore reference that allows automatic conversion between Books and Documents.
  final libraryRef =
      FirebaseFirestore.instance.collection('library').withConverter<Book>(
            fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
            toFirestore: (book, _) => book.toJson(),
          );

  /// Adds a new book to the firestore library.
  Future<void> addBook(Book book) {
    return libraryRef.add(book);
  }

  /// Deletes a book from the firestore library.
  Future<void> deleteBook(String bookId) {
    return libraryRef.doc(bookId).delete();
  }

  /// Updates a book in the firestore library.
  Future<void> updateBook(Book book) {
    return libraryRef.doc(book.id).update(book.toJson());
  }

  /// Resets the firestore library to a default state with pre-filled book data.
  Future<void> reset() async {
    // Delete all currently stored books in library.
    var snapshots = await libraryRef.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    // Add my bookshelf to the firestore library.
    for (Book book in bookShelf) {
      await addBook(book);
    }
  }
}
