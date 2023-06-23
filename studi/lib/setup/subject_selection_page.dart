import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi/home/subject_page.dart';
import 'dart:convert';

class SubjectSelectionPage extends StatefulWidget {
  final String className;

  const SubjectSelectionPage({super.key, required this.className});

  @override
  _SubjectSelectionPageState createState() => _SubjectSelectionPageState();
}

class _SubjectSelectionPageState extends State<SubjectSelectionPage> {
  List<String> Subject = [];
  List<String> SubjectSelection = [];

  @override
  void initState() {
    super.initState();
    fetchSubject();
    loadItemList();
  }

  void loadItemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemList = prefs.getStringList('SubjectSelection');

    if (itemList != null) {
      if (this.mounted) {
        setState(() {
          SubjectSelection = itemList;
        });
      }
    }
  }

  saveItemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('SubjectSelection', SubjectSelection);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .where('Class', isEqualTo: widget.className)
        .where('Subject', whereIn: SubjectSelection)
        .get();

    List<Map<String, dynamic>> documentsData = querySnapshot.docs
        .map((doc) => doc.data())
        .toList()
        .cast<Map<String, dynamic>>();

    // Convert the documentsData to JSON format
    String jsonData = jsonEncode(documentsData);

    // Save the JSON string in shared preferences
    await prefs.setString('QuerySnapshotData', jsonData);
  }

  void navigateToUnitPage() async {
    await saveItemList();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SubjectPage(),
      ),
      (route) => false,
    );
  }

  fetchSubject() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .where('Class', isEqualTo: widget.className)
        .get();
    List<String> distinctSubject = querySnapshot.docs
        .map((doc) => doc['Subject'].toString())
        .toSet()
        .toList();
    if (this.mounted) {
      setState(() {
        Subject = distinctSubject;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Subjects'),
        ),
        body: ListView.builder(
          itemCount: Subject.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.deepPurple,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: CheckboxListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  activeColor: Colors.white,
                  checkColor: Colors.deepPurple,
                  tileColor: Colors.deepPurple,
                  value: SubjectSelection.contains(Subject[index]),
                  onChanged: (bool? value) {
                    if (this.mounted) {
                      setState(() {
                        if (value != null && value) {
                          SubjectSelection.add(Subject[index]);
                        } else {
                          SubjectSelection.remove(Subject[index]);
                        }
                      });
                    }
                  },
                  title: Text(
                    Subject[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check),
            onPressed: () async {
              navigateToUnitPage();
            }));
  }
}
