import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notes_editing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notesCollection.where('author', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error retrieving notes'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final notes = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final noteId = note.id;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.deepPurple,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteEditingPage(
                              notetitle: note['title'],
                              noteClass: note['Class'],
                              noteSubject: note['Subject'],
                              notecontent: note['content'],
                              noteunit: note['unit'],
                              documentId: noteId,
                              author: userId.toString(),
                            ),
                          ),
                        );
                      },
                      title: Text(
                        note['title'],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            note['content'],
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${note['Subject']} - ${note['unit']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('No notes available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          // Navigate to the create note page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditingPage(
                notetitle: '',
                noteClass: '',
                noteSubject: '',
                notecontent: '',
                noteunit: '',
                documentId: null,
                author: userId.toString(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
