import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      setState(() {
        SubjectSelection = itemList;
      });
    }
  }

  void saveItemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('SubjectSelection', SubjectSelection);
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
    setState(() {
      Subject = distinctSubject;
    });
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
              child: CheckboxListTile(
            value: SubjectSelection.contains(Subject[index]),
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  SubjectSelection.add(Subject[index]);
                } else {
                  SubjectSelection.remove(Subject[index]);
                }
              });
            },
            title: Text(Subject[index]),
          ));
        },
      ),
    );
  }

  savePreferences(String className, String topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('class', className);
    await prefs.setString('topic', topic);
  }
}
