import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'subject_selection_page.dart';

class ClassSelectionPage extends StatefulWidget {
  const ClassSelectionPage({super.key});

  @override
  _ClassSelectionPageState createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelectionPage> {
  List<String> classes = [];

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  void fetchClasses() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('notes').get();
    List<String> distinctClasses = querySnapshot.docs
        .map((doc) => doc['Class'].toString())
        .toSet()
        .toList();

    setState(() {
      classes = distinctClasses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Class'),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(classes[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SubjectSelectionPage(className: classes[index])),
              );
            },
          ));
        },
      ),
    );
  }
}
