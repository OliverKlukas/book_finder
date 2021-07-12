import 'package:book_finder/components/library_list_widget.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  // TODO: obsolete when calling firestoreController from EditView!
  /** // Mock book library
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

  /// method that will start the process of publishing/editing new books and capture the added element
  void navigateAndPublishBooks(Book? editBook, int? index) async {
    // receive new book from PublishView after validation
    final Book? newBook = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editBook == null ? PublishView.empty() : PublishView(editBook),
      ),
    );

    // add newly published book to collection
    setState(() { //TODO: improve this with proper backend
      // check that publish form wasn't exited early
      if (newBook != null) {
        // Replace an already existing book with edited version
        if(editBook != null){
          _displayedBooks.remove(editBook);
          _allBooks.remove(editBook);
        }
        // Publish book
        if(index != null){
          _displayedBooks.insert(index, newBook);
          _allBooks.insert(index, newBook);
        }
        else{
          _displayedBooks.insert(0, newBook);
          _allBooks.insert(0, newBook);
        }
      }
    });
  }**/

  // editing controller for search
  TextEditingController _editingController = TextEditingController();

  // TODO: obsolete when using query instead!
  /// method to search the library for books/authors/genres
  /**void _filterSearchResults(String query) {
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
  } **/

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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                child: TextField(
                  onChanged: (value) {
                    //_filterSearchResults(value); //TODO: query
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
                child: LibraryListWidget(constraints),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigateAndPublishBooks(null, null); TODO: no need to come back anymore!
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
