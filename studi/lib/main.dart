import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studi/home/subject_page.dart';
import 'setup/class_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? subjectSelection = prefs.getStringList('SubjectSelection');
  String? className = prefs.getString('class');
  bool isLoggedIn = (subjectSelection != null && className != null);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studi',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: isLoggedIn ? SubjectPage() : ClassSelectionPage(),
      routes: {
        '/subject': (context) => const SubjectPage(),
      },
    );
  }
}
