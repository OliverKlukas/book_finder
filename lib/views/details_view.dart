import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsView extends StatefulWidget {
  // hand-over book for detailed view
  Book book;

  DetailsView(this.book);

  @override
  State<StatefulWidget> createState() => new _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  /// instance of firestore database controller
  FirestoreController _firestoreController = FirestoreController();

  /// Method to handle menu action to edit/delete the book
  Future<void> handleMenuAction(String action) async {
    switch (action) {
      case 'Edit': {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublishView(widget.book),
          ),
        );
        setState(() {});
      }
        break;
      case 'Delete':{
        // await deletion
        await _firestoreController.deleteBook(widget.book.id);
        // back to library view
        Navigator.pop(context);
      }
        break;
    }
  }

  /// Widget: widget of details view
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
            onSelected: handleMenuAction,
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
                top: constraints.maxHeight / 20,
                bottom: constraints.maxHeight / 20),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Container(
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
