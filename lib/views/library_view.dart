import 'package:book_finder/components/library_tile_widget.dart';
import 'package:book_finder/components/popup_deletion_dialog.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  // Mock book library
  List<Book> _allBooks = [];

  // list of displayed books
  List<Book> _displayedBooks = [];

  // initialize view
  @override
  void initState() {
    _allBooks.addAll(libraryBooks);
    _displayedBooks.addAll(_allBooks);
    super.initState();
  }

  /// method that will start the process of publishing new books and capture the added element
  void _navigateAndPublishBooks(BuildContext context) async {
    // receive new book from PublishView after validation
    final Book? newBook = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublishView(),
      ),
    );

    // add newly published book to collection
    setState(() {
      if (newBook != null) {
      _displayedBooks.add(newBook);
      _allBooks.add(newBook);
      }
    });
  }

  // editing controller for search
  TextEditingController _editingController = TextEditingController();

  /// method to search the library for books/authors/genres
  void _filterSearchResults(String query) {
    if(query.isNotEmpty) {
      List<Book> displayQuery = [];
      _allBooks.forEach((item) {
        if(item.contains(query)) {
          displayQuery.add(item);
        }
      });
      setState(() {
        _displayedBooks.clear();
        _displayedBooks.addAll(displayQuery);
      });
      return;
    } else {
      setState(() {
        _displayedBooks.clear();
        _displayedBooks.addAll(_allBooks);
      });
    }
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
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                onChanged: (value) {
                  _filterSearchResults(value);
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
                child: ListView.builder(
                  itemCount: _displayedBooks.length,
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(Icons.delete),
                      ),
                      key: Key(_displayedBooks[index].title),
                      confirmDismiss: (DismissDirection direction) async{
                        return await popupDeletionDialog(context);
                      },
                      onDismissed: (DismissDirection direction) async {
                        setState(() {
                          _displayedBooks.removeAt(index);
                        });
                      },
                      child: LibraryTileWidget(book: _displayedBooks[index]),
                    );
                  },
                ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndPublishBooks(context);
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

