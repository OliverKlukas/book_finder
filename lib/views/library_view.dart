import 'dart:async';

import 'package:book_finder/components/library_list_widget.dart';
import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  // editing controller for search
  TextEditingController _editingController = TextEditingController();

  // instance of firestore database controller
  FirestoreController _firestoreController = FirestoreController();

  // query library view based on user input
  String searchQuery = '';

  /// method to search the library for books/authors/genres
  void _filterSearchResults(String query) {
    if(query.isNotEmpty) {
      setState(() {
        searchQuery = query;
      });
      return;
    } else {
      setState(() {
        searchQuery = '';
      });
    }
  }

  // timer to smoothen search animation
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// build the complete library view widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        title: Text('Library',
          style: Theme.of(context).textTheme.headline1,
        ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (_) async {
                await _firestoreController.reset();
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
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
                padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                child: TextField(
                  onChanged: (query) {
                    if(_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), (){
                      _filterSearchResults(query);
                    }
                    );
                  },
                  controller: _editingController,
                  decoration: InputDecoration(
                    hintText: "What are you searching for?",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey.shade100
                        )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: LibraryListWidget(constraints, searchQuery),
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
