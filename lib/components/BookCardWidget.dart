// card of a single book in list
import 'package:book_finder/models/Book.dart';
import 'package:book_finder/views/DetailsView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget bookCard(Book book, BuildContext context) {
  return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: Image.asset('images/${book.genre.toLowerCase().replaceAll(' ', '')}.png').image,
              maxRadius: 70,
            ),
            SizedBox(width: 16,),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(book.title, style: TextStyle(fontSize: 20),),
                    Text(book.author, style: TextStyle(fontSize: 16),),
                    Text(DateFormat('dd.MM.y').format(book.date).toString(), style: TextStyle(fontSize: 16),),
                    Text(book.genre, style: TextStyle(fontSize: 16),),
                    SizedBox(height: 6,),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsView(book),
            ),
          );
        },
      )
  );
}
