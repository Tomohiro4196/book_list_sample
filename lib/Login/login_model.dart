import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LoginModel extends ChangeNotifier {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  void setEmail(String email){
    this.email = email;
    notifyListeners();
  }

  void setPassWord(String password){
    this.password = password;
    notifyListeners();
  }

  Future SignUp() async {
    this.email = emailController.text;
    this.password = passwordController.text;
  }

}