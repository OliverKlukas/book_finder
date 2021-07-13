import 'package:book_finder/controller/firestore_controller.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PublishView extends StatefulWidget {
  // hand-over book to publish/edit
  late Book _newBook;
  bool _prefillForm = true;

  // Constructor to edit
  PublishView(this._newBook);

  // Empty constructor to publish only
  PublishView.empty(){
    this._newBook = new Book(id: '', title: '', author: '', date: DateTime.parse('2000-01-01'), genre: 'Other', description: ''); // TODO: nicht mehr richtig für die id
    this._prefillForm = false;
  }

  @override
  State<StatefulWidget> createState() => new _PublishViewState();
}

class _PublishViewState extends State<PublishView> {

  // key to validate form is filled out properly
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller to change date
  TextEditingController _dateController = new TextEditingController();

  // controller to allow genre selection overlay
  TextEditingController _typeAheadController = TextEditingController();

  // instance of firestore database controller
  FirestoreController _firestoreController = FirestoreController();

  // assure genre selection bool
  bool _genreSelected = false;

  /// Override init state to allow pre-fill
  @override
  void initState(){
    super.initState();
    if(widget._prefillForm){
      this._typeAheadController.text = widget._newBook.genre;
      _genreSelected = true;
      this._dateController.text = DateFormat('dd.MM.y').format(widget._newBook.date);
    }
  }

  /// Publishing Form Tile: ListTile for entering title, author and description
  Widget _publishingFormTile(Icon icon, String objective){
    return ListTile(
      leading: icon,
      title: TextFormField(
        initialValue: ((){
          if(widget._prefillForm){
            switch(objective){
              case 'author': {return widget._newBook.author;}
              case 'title': {return widget._newBook.title;}
              case 'description': {return widget._newBook.description;}
            }
          }
          return null;
        }()),
        decoration: InputDecoration(
          hintText: 'Enter book $objective',
          border: objective == 'description' ? OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(),) : null,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          // Prevent security breaches/invalid inputs by restricting input format
          final inputRestrictions = RegExp(r'^[\w\W]*$');
          if (value == null || value.isEmpty || !inputRestrictions.hasMatch(value)) {
            return 'Please enter a valid book $objective';
          }
          return null;
        },
        minLines: objective == 'description' ? 5 : 1,
        maxLines: objective == 'description' ? null : 1,
        onChanged: (value) => setState((){
          switch(objective){
            case 'author': {widget._newBook.author = value;}
            break;
            case 'title': {widget._newBook.title = value;}
            break;
            case 'description': {widget._newBook.description = value;}
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
            widget._newBook.genre = suggestion;
            _genreSelected = true;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty || !genres.contains(value) || !_genreSelected) {
            return 'Please select a book genre from the suggestion list';
          }
          return null;
        },
        onSaved: (value) => setState(() => widget._newBook.genre = value!),
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
          if (picked != widget._newBook.date)
            setState(() {
              widget._newBook.date = picked;
              _dateController.text = DateFormat('dd.MM.y').format(widget._newBook.date);
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
        onPressed: () async {
          // Only process the data if the form is filled out validly
          if (_formKey.currentState!.validate()) {
            // add or edit book to database
            if(widget._prefillForm){
              // update of already published book
              try {
                await _firestoreController.updateBook(widget._newBook);
              } catch (error) { // atomcy handling, if book was deleted in meantime TODO: unsauberer coding stil?
                await _firestoreController.addBook(widget._newBook);
              }
            }
            else{
              // publication of new book
              await _firestoreController.addBook(widget._newBook);
            }
            // back to library view
            Navigator.pop(context);
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
          'Publish Books',
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
                image: genres.contains(widget._newBook.genre)
                    ? Image.asset(
                            'images/${widget._newBook.genre.toLowerCase().replaceAll(' ', '')}.png')
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
