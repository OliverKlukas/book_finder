import 'package:book_finder/models/Book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PublishView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PublishViewState();
}

class _PublishViewState extends State<PublishView> {
  // list of all supported genres
  List<String> _genres = [
    'Drama',
    'Fantasy',
    'Novel',
    'Mythology',
    'Comic',
    'Technical',
    'Science',
    'Fable',
    'Sonnet',
    'Legends',
    'Tragedy',
    'Ballads',
    'Fairy tale',
    'Romance',
    'Poetry',
    'Adventure',
    'Mystery',
    'Religion',
    'Science fiction',
    'History',
    'Thriller',
    'Crime',
    'Folklore',
    'Detective',
    'Horror',
    'Lyrics',
    'Childrens tale',
    'Classic',
    'Love story',
    'Other',
  ];

  // Book to publish
  Book _newBook = Book(
      title: '',
      author: '',
      date: DateTime.parse('2000-01-01'),
      genre: 'Other',
      description: '');

  // Controller to change date
  TextEditingController _date = new TextEditingController();

  // key to validate form is filled out properly
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // controller to allow genre selection overlay
  final TextEditingController _typeAheadController = TextEditingController();

  // assure genre selection bool
  bool _genreSelected = false;

  /// Title Widget: ListTile for title selection
  Widget _titleTile() {
    return ListTile(
      leading: Icon(Icons.menu_book),
      title: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter book title',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format
          final inputRestrictions = RegExp(r'^[\w\W]*$');
          if (value == null || value.isEmpty || !inputRestrictions.hasMatch(value)) {
            return 'Please enter a valid book title using [a-z,A-Z,0-9,common special characters]';
          }
          return null;
        },
        onChanged: (value) => setState(() => _newBook.title = value),
        onSaved: (value) => setState(() => _newBook.title = value!),
      ),
    );
  }

  /// Author Widget: ListTile for author selection
  Widget _authorTile() {
    return ListTile(
      leading: Icon(Icons.person),
      title: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter author',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => setState(() => _newBook.author = value),
        onSaved: (value) => setState(() => _newBook.author = value!),
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format
          final inputRestrictions = RegExp(r'^[\w\W]*$');
          if (value == null || value.isEmpty || !inputRestrictions.hasMatch(value)) {
            return 'Please enter a valid book author using [a-z,A-Z,0-9,common special characters]';
          }
          return null;
        },
      ),
    );
  }

  /// Genre Widget: ListTile for genre selection
  Widget _genreTile() {
    return ListTile(
      leading: Icon(Icons.my_library_books_outlined),
      title: TypeAheadFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            decoration: InputDecoration(
                labelText: 'Select genre from suggestions'
            )
        ),
        suggestionsCallback: (pattern) {
          return _genres.where((String element) => element.toLowerCase().contains(pattern.toLowerCase())).toList();
        },
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (String suggestion) {
          this._typeAheadController.text = suggestion;
          setState(() {
            _newBook.genre = suggestion;
            _genreSelected = true; // TODO: this is still trickable but worth fixing?
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty || !_genres.contains(value) || !_genreSelected) {
            return 'Please select a genre from the suggestion list';
          }
          return null;
        },
        onSaved: (value) => setState(() => _newBook.genre = value!),
      ),
    );
  }

  /// Date Widget: ListTile for publication date selection
  Widget _publicationDateTile() {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: GestureDetector(
        onTap: () async {
          final DateTime picked = (await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(0),
              lastDate: DateTime(2022)))!;
          if (picked != _newBook.date)
            setState(() {
              _newBook.date = picked;
              _date.text = DateFormat('dd.MM.y').format(_newBook.date);
            });
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: _date,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              hintText: 'Select publication date',
            ),
            validator: (String? value) { //TODO: hier kann eine exception geworfen werden wenn null kommt, catchen oder unbehandelt lassen, programmablauf nicht gestoert
              // Assuring only valid dates in format DD.MM.YYYY are allowed
              final inputRestrictions = RegExp(r'^[0-9]{2}\.[0-9]{2}\.[0-9]{4}$');
              if (value == null || value.isEmpty || !inputRestrictions.hasMatch(value)) {
                return 'Please select a valid publication date [DD.MM.YYYY]';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  /// Description Widget: ListTile to enter description
  Widget _descriptionTile() {
    return ListTile(
      leading: Icon(Icons.text_snippet_outlined),
      title: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: 'Enter description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(),
          ),
        ),
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: null,
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format
          final inputRestrictions = RegExp(r'^[\w\W]*$');
          if (value == null || value.isEmpty || !inputRestrictions.hasMatch(value)) {
            return 'Please enter a valid book description using [a-z,A-Z,0-9,common special characters]';
          }
          return null;
        },
        onChanged: (value) => setState(() => _newBook.description = value),
        onSaved: (value) => setState(() => _newBook.description = value!),
      ),
    );
  }

  /// Publication Widget: Button to publish the newly created book
  Widget _publicationButton() {
    return Padding(
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
            Navigator.pop(context, _newBook);
          }
        },
        child: const Text('Publish'),
      ),
    );
  }

  /// Build Widget: Publish View Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Publish a new book',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          width: 190.0,
          height: 190.0,
          margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: _genres.contains(_newBook.genre)
                  ? Image.asset(
                          'images/${_newBook.genre.toLowerCase().replaceAll(' ', '')}.png')
                      .image
                  : Image.asset('images/other.png').image,
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _titleTile(),
              _authorTile(),
              _genreTile(),
              _publicationDateTile(),
              _descriptionTile(),
              _publicationButton(),
            ],
          ),
        ),
      ]),
    );
  }
}
