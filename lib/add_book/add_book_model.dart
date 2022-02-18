import 'package:book_list_sample/domain/book.dart';
// domainディレクトリから、Bookクラスをインポートする
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddBookModel extends ChangeNotifier{
  String? title;
  String? author;

  Future addBook() async {
    // Futureクラス = 時間のかかる非同期通信を行う際に利用する
    // Futureを使う際は'async' 'await' を使うことが推奨されている
    if (title == null || title!.isEmpty){
      //タイトルに入力がない もしくは空白だけで入力された場合
      throw '本のタイトルが空欄です';
    }

    if(author == null || author!.isEmpty){
      //著者に入力がない もしくは空白だけで入力された場合
      throw '本の作者が空欄です';
    }
    //上記二つのif文を突破したら下の.addメソッドが発火
    //Firestoreに追加するメソッド
    await FirebaseFirestore.instance.collection('books').add(
      {
        'title': title,
        'author': author,
      }
    );
  }
}
