import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:text_to_speech/text_to_speech.dart';

class Community extends StatefulWidget {
  late final firestoreSnapshot;

  Community({super.key, required this.firestoreSnapshot});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  List allData = [];

  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('players');

  final firestore_snapshot = FirebaseFirestore.instance.collection('players').snapshots();


  List<String> name_value = [];
  List<String> runs_value = [];
  List<String> matches_value = [];
  List<String> wickets_value = [];

  // Future<void> fetchData() async {
  Future<void> fetchData() async {
    await _collectionRef.get().then((value) => print(value.docs.map((e) {
      setState(() {
        // name_value = e.get('name');
        name_value.add(e.get('name'));
        runs_value.add(e.get('runs'));
        matches_value.add(e.get('matches'));
        wickets_value.add(e.get('wickets'));
      });
          print(e.get('name'));
          print(e.get('runs'));
          print(e.get('matches'));
          print(e.get('wickets'));
        })));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FloatingActionButton(onPressed: fetchData),
      Text(name_value.isNotEmpty ? (name_value.length.toString()) : 'click to load'),
      SizedBox(
        height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width,
        child:
        ListView.builder(
          itemCount: name_value.length,
            itemBuilder: (context, index){
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(name_value[index]),
                  Text(runs_value[index]),
                  Text(matches_value[index]),
                  Text(wickets_value[index]),
                ],
              )
            );
        }),
      ),
        ],
        // StreamBuilder<QuerySnapshot>(
        //   stream: firestore_snapshot,
        //   builder: (BuildContext context,
        //       AsyncSnapshot<QuerySnapshot> firestoreSnapshot) {
        //     return Expanded(
        //         child: ListView.builder(
        //             itemCount: firestoreSnapshot.data?.docs.length,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                 title:
        //                     Text(firestoreSnapshot.data!.docs[index]['name']),
        //               );
        //             }));
        //   },
        // ),
      // MyApp(),
    );
  }
}