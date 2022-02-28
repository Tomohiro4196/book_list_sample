import 'package:book_list_sample/Login/login_page.dart';
import 'package:book_list_sample/add_book/add_book_page.dart';
import 'package:book_list_sample/book_list/book_list_model.dart';
import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_book/edit_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        )
                    );
                    //
                  },
                  icon: Icon(Icons.person))
            ],
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
                    (book) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: ListTile(
                          leading: book.imageURL != null
                              ? SizedBox(
                              width: 45,
                              child: Image.network(book.imageURL!)
                          )
                            : SizedBox(
                            height: 70,
                            width:  45,
                            child: Container(color: Colors.grey,)
                          ),
                          title: Text(book.title),
                          subtitle: Text(book.author),
                        ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'edit',
                          color: Colors.black45,
                          icon: Icons.edit,
                          onTap: () async {
                            final String? title = await Navigator.push(
                              //画面遷移させる
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(book),
                                //遷移先を指定
                                //()内の"book"はリスト何のレコード1つ1つを参照している
                              ),
                            );
                            //▲ここで一旦処理が止まる

                            //▼Navigator.popで帰ってきた時に残りのコードが呼び出される
                            if(title != null){
                              final snackBar = SnackBar(
                                content: Text('『${title}』の編集を完了しました'),
                                backgroundColor: Colors.blue,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            model.fetchBookList();
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            await showConfirmDialog(context, book, model);
                          },
                        ),
                      ],
                    ),
                  ).toList();
            return ListView(children: widgets,
              // widgetに変換したbooksリストを参照してListViewを構築する
            );
          })
        ),
        floatingActionButton:
          Consumer<BookListModel>(builder: (context,model,child) {
            return FloatingActionButton(
              onPressed: () async {
                final bool? added = await Navigator.push(
                  //画面遷移させる
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(),
                    //遷移先を指定
                  ),
                );
                //▲ここで一旦処理が止まる

                //▼Navigator.popで帰ってきた時に残りのコードが呼び出される
                if(added != null && added){
                  final snackBar = SnackBar(
                    content: Text('本の入力を完了しました'),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchBookList();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
              );
            }),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }

  //確認のダイアログを表示するメソッド
  Future showConfirmDialog(BuildContext context, Book book, BookListModel model) {
    //上記の引数 => BuildContext型のcontext / Book型のbook / BookListModel型のmodel
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("『${book.title}』を削除しますか？"),
            actions: [
              FlatButton(
                child: Text("キャンセル"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("はい"),
                onPressed: () async {
                  await model.delete(book);
                  //model内のdeleteをbookを引数に実行 => 削除
                  Navigator.pop(context);

                  final snackBar = SnackBar(
                    backgroundColor: Colors.redAccent,
                      content: Text('${book.title}を削除しました'),
                  );
                  model.fetchBookList();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          );
        },
    );

  }
}