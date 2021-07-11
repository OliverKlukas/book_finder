import 'package:book_finder/models/book.dart';
import 'package:book_finder/views/details_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _BookDescription extends StatelessWidget {
  const _BookDescription({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                'written by ${book.author}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                book.genre,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Published on ' + DateFormat('dd.MM.y').format(book.date).toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LibraryTileWidget extends StatelessWidget {
  const LibraryTileWidget({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
          title: SizedBox(
            height: 140, // TODO: with that I should be able to control the size of the list depending on web/mobile
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0,
                  child: CircleAvatar(
                    backgroundImage: Image.asset(
                            'images/${book.genre.toLowerCase().replaceAll(' ', '')}.png')
                        .image,
                    maxRadius: 70,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _BookDescription(book: book),
                  ),
                )
              ],
            ),
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
}
