import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

/// View that presents a form to publish and edit books to the library.
class PublishView extends StatefulWidget {
  /// Book that is being edited or published.
  late Book _newBook;

  /// Indicates whether the form must be pre-filled.
  bool _prefillForm = true;

  /// Standard constructor to edit an already existing book.
  PublishView(this._newBook);

  /// Empty constructor to publish a new book.
  PublishView.empty() {
    this._newBook = Book(
        id: '',
        createdAt: Timestamp.now(),
        title: '',
        author: '',
        date: DateTime.parse('2000-01-01'),
        genre: 'Other',
        description: '');
    this._prefillForm = false;
  }

  @override
  State<StatefulWidget> createState() => _PublishViewState();
}

class _PublishViewState extends State<PublishView> {
  /// Global key to validate all fields of the form are filled out validly.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Controller to enable the picking of the date via [showDatePicker].
  TextEditingController _dateController = TextEditingController();

  /// Controller to enable the genre selection via overlay list.
  TextEditingController _typeAheadController = TextEditingController();

  /// Database controller to enable all Firestore-related operations.
  FirestoreController _firestoreController = FirestoreController();

  /// Boolean to assure that a genre was selected from the suggestions.
  bool _genreSelected = false;

  /// Notify form field controller if editing of a book is required.
  @override
  void initState() {
    super.initState();
    if (widget._prefillForm) {
      this._typeAheadController.text = widget._newBook.genre;
      _genreSelected = true;
      this._dateController.text =
          DateFormat('dd.MM.y').format(widget._newBook.date);
    }
  }

  /// Publishing Form Tile: Generic ListTile for entering title, author
  /// and description indicated by the [objective] string.
  Widget _publishingFormTile(Icon icon, String objective) {
    return ListTile(
      leading: icon,
      title: TextFormField(
        initialValue: (() {
          if (widget._prefillForm) {
            switch (objective) {
              case 'author':
                {
                  return widget._newBook.author;
                }
              case 'title':
                {
                  return widget._newBook.title;
                }
              case 'description':
                {
                  return widget._newBook.description;
                }
            }
          }
          return null;
        }()),
        decoration: InputDecoration(
          hintText: 'Enter book $objective',
          border: objective == 'description'
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(),
                )
              : null,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format.
          final inputRestrictions = RegExp(r'^[\w\W]*$');
          if (value == null ||
              value.isEmpty ||
              !inputRestrictions.hasMatch(value)) {
            return 'Please enter a valid book $objective';
          }
          return null;
        },
        minLines: objective == 'description' ? 5 : 1,
        maxLines: objective == 'description' ? null : 1,
        onChanged: (value) => setState(() {
          switch (objective) {
            case 'author':
              {
                widget._newBook.author = value;
              }
              break;
            case 'title':
              {
                widget._newBook.title = value;
              }
              break;
            case 'description':
              {
                widget._newBook.description = value;
              }
              break;
          }
        }),
      ),
    );
  }

  /// Genre FormTile: ListTile for genre selection from a list of suggestions.
  Widget _genreTile() {
    return ListTile(
      leading: Icon(Icons.my_library_books_outlined),
      title: TypeAheadFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            decoration:
                InputDecoration(labelText: 'Select genre from suggestions')),
        suggestionsCallback: (pattern) {
          return genres
              .where((String element) =>
                  element.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
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
            widget._newBook.genre = suggestion;
            _genreSelected = true;
          });
        },
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format.
          if (value == null ||
              value.isEmpty ||
              !genres.contains(value) ||
              !_genreSelected) {
            return 'Please select a book genre from the suggestion list';
          }
          return null;
        },
        onSaved: (value) => setState(() => widget._newBook.genre = value!),
      ),
    );
  }

  /// Date FormTile: ListTile for publication date selection via [showDatePicker].
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
          if (picked != widget._newBook.date)
            setState(() {
              widget._newBook.date = picked;
              _dateController.text =
                  DateFormat('dd.MM.y').format(widget._newBook.date);
            });
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: _dateController,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              hintText: 'Select publication date',
            ),
            validator: (String? value) {
              // Assuring only valid dates in format DD.MM.YYYY are allowed.
              final inputRestrictions =
                  RegExp(r'^[0-9]{2}\.[0-9]{2}\.[0-9]{4}$');
              if (value == null ||
                  value.isEmpty ||
                  !inputRestrictions.hasMatch(value)) {
                return 'Please select a valid publication date [DD.MM.YYYY]';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  /// Button to publish the created/edited book to the Firestore database.
  Widget _publicationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          textStyle: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          // Only process the data if the form is filled out validly.
          if (_formKey.currentState!.validate()) {
            // Differentiate whether to publish or edit an existing book.
            if (widget._prefillForm) {
              // Try to update the book in the database, in case it got deleted add it as new.
              try {
                await _firestoreController.updateBook(widget._newBook);
              } catch (error) {
                await _firestoreController.addBook(widget._newBook);
              }
            } else {
              await _firestoreController.addBook(widget._newBook);
            }
            Navigator.pop(context);
          }
        },
        child: Text('Publish'),
      ),
    );
  }

  /// Builds the publish view form consisting of the separate FormTiles.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        title: Text(
          'Publish Books',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ListView(children: <Widget>[
        Center(
            child: Container(
          width: 190.0,
          height: 190.0,
          margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: genres.contains(widget._newBook.genre)
                  ? Image.asset(
                          'assets/images/${widget._newBook.genre.toLowerCase().replaceAll(' ', '')}.png')
                      .image
                  : Image.asset('assets/images/other.png').image,
            ),
          ),
        )),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _publishingFormTile(Icon(Icons.menu_book), 'title'),
              _publishingFormTile(Icon(Icons.person), 'author'),
              _genreTile(),
              _publicationDateTile(),
              _publishingFormTile(
                  Icon(Icons.text_snippet_outlined), 'description'),
              _publicationButton(),
            ],
          ),
        ),
      ]),
    );
  }
}
