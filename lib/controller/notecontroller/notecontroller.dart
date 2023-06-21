import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/notemodel/notemodel.dart';

class NoteController extends GetxController {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  final RxList<Note> notes = <Note>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final QuerySnapshot snapshot = await _notesCollection.get();
    notes.value = snapshot.docs
        .map((doc) => Note(
              id: doc.id,
              title: doc['title'],
              content: doc['content'],
            ))
        .toList();
  }

  Future<void> addNote(Note note) async {
    await _notesCollection.add({
      'title': note.title,
      'content': note.content,
    });
    fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update({
      'title': note.title,
      'content': note.content,
    });
    fetchNotes();
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
    fetchNotes();
  }
}
