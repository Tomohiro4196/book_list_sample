import 'package:book_list_sample/book_list/book_list_model.dart';
import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      //book_list_model内の「変更したよ」という通知を受け取る
        create: (_) => BookListModel()..fetchBookList(),
      //モデルから関数を引っ張ってくる場合は「.」（ピリオドが2つ必要）
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context,model,child){
            //notifierを参照してConsumerが発火する
            final List<Book>? books = model.books;
            // book_list_modelからモデルを参照して、リストに持ってくる

            if (books == null){
              //nullの場合はこちらの挙動をする
              //最初は何も入っていないはずなので、nullが働く
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books.map(
              // 2回目以降はレコードが入っているので、if文ではなくこちらが発火する
              // booksからWidget型に修正する
              //「!」でnullではないことを明らかにする
                    (book) => ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
                  )
              .toList();
            return ListView(children: widgets,
            );
          })
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}