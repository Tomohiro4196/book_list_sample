import 'package:book_list_sample/domain/book.dart';
// domainディレクトリから、Bookクラスをインポートする
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BookListModel extends ChangeNotifier{
  final _userCollection = FirebaseFirestore.instance.collection('books');
  // _（アンダーバー）を先頭につけると変数がPrivateになる = そのファイル内でしか呼び出せなくなる
  // FirebaseFirestore = firestoreのデータベースを参照
  // .collection = 参照元を指定 → Firestore内のbooksを参照
  //.snapshots でデータを取得
  // 'get'と'snapshot'の違い → get：同期 / snapshot：非同期（=リアルタイム更新）

  List<Book>? books;
  //「?」をつけるとnull許容になる → Book型のデータ or null（=空っぽ）であればOK

  void fetchBookList() async {
    //▼変化をListenするコード

    final QuerySnapshot snapshot = await _userCollection.get();
    // QuerySnapshot snapshot = QuerySnapshotという種類のsnapshotを指定している
    // getでデータを取得 = getなので、リアルタイムで反映されない
    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      //List<Book> books = 「Book」型のレコードから成る「books」というリスト
      // TODO: Book型はbook.dartで作成している
      //mapでDocumentSnapshotをBookに変換する

      //Booksのリストを作成
      Map<String, dynamic>
      data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      //ユニークIDを指定 注意:ここだけdocument.になっている
      final String title = data['title'];
      final String author = data['author'];
      final String? imageURL = data['imageURL'];
      return Book(id, title, author, imageURL);
      //Bookという型に変換する -> Bookから成るbooksというリストになる
      // TODO: Book型はbook.dartで作成している
    }).toList();

    //toList -> リストに追加する
    this.books = books;
    //this = 現在のインスタンスを指す
    //this.books = 現在のインスタンスのbookデータを参照する
    notifyListeners();
    //通知を送るメソッド
    //book_list_pageで発火
    }

    Future delete(Book book){
      return FirebaseFirestore.instance.collection('books').doc(book.id).delete();
    }
  }
