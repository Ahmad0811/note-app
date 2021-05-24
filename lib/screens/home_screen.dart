import 'package:flutter/material.dart';

import '../http_services.dart';
import '../model/notes.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final HttpServices httpServices = HttpServices();

  final TextEditingController Controller = TextEditingController();

  void showNoteDialog(BuildContext ctx, String type, String id, String note) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: type == 'add' ? Text('Add Note') : Text('Edit Note'),
          content: TextField(
            controller: Controller,
            decoration:
                InputDecoration(hintText: type == 'add' ? "Enter Note" : note),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  type == 'add'
                      ? httpServices.addNote(Controller.text)
                      : httpServices.updateNote(id, Controller.text);
                  Controller.text = '';
                  Navigator.of(context).pop();
                });
              },
              child: type == 'add' ? Text('Add') : Text('Edit'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
      ),
      body: FutureBuilder(
        future: httpServices.getAllNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            List<Note> notes = snapshot.data;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    title: Text('${notes[index].note}'),
                    onTap: () => {
                      showNoteDialog(
                          context, 'update', notes[index].id, notes[index].note)
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () {
                        setState(() {
                          httpServices.deleteNote(notes[index].id);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => {showNoteDialog(context, 'add', '', '')},
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
