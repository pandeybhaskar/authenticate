import 'dart:async';
import 'dart:js';
import 'package:authenticate/homepage.dart';
import 'package:authenticate/perhomepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SignUp());
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: SignUpForm()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  static Future<String?> mailRegister(String mail, String pwd) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pwd);
      FirebaseAuth.instance.authStateChanges().listen((user) {
        print(user);
      });
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<String?> mailSignIn(String mail, String pwd) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd);
      FirebaseAuth.instance.authStateChanges().listen((user) {
        // debugPrint(user.toString());
      });
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<void> mailLogout(String mail) async {
    await FirebaseAuth.instance.signOut();
    print("Logged Out");
  }

  static Future<void> resetPassword(String mail) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
    print("Reset mail sent to $mail, do check spam");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
            child: Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.amber),
              child: const Center(
                child: Text(
                  'AUTHENTICATE',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Form(
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Form(
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  tooltip: 'Register',
                  onPressed: () => {
                    mailRegister(emailController.text, passwordController.text),
                    FirebaseAuth.instance
                    .authStateChanges()
                    .listen((User? user){
                      if (user == null) {
                        print('User is not registered!');
                      } else {
                        print('User is registered!${user.uid}');
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>  Homepage(homeuser : user))
                        );
                      }
                    })
                  },
                  child: const Icon(Icons.app_registration_rounded),
                ),
                FloatingActionButton(
                  tooltip: 'Sign In',
                  onPressed: () => {
                    // mailSignIn(emailController.text, passwordController.text),
                    mailSignIn('pandeybhaskar587@gmail.com', 'pandey123'),
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                              print('User is currently signed out!');
                              showDialog(context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            backgroundColor: const Color
                                                .fromRGBO(245, 221, 179, 100),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: const [
                                                Icon(
                                                  Icons.error_rounded,
                                                  color: Colors.amber,
                                                ),
                                                Text(
                                                  'Please Sign In',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight: FontWeight
                                                          .bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                  );
                            } else {
                              print('User is signed in!',);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>  Homepage(homeuser : user))
                              );
                            }
                          })
                  },


                  child: const Icon(Icons.login_rounded),
                ),
                FloatingActionButton(
                  tooltip: 'Logout',
                  onPressed: () => {mailLogout(emailController.text)},
                  child: const Icon(Icons.logout_rounded),
                ),
                FloatingActionButton(
                  tooltip: 'Forgot Password',
                  onPressed: () => {resetPassword(emailController.text)},
                  child: const Icon(Icons.lock_reset_rounded),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
