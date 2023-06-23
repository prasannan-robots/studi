import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class NotesPage extends StatefulWidget {
  final String unit;
  final String selected_class;
  final String subject;

  const NotesPage(
      {Key? key,
      required this.unit,
      required this.selected_class,
      required this.subject})
      : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    try {
      fetchNotes();
    } catch (e) {
      fetchNotesOffline();
    }
  }

  fetchNotesOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('QuerySnapshotData');

    if (jsonData != null) {
      // Decode the JSON string to a list of maps
      List<Map<String, dynamic>> documentsData =
          List<Map<String, dynamic>>.from(jsonDecode(jsonData));

      // Filter the documentsData based on the desired unit
      List<String> note = documentsData
          .where((doc) => doc['unit'] == widget.unit)
          .map((doc) => doc['content'].toString())
          .toSet()
          .toList();
      if (this.mounted) {
        setState(() {
          notes = note;
        });
      }
    }
  }

  fetchNotes() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .where('Class', isEqualTo: widget.selected_class)
        .where('Subject', isEqualTo: widget.subject)
        .where('unit', isEqualTo: widget.unit)
        .get();

    List<String> note =
        querySnapshot.docs.map((doc) => doc['content'].toString()).toList();
    if (this.mounted) {
      setState(() {
        notes = note;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.selected_class}-${widget.subject}-${widget.unit}'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
              color: Colors.deepPurple,
              child: ListTile(
                title: Text(
                  notes[index],
                  style: TextStyle(color: Colors.white),
                ),
              ));
        },
      ),
    );
  }
}
