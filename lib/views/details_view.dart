import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// View that displays details of a book selected from the [LibraryView].
class DetailsView extends StatefulWidget {
  final Book book;

  DetailsView(this.book);

  @override
  State<StatefulWidget> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  /// Database controller to enable all Firestore-related operations.
  FirestoreController _firestoreController = FirestoreController();

  /// Handle menu action to edit or delete the displayed book.
  Future<void> _handleMenuAction(String action) async {
    switch (action) {
      case 'Edit':
        {
          await Navigator.push(
            context,
            MaterialPageRoute(
              // The [PublishView] serves as an edit view in this case.
              builder: (context) => PublishView(widget.book),
            ),
          );
          setState(() {});
        }
        break;
      case 'Delete':
        {
          // Await deletion to avoid still seeing the deleted book in the [LibraryView].
          await _firestoreController.deleteBook(widget.book.id);
          Navigator.pop(context);
        }
        break;
    }
  }

  /// Builds a detailed view of a single book including the book description.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        title: Text(
          'Book Details',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 750.0),
            margin: EdgeInsets.only(
                // Add a responsive margin to the top and bottom of the displayed details.
                top: constraints.maxHeight / 20,
                bottom: constraints.maxHeight / 20),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Container(
                    // Add a responsive margin to the left and right of the displayed details.
                    width: constraints.maxHeight / 4,
                    height: constraints.maxHeight / 4,
                    margin: EdgeInsets.only(bottom: constraints.maxHeight / 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset(
                                'assets/images/${widget.book.genre.toLowerCase().replaceAll(' ', '')}.png')
                            .image,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          widget.book.title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('written by ${widget.book.author}'),
                        trailing: Text(
                          '${widget.book.genre},\n${DateFormat('dd.MM.y').format(widget.book.date).toString()}',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // Add a responsively resizing margin between book description and the other book details.
                            SizedBox(height: constraints.maxHeight / 40),
                            Text(widget.book.description),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
