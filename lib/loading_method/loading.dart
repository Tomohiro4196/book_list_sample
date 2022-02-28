import 'package:flutter/material.dart';

class LoadingMethod extends ChangeNotifier{

  bool isLoading = false;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }

}
