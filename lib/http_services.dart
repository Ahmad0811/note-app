import 'dart:convert';
import './model/notes.dart';
import 'package:http/http.dart';

class HttpServices {
  final String url = 'https://note-hw123.herokuapp.com/api/';

  Future<void> deleteNote(String id) async {
    Response res = await delete(url + id);
    if (res.statusCode == 200) {
      print('Note has been deleted');
    } else {
      print(res.body);
    }
  }

  Future<void> updateNote(String id, String note) async {
    Response res = await put(
      url + id,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
        <String, String>{
          'note': note,
        },
      ),
    );
    if (res.statusCode == 200) {
      print('Note has been Updated');
    } else {
      print(res.body);
    }
  }

  Future<void> addNote(String note) async {
    Response res = await post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
        <String, String>{
          'note': note,
        },
      ),
    );
    if (res.statusCode == 200) {
      print('Note has been added');
    } else {
      print(res.body);
    }
  }

  Future<List<Note>> getAllNotes() async {
    Response res = await get(url);
    print('request sent');
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['data'];
      List<Note> notes = [];
      body.forEach((element) {
        notes.add(Note.fromJson(element));
      });
      return notes;
    } else {
      print(res.body);
    }
  }
}
