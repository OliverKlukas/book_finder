import 'package:book_finder/models/Book.dart';
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
  // widget of details view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(widget.book.title,
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
            Text(widget.book.title),
            Text(widget.book.author),
            Text(DateFormat('dd.MM.y').format(widget.book.date).toString(),),
            Text(widget.book.genre),
            Text(widget.book.description),
          ],
        ),
      ),
    );
  }
}