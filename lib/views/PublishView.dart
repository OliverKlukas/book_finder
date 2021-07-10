import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';

class PublishView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PublishViewState();
}

class _PublishViewState extends State<PublishView> {
  // list of all supported genres
  List<String> _genres = [
    'Drama', 'Fantasy', 'Novel', 'Mythology', 'Comic', 'Technical',
    'Science', 'Fable', 'Sonnet', 'Legends', 'Tragedy', 'Ballads', 'Fairy tale',
    'Romance', 'Poetry', 'Adventure', 'Mystery', 'Religion', 'Science fiction',
    'History', 'Thriller', 'Crime', 'Folklore', 'Detective', 'Horror', 'Lyrics',
    'Children\'s tale', 'Classic', 'Love story', 'Other',
  ];

  // key to validate form is filled out properly
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // widget of publish view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text('Publish a new book',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.menu_book),
              title: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter book title',
                ),
                validator: (String? value) { // TODO: add more specific validation for numbers and stuff
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid book title';
                  }
                  return null;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter author',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid author name';
                  }
                  return null;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.library_books_rounded),
              title: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter genre',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty || !_genres.contains(value)) {
                    return 'Please enter one of the proposed genres';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  // Only process the data if the form is filled out validly
                  if (_formKey.currentState!.validate()) {

                  }
                },
                child: const Text('Publish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}