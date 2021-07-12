import 'package:book_finder/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  /// Reference to firebase library of books
  final libraryRef = FirebaseFirestore.instance.collection('library').withConverter<Book>(
    fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
    toFirestore: (movie, _) => movie.toJson(),
  );

  /// Method to add a book to the firebase library
  Future<void> addBook(Book book){
    return libraryRef.add(book);
  }

  /// Method to delete a book to the firebase library
  Future<void> deleteBook(String bookId){
    return libraryRef.doc(bookId).delete();
  }
}