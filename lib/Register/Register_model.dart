import 'package:book_list_sample/book_list/book_list_page.dart';
import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterModel extends ChangeNotifier {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final favbookController = TextEditingController();

 String? email;
 String? password;
 String? favbook;


 void setEmail(String email){
   this.email = email;
   notifyListeners();
 }

 void setPassWord(String password){
   this.password = password;
   notifyListeners();
 }

 void setFavBook(String favbook){
   this.favbook = favbook;
 }

 Future SignUp() async {
  this.email = emailController.text;
  this.password = passwordController.text;


  if(email != null && password != null){
    //authenticationにユーザーを作成
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!);

    final user = userCredential.user;
    final userID = user!.uid;

    //firestoreに追加

    this.favbook = favbookController.text;
    final userDB = FirebaseFirestore.instance.collection('user');
    final doc = userDB.doc(userID);

    await doc.set({
      'userID': userID,
      'email': email,
      'favoriteBook': favbook,
    });

  }




 }

}