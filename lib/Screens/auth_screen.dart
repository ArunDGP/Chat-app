import 'package:flutter/material.dart';
import 'package:flutter_chat/Widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final auth = FirebaseAuth.instance;

  void submitFn(String email, String username, String password, File? image, bool isLogin,
      BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child('user_image').child(authResult.user!.uid +'.jpg');
        await ref.putFile(image!);
        var url = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('Users')
            .doc(authResult.user!.uid)
            .set({'UserName': username, 'Email': email, 'ImageUrl' : url });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, Please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ChatScreen();
              } else {
                return AuthForm(submitFn, _isLoading);
              }
            }));
  }
}
