class Note {
  final String id;
  final String note;

  Note({this.note, this.id});
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(id: json['_id'], note: json['note']);
  }
}
