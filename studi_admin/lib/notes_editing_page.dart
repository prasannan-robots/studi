import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditingPage extends StatefulWidget {
  const NoteEditingPage({
    Key? key,
    required this.notetitle,
    required this.notecontent,
    required this.noteSubject,
    required this.noteClass,
    required this.noteunit,
    required this.documentId,
    required this.author,
  }) : super(key: key);

  final String notetitle;
  final String notecontent;
  final String noteSubject;
  final String noteClass;
  final String noteunit;
  final String author;
  final String? documentId;

  @override
  _NoteEditingPageState createState() => _NoteEditingPageState();
}

class _NoteEditingPageState extends State<NoteEditingPage> {
  final _firebaseService = FirebaseService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _subjectController;
  late TextEditingController _classController;
  late TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notetitle);
    _contentController = TextEditingController(text: widget.notecontent);
    _subjectController = TextEditingController(text: widget.noteSubject);
    _classController = TextEditingController(text: widget.noteClass);
    _unitController = TextEditingController(text: widget.noteunit);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _subjectController.dispose();
    _classController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void saveNoteEntry() async {
    final noteTitle = _titleController.text;
    final noteContent = _contentController.text;
    final noteSubject = _subjectController.text;
    final noteClass = _classController.text;
    final noteUnit = _unitController.text;

    if (noteContent.isNotEmpty) {
      if (widget.documentId != null) {
        // Existing note, update it
        await _firebaseService.updateNote(
          widget.documentId!,
          noteContent,
        );
      } else {
        // New note, create it
        await _firebaseService.createNote(
          noteTitle,
          noteContent,
          noteSubject,
          noteClass,
          noteUnit,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved!'),
          backgroundColor: Colors.deepPurple,
        ),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void deleteNote() async {
    if (widget.documentId != null) {
      await _firebaseService.deleteNote(widget.documentId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note deleted!'),
          backgroundColor: Colors.deepPurple,
        ),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Studi_admin',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white, // Added white cursor color
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple,
                        border: InputBorder.none,
                        hintText: 'Note Title',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: deleteNote,
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white, // Added white cursor color
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple,
                  border: InputBorder.none,
                  hintText: 'Note Content',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _subjectController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white, // Added white cursor color
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple,
                  border: InputBorder.none,
                  hintText: 'Note Subject',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _classController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white, // Added white cursor color
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple,
                  border: InputBorder.none,
                  hintText: 'Note Class',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _unitController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white, // Added white cursor color
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple,
                  border: InputBorder.none,
                  hintText: 'Note Unit',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: saveNoteEntry,
                child: const Text('Save Note'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNote(
    String title,
    String content,
    String subject,
    String noteClass,
    String unit,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await _firestore.collection('notes').add({
      'author': userId,
      'title': title,
      'content': content,
      'Subject': subject,
      'Class': noteClass,
      'unit': unit,
    });
  }

  Future<void> deleteNote(String documentId) async {
    await _firestore.collection('notes').doc(documentId).delete();
  }

  Future<void> updateNote(String documentId, String content) async {
    await _firestore.collection('notes').doc(documentId).update({
      'content': content,
    });
  }
}
