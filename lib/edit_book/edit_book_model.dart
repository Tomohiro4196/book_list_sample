import 'package:book_list_sample/domain/book.dart';
// domainディレクトリから、Bookクラスをインポートする
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EditBookModel extends ChangeNotifier{
  final Book book;
  EditBookModel(this.book) {
    //イニシャライズする時に、初期値としてタイトルと著者を設定する
    titleController.text = book.title;
    authorController.text = book.author;
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();



  String? title;
  String? author;


  //▼notifyListenersをモデルで試行する
  void setTitle(String title){
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author){
    this.author = author;
    notifyListeners();
  }

  bool isUpdated(){
    //編集がちゃんとなされているかを示す関数
   return title != null || author != null;
  }

  Future update() async {

    this.title = titleController.text;
    this.author = authorController.text;
    //Firestoreに追加するメソッド
    await FirebaseFirestore.instance.collection('books').doc(book.id).update(
        {
          'title': title,
          'author': author,
        }
    );
  }
}
