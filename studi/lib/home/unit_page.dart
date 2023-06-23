import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UnitPage extends StatefulWidget {
  final String className;
  final List<String> subject;

  const UnitPage({super.key, required this.className, required this.subject});

  @override
  _UnitPageState createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
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
    print("got data using offline mode");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('QuerySnapshotData');

    if (jsonData != null) {
      // Decode the JSON string to a list of maps
      List<Map<String, dynamic>> documentsData =
          List<Map<String, dynamic>>.from(jsonDecode(jsonData));

      // Extract the units from the documentsData
      List<String> units =
          documentsData.map((doc) => doc['Unit'].toString()).toSet().toList();
      if (this.mounted) {
        setState(() {
          notes = units;
        });
      }
    }
  }

  fetchNotes() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .where('Class', isEqualTo: widget.className)
        .where('Subject', whereIn: widget.subject)
        .get();
    List<String> distinctunit = querySnapshot.docs
        .map((doc) => doc['unit'].toString())
        .toSet()
        .toList();
    if (this.mounted) {
      setState(() {
        notes = distinctunit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.className} - ${widget.subject[0]}'),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesPage(
                            selected_class: widget.className,
                            subject: widget.subject[0],
                            unit: notes[index])),
                  );
                },
              ));
        },
      ),
    );
  }
}
