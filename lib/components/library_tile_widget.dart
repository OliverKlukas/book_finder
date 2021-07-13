import 'package:book_finder/models/book.dart';
import 'package:book_finder/views/details_view.dart';
import 'package:book_finder/views/publish_view.dart';
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

/// Widget: library tile
class LibraryTileWidget extends StatelessWidget {
  LibraryTileWidget({
    Key? key,
    required this.book,
    required this.maxWidth,
    required this.maxHeight,
  }) : super(key: key);

  // size dimensions to ensure responsive design
  double maxHeight;
  double maxWidth;

  // book to show in tile
  Book book;

  /// method to enable responsive tile scaling
  double _responsiveSize(){
    // landscape format
    if(maxWidth > maxHeight){
      return maxHeight/6 > 100.0 ? maxHeight/6 : 100.0;
    }
    // portrait format
    else{
      return maxWidth/6 > 100.0 ? maxWidth/6 : 100.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
          title: SizedBox(
            height: _responsiveSize(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0,
                  child: CircleAvatar(
                    backgroundImage: Image.asset(
                            'images/${book.genre.toLowerCase().replaceAll(' ', '')}.png')
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
            onSelected: (_){
              // TODO: FRONTEND DESIGN - maybe make a selectable list tile with a popup button on appbar for editing or? because then mobile looks better!
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublishView(book),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
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
        )
    );
  }
}
