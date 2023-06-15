import 'package:authenticate/perhomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'community.dart';

class Homepage extends StatefulWidget{
  User homeuser;
  Homepage({required this.homeuser});

  @override
  State<Homepage> createState() => _HomepageState(homeuser: homeuser);
}
class _HomepageState extends State<Homepage> {
  User homeuser;
  bool _peersPressed = false;
  bool _myprofilePressed = true;


  _HomepageState({required this.homeuser});
  var db = FirebaseFirestore.instance;
  var firestoreSnapshot;
  final CollectionReference _collectionReference= FirebaseFirestore.instance.collection('players');
  late final int runs;
  late final int wickets;
  late final int matches;

  void fetchData(){
    db.collection('players')
        .get()
        .then((querySnapshot) {
      firestoreSnapshot = querySnapshot;
      setState(() {
        _myprofilePressed = false;
        _peersPressed = true;
      });
      // for (var docSnapshot in querySnapshot.docs) {
      //   print('${docSnapshot.id} => ${docSnapshot.data()}');
      // }
    }
    )
        .catchError((onError)=>print(onError));
  }
  @override

  void initState() {
    super.initState();
    final docRef = _collectionReference.doc(homeuser.uid);

    docRef.get().then((value) {
      setState(() {
     runs = int.parse(value.get('runs')) ;
     wickets = int.parse(value.get('wickets')) ;
     matches = int.parse(value.get('matches')) ;

      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLAYGROUND'),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                  'Peers',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              onTap: (){
                fetchData();
                print(_myprofilePressed.toString()+_peersPressed.toString());
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text(
                  'My Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: (){
                setState(() {
                  _myprofilePressed = true;
                  _peersPressed = false;
                });

                print(_myprofilePressed.toString()+_peersPressed.toString());
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //         width: MediaQuery.of(context).size.width,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Container(            width: MediaQuery.of(context).size.width/7,
          //                 child: Text('IMAGE', style: TextStyle(fontWeight: FontWeight.bold))),
          //             Container(            width: MediaQuery.of(context).size.width/7,
          //                 child: Text('NAME', style: TextStyle(fontWeight: FontWeight.bold))),
          //             Container(            width: MediaQuery.of(context).size.width/7,
          //                 child: Text('RUNS', style: TextStyle(fontWeight: FontWeight.bold))),
          //             Container(            width: MediaQuery.of(context).size.width/7,
          //                 child: Text('WICKETS', style: TextStyle(fontWeight: FontWeight.bold))),
          //             Container(            width: MediaQuery.of(context).size.width/7,
          //                 child: Text('MATCHES', style: TextStyle(fontWeight: FontWeight.bold))),
          //             Container(            width: MediaQuery.of(context).size.width/7,
          //                 child: Text('EDIT', style: TextStyle(fontWeight: FontWeight.bold))),
          //             Container(
          //                 child: Text('TEAM', style: TextStyle(fontWeight: FontWeight.bold))),
          //           ],
          //         ),
          //       ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: _myprofilePressed ?
                    PerHomepage(
                      perhomeuser: homeuser,
                      runs: runs,
                      wickets: wickets,
                      matches: matches,
                    )
                  :
                    Community(firestoreSnapshot : firestoreSnapshot)
                ),
            //   ],
            // ),
          )
        ],
      ),
    );
  }
}
