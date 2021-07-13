import 'package:book_finder/components/confirm_deletion_dialog.dart';
import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'book_tile_widget.dart';

/// Enables retrieving books from the realtime database and defines their listing.
class BookListWidget extends StatefulWidget {
  /// Size constraints to enable responsive re-sizing of the book list.
  final BoxConstraints constraints;

  /// Representation of user queries, '' represents no entered query.
  final String searchQuery;

  /// Retrieve parameters from the [_LibraryViewState]. Both [constraints] and
  /// [searchQuery] are constantly updated based on screen size and user input.
  BookListWidget(this.constraints, this.searchQuery);

  @override
  _BookListWidgetState createState() => _BookListWidgetState();
}

class _BookListWidgetState extends State<BookListWidget> {
  /// Database controller to enable all Firestore-related operations.
  FirestoreController _firestoreController = FirestoreController();

  /// Returns a filtered list of books depending on the [widget.searchQuery].
  List<Dismissible> _filterDocuments(List<QueryDocumentSnapshot> documents) {
    List<Dismissible> filteredList = [];

    // Convert the retrieved Firestore documents to books and filters them.
    for (QueryDocumentSnapshot document in documents) {
      // Convert FireStore documents to books.
      Book displayedBook = document.data() as Book;
      displayedBook.id = document.id;

      // Add books that matches the current user search query to the displayed book list.
      if (displayedBook.contains(widget.searchQuery)) {
        filteredList.add(Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.delete),
          ),
          key: Key(displayedBook.id),
          confirmDismiss: (DismissDirection direction) async {
            return await confirmDeletionDialog(context);
          },
          onDismissed: (DismissDirection direction) async {
            await _firestoreController.deleteBook(displayedBook.id);
          },
          child: BookTileWidget(
              book: displayedBook,
              maxHeight: widget.constraints.maxHeight,
              maxWidth: widget.constraints.maxWidth),
        ));
      }
    }
    return filteredList;
  }

  /// Enables realtime updates of the currently stored books and builds them into a [ListView].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreController.libraryRef
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Check for errors in connection to Firestore database.
          if (snapshot.hasError) {
            return Text(
                'The library seems to be offline, please contact your librarian!');
          }
          // Display a progress indicator while the books are loaded from Firestore.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: EdgeInsets.all(10.0),
            children: _filterDocuments(snapshot.data!.docs),
          );
        },
      ),
    );
  }
}
