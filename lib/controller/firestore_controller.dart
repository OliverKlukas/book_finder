import 'package:book_finder/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  /// Reference to firesore library of books
  final libraryRef = FirebaseFirestore.instance.collection('library').withConverter<Book>(
    fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
    toFirestore: (book, _) => book.toJson(),
  );

  /// Method to add a book to the firesore library
  Future<void> addBook(Book book){
    return libraryRef.add(book);
  }

  /// Method to delete a book to the firesore library
  Future<void> deleteBook(String bookId){
    return libraryRef.doc(bookId).delete();
  }

  /// Method to update a book in the firesore library
  Future<void> updateBook(Book book){
    return libraryRef.doc(book.id).update(book.toJson());
  }
}