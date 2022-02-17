import 'package:book_list_sample/domain/book.dart';
// domainディレクトリから、Bookクラスをインポートする
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BookListModel extends ChangeNotifier{
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('books').snapshots();
  // FirebaseFirestore = firestoreのデータベースを参照
  // .collection = 参照元を指定 → Firestore内のbooksを参照
  //.snapshots でデータを取得
  // 'get'と'snapshot'の違い → get：同期 / snapshot：非同期（=リアルタイム更新）

  List<Book>? books;
  //「?」をつけるとnull許容になる → Book型のデータ or null（=空っぽ）であればOK

  void fetchBookList(){
    //▼変化をListenするコード
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
        //List<Book> books = 「Book」型のレコードから成る「books」というリスト
        //mapでDocumentSnapshotをBookに変換する
        Map<String, dynamic>
        data = document.data()! as Map<String, dynamic>;
        final String title = data['title'];
        final String author = data['author'];
        return Book(title, author);
        //Bookという型にしてMapの中で変換する -> Bookから成るbooksというリストになる
      }).toList();
      //toList -> リストに追加する
      this.books = books;
      //this = 現在のインスタンスを指す
      //this.books = 現在のインスタンスのbookデータを参照する
      notifyListeners();
      //通知を送るメソッド
      //book_list_pageで発火
    });



  }
}