import 'package:book_finder/models/book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsView extends StatefulWidget {
  // hand-over book for detailed view
  final Book book;

  const DetailsView(this.book);

  @override
  State<StatefulWidget> createState() => new _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  /// Method: handle menu click to edit/remove the book
  void _handleMenuClick(String value) {
    switch (value) {
      case 'Edit':
        {
          // TODO: edit the selected book by opening the PublishView pre-filled and then go back to the Details view, must transfer over to library view!
        }
        break;
      case 'Remove':
        {
          // TODO: remove the book and go back to the Library view
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
            onSelected: _handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Remove'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 75/100,
          child: Container(
            margin: EdgeInsets.only(top: 40.0, bottom: 30.0),
            child: ListView(children: <Widget>[
              Center(
                  child: Container(
                    width: 190.0,
                    height: 190.0,
                    margin: EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset('images/${widget.book.genre.toLowerCase().replaceAll(' ', '')}.png').image,
                      ),
                    ),
                  )
              ),
              Column(
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
                    trailing: Text('${widget.book.genre}, ${DateFormat('dd.MM.y').format(widget.book.date).toString()}'),
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text(widget.book.description),
                      ],
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
