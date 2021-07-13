import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  /// Reference to firestore library of books
  final libraryRef = FirebaseFirestore.instance.collection('library').withConverter<Book>(
    fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
    toFirestore: (book, _) => book.toJson(),
  );

  /// Method to add a book to the firestore library
  Future<void> addBook(Book book){
    return libraryRef.add(book);
  }

  /// Method to delete a book to the firestore library
  Future<void> deleteBook(String bookId){
    return libraryRef.doc(bookId).delete();
  }

  /// Method to update a book in the firestore library
  Future<void> updateBook(Book book){
    return libraryRef.doc(book.id).update(book.toJson());
  }

  /// Method to reset library with pre-filled data
  Future<void> reset() async {
    // Delete all books in library
    var snapshots = await libraryRef.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    // Add my bookshelf to library
    for (Book book in bookShelf){
      await addBook(book);
    }
  }
}