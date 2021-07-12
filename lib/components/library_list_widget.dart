import 'package:book_finder/components/popup_deletion_dialog.dart';
import 'package:book_finder/controller/firebase_connection.dart';
import 'package:book_finder/models/book.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'library_tile_widget.dart';

class LibraryListWidget extends StatefulWidget {
  // Constraints for the box
  BoxConstraints constraints;

  LibraryListWidget(this.constraints);

  @override
  _LibraryListWidgetState createState() => _LibraryListWidgetState();
}

class _LibraryListWidgetState extends State<LibraryListWidget> {
  /// instance of controller
  FirestoreController firestoreController = FirestoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreController.libraryRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Check for errors in connection to firestore
          if (snapshot.hasError) {
            return Text('The library seems to be offline, please contact your librarian!');
          }
          // load from firestore
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView(
            padding: EdgeInsets.all(10.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              String id = document.id;
              Book displayedBook = document.data() as Book;
              displayedBook.id = id; // TODO: das hier nur ein Workaround oder?
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.delete),
                ),
                key: Key(document.id),
                confirmDismiss: (DismissDirection direction) async{
                  return await popupDeletionDialog(context);
                },
                onDismissed: (DismissDirection direction) async {
                  setState(() {
                    firestoreController.deleteBook(displayedBook.id);
                  });
                },
                child: LibraryTileWidget(book: displayedBook, maxHeight: widget.constraints.maxHeight, maxWidth: widget.constraints.maxWidth),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
