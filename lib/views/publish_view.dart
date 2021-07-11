import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PublishView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PublishViewState();
}

class _PublishViewState extends State<PublishView> {
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

  /// Publishing Form Tile: ListTile for entering title, author and description
  Widget _publishingFormTile(Icon icon, String objective){
    return ListTile(
      leading: icon,
      title: TextFormField(
        decoration: InputDecoration(
          hintText: 'Enter book $objective',
          border: objective == 'description' ? OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(),) : null,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format
          final inputRestrictions = RegExp(r'^[\w\W]*$');
          if (value == null || value.isEmpty || !inputRestrictions.hasMatch(value)) {
            return 'Please enter a valid book $objective using [a-z,A-Z,0-9,common special characters]';
          }
          return null;
        },
        minLines: objective == 'description' ? 5 : 1,
        maxLines: objective == 'description' ? null : 1,
        onChanged: (value) => setState((){
          switch(objective){
            case 'author': {_newBook.author = value;}
            break;
            case 'title': {_newBook.title = value;}
            break;
            case 'description': {_newBook.description = value;}
            break;
          }
        }),
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
          return genres.where((String element) => element.toLowerCase().contains(pattern.toLowerCase())).toList();
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
          if (value == null || value.isEmpty || !genres.contains(value) || !_genreSelected) {
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

  /// Publication Widget: Button to publish the newly created book
  Widget _publicationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
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
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        title: Text(
          'Publish a new book',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ListView(children: <Widget>[
        Center(
          child:Container(
            width: 190.0,
            height: 190.0,
            margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: genres.contains(_newBook.genre)
                    ? Image.asset(
                            'images/${_newBook.genre.toLowerCase().replaceAll(' ', '')}.png')
                        .image
                    : Image.asset('images/other.png').image,
              ),
            ),
          )
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _publishingFormTile(Icon(Icons.menu_book), 'title'),
              _publishingFormTile(Icon(Icons.person), 'author'),
              _genreTile(),
              _publicationDateTile(),
              _publishingFormTile(Icon(Icons.text_snippet_outlined), 'description'),
              _publicationButton(),
            ],
          ),
        ),
      ]),
    );
  }
}
