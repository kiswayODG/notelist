import 'package:flutter/material.dart';
import 'package:notelist/services/auth/auth_service.dart';
import 'package:notelist/services/crud/notes_service.dart';
import 'package:sqflite/sqflite.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {

  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    // TODO: implement initState
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if(note ==null){
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);

  }

  void _setupTextControlleristener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;

    if(existingNote !=null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async{
    final note = _note;
    final text = _textController.text;
    if ( note != null && text.isNotEmpty) {
      _notesService.updateNote(
        note: note, text: text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle note'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(future: createNewNote(),
          builder: (context,snapshot){
        switch(snapshot.connectionState) {

          case ConnectionState.done:
            _setupTextControlleristener();
            // TODO: Handle this case.
          _note = snapshot.data as DatabaseNote;
            return TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
              hintText: "Commencez à taper votre note..."
        ),
            );
          default:
            return const CircularProgressIndicator();
        }
          }),
    );
  }
}
