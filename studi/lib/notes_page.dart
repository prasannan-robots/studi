import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  final String className;
  final String topic;

  const NotesPage({super.key, required this.className, required this.topic});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  fetchNotes() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .where('class', isEqualTo: widget.className)
        .where('topic', isEqualTo: widget.topic)
        .get();
    setState(() {
      notes = querySnapshot.docs
          .map((doc) => doc.data())
          .toList()
          .cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.className} - ${widget.topic}'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]['title']),
            subtitle: Text(notes[index]['content']),
          );
        },
      ),
    );
  }
}
