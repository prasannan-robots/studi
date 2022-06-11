//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'models.dart';
// import 'addpost.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final googleSignIn = GoogleSignIn();

class UploadBuilder extends StatefulWidget {
  const UploadBuilder({Key? key}) : super(key: key);

  @override
  _UploadBuilderState createState() => _UploadBuilderState();
}

class _UploadBuilderState extends State<UploadBuilder> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('post')
      //.orderBy("score", descending: true)
      //.limit(7)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
                color: Palette.kToDark,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      "Posted by ${getValue(data['User'])}",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: "monospace"),
                    ),
                    Divider(),
                    Image.network(
                      data['link'],
                      fit: BoxFit.contain,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data['description'],
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: "monospace"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ));
          }).toList(),
        );
      },
    );
  }
}

String getValue(DocumentReference docref) {
  String val;
  final docRef = FirebaseFirestore.instance.collection('user').doc(docref.path);
  docRef.get().then(
    (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      val = data['name'];
      print(val);
      return val;
    },
    onError: (e) => print("Error getting document: $e"),
  );
  return "";
}


// class PostPage extends StatefulWidget {
//   const PostPage({Key? key}) : super(key: key);

//   @override
//   State<PostPage> createState() => _PostPageState();
// }

// class _PostPageState extends State<PostPage> {
//   //Future refresh() async {
//   //  setState(() {});
//   //}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text("V_NEX"), actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddPost()),
//                   );
//                 },
//                 child: Icon(
//                   Icons.add,
//                   size: 26.0,
//                 ),
//               )),
//         ]),
//         body: Column(
//           children: [Welcomer(), UploadBuilder(), Logout_Dealer()],
//         ));
//   }
// }

// class Welcomer extends StatelessWidget {
//   Welcomer({Key? key}) : super(key: key);
//   final user = FirebaseAuth.instance.currentUser;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(32),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Signed In As ", style: TextStyle(fontSize: 16)),
//           SizedBox(
//             height: 8,
//           ),
//           Text(
//             myMethod(user?.email),
//             style: TextStyle(fontSize: 20),
//           )
//         ],
//       ),
//     );
//   }
// }
//   String myMethod(String? myString) {
//     if (myString == null) {
//       return '';
//     }
    
//     return myString;
//   }

// class Logout_Dealer extends StatefulWidget {
//   const Logout_Dealer({Key? key}) : super(key: key);

//   @override
//   State<Logout_Dealer> createState() => _Logout_DealerState();
// }

// class _Logout_DealerState extends State<Logout_Dealer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       width: 250,
//       decoration: BoxDecoration(
//           color: Colors.blue, borderRadius: BorderRadius.circular(20)),
//       child: TextButton(
//         onPressed: () {
//           FirebaseAuth.instance.signOut();
//           googleSignIn.signOut();
//         },
//         child: Text(
//           "Logout",
//           style: TextStyle(color: Colors.white, fontSize: 25),
//         ),
//       ),
//     );
//   }
// }






/*
class BuildListViewer extends StatefulWidget {
  const BuildListViewer({Key? key}) : super(key: key);

  @override
  State<BuildListViewer> createState() => _BuildListViewerState();
}

class _BuildListViewerState extends State<BuildListViewer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int Index) {
            return new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(1),
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                        radius: 6.0,
                        backgroundColor: Colors.black,
                      ),
                      title: Text(
                        posts[Index].name,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                        ),
                      )),
                ]);
          },
        ),
        Expanded(
            child: Image(
          image: NetworkImage(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          height: 15,
          width: 15,
          fit: BoxFit.cover,
        )),
      ],
    );
  }
}

class PostListViewer extends StatefulWidget {
  const PostListViewer({Key? key}) : super(key: key);

  @override
  State<PostListViewer> createState() => _PostListViewerState();
}

class _PostListViewerState extends State<PostListViewer> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int Index) {
        return new ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(1),
            children: <Widget>[
              ListTile(
                  leading: CircleAvatar(
                    radius: 6.0,
                    backgroundColor: Colors.black,
                  ),
                  title: Text(
                    posts[Index].name,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                    ),
                  )),
            ]);
      },
    );
  }
} 
class NoteList extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('post').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data.docs.map((doc) {
                return Card(
                  child: ListTile(
                    title: Text(doc.data()['title']),
                  ),
                );
              }).toList(),
            );
        },
      ),
    );
  }
}
*/
