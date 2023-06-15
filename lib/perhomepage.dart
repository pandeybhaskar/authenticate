
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PerHomepage extends StatefulWidget{
  final User perhomeuser;

  late final int runs;
  late final int wickets;
  late final int matches;


   PerHomepage({
    super.key,
    required this.perhomeuser,
    required this.runs,
    required this.wickets,
    required this.matches
  });

  @override
  State<PerHomepage> createState() => _PerHomepageState(perhomeuser, runs, wickets, matches);
}

class _PerHomepageState extends State<PerHomepage> {
  final User perhomeuser;

  // late final int runs;
  // late final int wickets;
  // late final int matches;

  final CollectionReference _collectionReference= FirebaseFirestore.instance.collection('players');

  final nameController = TextEditingController();

  final runsController = TextEditingController();

  final wicketsController = TextEditingController();

  final matchesController = TextEditingController();


  _PerHomepageState( this.perhomeuser, int runs,int wickets,int matches,
   // this.runs,
   // this.wickets,
   // this.matches
      );

  @override


  Widget build(BuildContext context){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // width: MediaQuery.of(context).size.width/7,
            child: const CircleAvatar(
              backgroundColor: Colors.lime,
            ),
          ),
          Container(
            // width: MediaQuery.of(context).size.width/5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.perhomeuser.uid),
                Text(widget.perhomeuser.email.toString()),
              ],
            ),
          ),
          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
                Container(
                    // width: MediaQuery.of(context).size.width/7,
                    child: Text('R : ${widget.runs}', style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                    // width: MediaQuery.of(context).size.width/7,
                    child: Text('W : ${widget.wickets}', style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                    // width: MediaQuery.of(context).size.width/7,
                    child: Text('M : ${widget.matches}',  style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                  // width: MediaQuery.of(context).size.width/7,
                  child: ElevatedButton(
                      onPressed: ()=> {
                        showDialog(context: context,
                            builder: (context) => EditProfile(perhomeedit: widget.perhomeuser))
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('Edit'),
                          Icon(Icons.edit)
                        ],
                      )
                  ),
                ),
                Container(
                  // width: MediaQuery.of(context).size.width/7,
                  child: ElevatedButton(
                      onPressed: () => print(widget.perhomeuser.uid),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('Join a Team'),
                          Icon(Icons.group_add_rounded)
                        ],
                      )
                  ),
                )
          //     ],
          //   ),
          // ),
        ],
      );
    // );
  }
}

class EditProfile extends StatefulWidget{
  final User perhomeedit;
  const EditProfile({super.key, required this.perhomeedit});
  @override
  State<EditProfile> createState() => EditProfileState(perhomeeditState: perhomeedit);
}

class EditProfileState extends State<EditProfile>{
  final nameController = TextEditingController();
  final runsController = TextEditingController();
  final wicketsController = TextEditingController();
  final matchesController = TextEditingController();
  final perhomeeditState;

  EditProfileState({required this.perhomeeditState});

  void addUserDatabase(Map<String,String> userData){
    final String userId = perhomeeditState.uid;
    print(userId);

    FirebaseFirestore.instance
    .collection('players')
    .doc(userId)
    .set(userData)
    .onError((e, _) => print("Error writing document: $e"));

  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text('Edit Profile'),
      content : SizedBox(
        height: 300,
        width: 100,
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Form(
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text('Full Name'),
                  hintText: 'Full Name'
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
          child: Form(
            child: TextFormField(
              controller: runsController,
              decoration: const InputDecoration(
                  label: Text('Runs'),
                  hintText: 'Runs'
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
          child: Form(
            child: TextFormField(
              controller: wicketsController,
              decoration: const InputDecoration(
                  label: Text('Wickets'),
                  hintText: 'Wickets',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
          child: Form(
            child: TextFormField(
              controller: matchesController,
              decoration: const InputDecoration(
                  label: Text('Matches'),
                  hintText: 'Matches'
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),

      ],
    ),
    ),
      actions: [
        ElevatedButton(
            onPressed: () {
              final data = <String, String>{
                "name": nameController.text,
                "runs": runsController.text,
                "wickets": wicketsController.text,
                "matches": matchesController.text,
              };
              addUserDatabase(data);
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green)
            ),
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold),)
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)
            ),
            child: const Text('Discard Changes', style: TextStyle(fontWeight: FontWeight.bold))
        ),
      ],
    );
  }
}