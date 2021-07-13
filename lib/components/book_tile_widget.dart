import 'package:book_finder/components/library_list_widget.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/views/details_view.dart';
import 'package:book_finder/views/publish_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The composition of the book description of the list tiles in the book list.
class _BookDescription extends StatelessWidget {
  final Book book;

  _BookDescription({Key? key, required this.book}) : super(key: key);

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
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.0,
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
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                DateFormat('dd.MM.y').format(book.date),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18.0,
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

/// Composition and functionality of a single book tile in the [BookListWidget].
class BookTileWidget extends StatelessWidget {
  BookTileWidget({
    Key? key,
    required this.book,
    required this.maxWidth,
    required this.maxHeight,
  }) : super(key: key);

  /// Size dimensions to ensure responsive resizing of list tiles.
  final double maxHeight;
  final double maxWidth;

  /// Book to show in the list tile.
  final Book book;

  /// Decides depending on the screen ratio how large the list tiles can be scaled.
  double _responsiveSize() {
    // Displaying device is in landscape format.
    if (maxWidth > maxHeight) {
      return maxHeight / 6 > 100.0 ? maxHeight / 6 : 100.0;
    }
    // Displaying device is in portrait format.
    else {
      return maxWidth / 6 > 100.0 ? maxWidth / 6 : 100.0;
    }
  }

  /// Build a single book list tile that enables routing to edit, view and delete books.
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: ListTile(
          contentPadding:
              EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          title: SizedBox(
            height: _responsiveSize(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0,
                  child: CircleAvatar(
                    backgroundImage: Image.asset(
                            'assets/images/${book.genre.toLowerCase().replaceAll(' ', '')}.png')
                        .image,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _BookDescription(book: book),
                  ),
                )
              ],
            ),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublishView(book),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Edit',
                child: Text('Edit'),
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
        ));
  }
}
