import 'package:book_finder/components/popup_deletion_dialog.dart';
import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/models/book.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'library_tile_widget.dart';

class LibraryListWidget extends StatefulWidget {
  // Constraints for the box
  BoxConstraints constraints;

  // search query entered in search field
  String searchQuery;

  LibraryListWidget(this.constraints, this.searchQuery);

  @override
  _LibraryListWidgetState createState() => _LibraryListWidgetState();
}

class _LibraryListWidgetState extends State<LibraryListWidget> {
  /// instance of firestore database controller
  FirestoreController _firestoreController = FirestoreController();

  /// List of filtered to be displayed books
  List<Dismissible> _filterDocuments(List<QueryDocumentSnapshot> docs){
    // List that contains the filtered docs
    List<Dismissible> filteredList = [];

    // filter docs
    docs.forEach((doc) {
      // Convert documents to books
      Book displayedBook = doc.data() as Book;
      displayedBook.id = doc.id;

      // Check if book matches query
      if(displayedBook.contains(widget.searchQuery)){
        filteredList.add(
            Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(Icons.delete),
              ),
              key: Key(displayedBook.id),
              confirmDismiss: (DismissDirection direction) async{
                return await popupDeletionDialog(context);
              },
              onDismissed: (DismissDirection direction) async {
                await _firestoreController.deleteBook(displayedBook.id);
              },
              child: LibraryTileWidget(book: displayedBook, maxHeight: widget.constraints.maxHeight, maxWidth: widget.constraints.maxWidth),
            )
        );
      }
    });
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreController.libraryRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Check for errors in connection to firestore
          if (snapshot.hasError) {
            return Text('The library seems to be offline, please contact your librarian!');
          }
          // waiting for firestore connection
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
