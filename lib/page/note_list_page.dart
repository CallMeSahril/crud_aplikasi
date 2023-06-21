import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/notecontroller/notecontroller.dart';
import '../model/notemodel/notemodel.dart';

class NoteListPage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: GetX<NoteController>(
        builder: (controller) {
          if (controller.notes.isEmpty) {
            return Center(
              child: Text('Data Kosong'),
            );
          }

          return ListView.builder(
            itemCount: controller.notes.length,
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.deleteNote(note.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddNoteDialog(context),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text == "") {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(
                        "Judul Tidak Boleh Kosong",
                      ),
                    ),
                  );
                } else {
                  final note = Note(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    content: contentController.text,
                  );
                  noteController.addNote(note).then((value) {
                    Navigator.pop(context);
                    titleController.clear();
                    contentController.clear();
                  });
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
