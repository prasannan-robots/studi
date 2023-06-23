import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studi/setup/class_selection_page.dart';
import 'package:studi/home/unit_page.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<String> Subject = [];
  String selected_class = '';

  @override
  void initState() {
    super.initState();
    loadItemList();
  }

  void loadItemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemList = prefs.getStringList('SubjectSelection');
    String? Class = prefs.getString('Class');

    if (itemList != null && Class != null) {
      if (this.mounted) {
        setState(() {
          Subject = itemList;
          selected_class = Class;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Studi'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassSelectionPage()),
                  );
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: ListView.builder(
            itemCount: Subject.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.deepPurple,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UnitPage(
                              className: selected_class, subject: Subject)),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.deepPurple,
                  title: Text(
                    Subject[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }));
  }
}
