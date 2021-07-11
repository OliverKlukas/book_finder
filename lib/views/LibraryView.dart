import 'package:book_finder/components/BookCardWidget.dart';
import 'package:book_finder/components/PopupDeletionDialog.dart';
import 'package:book_finder/models/Book.dart';
import 'package:book_finder/views/PublishView.dart';
import 'package:flutter/material.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  // Mock book library
  List<Book> _allBooks = [
    Book(title: 'Life 3.0: Being Human in the Age of Artificial Intelligence', author: 'Max Tegmark', date: DateTime.parse('2017-08-23'), genre: 'Science', description: 'Description...'),
    Book(title: 'Permanent Record', author: 'Edward Snowden', date: DateTime.parse('2019-09-17'), genre: 'Technical', description: 'Description...'),
    Book(title: 'Start-up Nation: The story of Israel\'s Economic Miracle', author: 'Dan Senor and Saul Singer', date: DateTime.parse('2011-09-01'), genre: 'History', description: 'Description...'),
    Book(title: 'The 4-Hour Work Week', author: 'Timothy Ferris', date: DateTime.parse('2007-04-24'), genre: 'Technical', description: 'Description...'),
    Book(title: '1984', author: 'George Orwell', date: DateTime.parse('1984-08-06'), genre: 'Science Fiction', description: 'Description...'),
    Book(title: 'Sapiens: A Brief History of Humankind', author: 'Yuval Noah Harari', date: DateTime.parse('2015-04-30'), genre: 'History', description: 'Description...')
  ];

  // list of displayed books
  List<Book> _displayedBooks = [];

  // initialize view
  @override
  void initState() {
    _displayedBooks.addAll(_allBooks);
    super.initState();
  }

  // method that will start the process of publishing new books and capture the added element
  void _navigateAndPublishBooks(BuildContext context) async {
    // receive new book from PublishView after validation
    final Book newBook = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublishView(),
      ),
    );

    // add newly published book to collection
    setState(() {
      _displayedBooks.add(newBook);
    });
  }

  // editing controller for search
  TextEditingController editingController = TextEditingController();

  // method to search the library for books/authors/genres
  void filterSearchResults(String query) {
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

  // build the complete library view widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Library',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
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
                        return await popupDeletionDialog(index, context);
                      },
                      onDismissed: (DismissDirection direction) async {
                        setState(() {
                          _displayedBooks.removeAt(index);
                        });
                      },
                      child: bookCard(_displayedBooks[index], context), // TODO: is this the right way or should I make the BookCardWidget class it's own stateful widget?
                    );
                  },
                ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
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

