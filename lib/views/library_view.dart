import 'dart:async';

import 'package:book_finder/components/library_list_widget.dart';
import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';

/// View that lists books from the library and is the app landing page.
class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  /// Enables reactive search queries via the search TextField.
  TextEditingController _editingController = TextEditingController();

  /// Database controller to enable all Firestore-related operations.
  FirestoreController _firestoreController = FirestoreController();

  /// Timer to smoothen search animation while filtering.
  Timer? _debounce;

  /// Representation of user queries, '' represents no entered query.
  String searchQuery = '';

  /// Updates [searchQuery] to notify the [BookListWidget] about user queries.
  void _updateQuery(String query) {
    // Check for an already active debounce timer.
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    // Delay the state change of the entered query to smoothen the search experience.
    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          searchQuery = query;
        });
        return;
      } else {
        setState(() {
          searchQuery = '';
        });
      }
    });
  }

  /// Dispose [_debounce] timer to prevent continuous callback overflows.
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Builds the layout of the library book list.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        title: Text(
          'Library',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (_) async {
              // Trigger a reset of the library to initially listed books.
              await _firestoreController.reset();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Reset Library',
                child: Text('Reset Library'),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  onChanged: (query) => _updateQuery(query),
                  controller: _editingController,
                  decoration: InputDecoration(
                    hintText: "What are you searching for?",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
              Expanded(
                child: BookListWidget(constraints, searchQuery),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PublishView.empty(),
            ),
          );
        },
        tooltip: 'Add books',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
