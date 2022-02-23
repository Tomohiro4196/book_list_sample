
import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_book_model.dart';

class EditBookPage extends StatelessWidget {
  //引数を設定
  final Book book;
  //上記のままでは初期値がない
  //初期値を下記のコードで設定する = イニシャライズ（初期値を与える）という
  //bookというものをBook型（domain/book.dartで設定している）に指定
  EditBookPage(this.book);
  //▲この形で他のページからもらってきます。
  //"this"は現在のインスタンスを指す


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      //book_list_model内の「変更したよ」という通知を受け取る
      create: (_) => EditBookModel(book)..update(),
      //book_list_pageから持ってきたインスタンスをEditBookModelに代入
      //EditBookModelにはインスタンスを1つ与える必要がある（edit_book_model.dartのイニシャライズの際に設定）
      //モデルから関数を引っ張ってくる場合は「.」（ピリオドが2つ必要）
      child: Scaffold(
          appBar: AppBar(
            title: Text('本を編集する'),
          ),
          body: Center(
              child: Consumer<EditBookModel>(builder: (context,model,child){
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: [
                          TextField(
                            controller: model.titleController,
                            //"model."でimportしているモデル内を参照する
                            //"edit_book_model"からtitleControllerを持ってくる
                            decoration: InputDecoration(
                                hintText: 'タイトル',
                            ),
                            onChanged: (text) {
                              model.setTitle(text);
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: model.authorController,
                            decoration: InputDecoration(
                                hintText: '本の作者',
                            ),
                            onChanged: (text) {
                              model.setAuthor(text);
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ElevatedButton(
                              onPressed: model.isUpdated()
                                  //isUpdatedがtrueの場合は以下のメソッドを発火させる
                                  ? () async {
                                // ▼レコードを追加する処理
                                try {
                                  await model.update();
                                  //add_book_model内のAddBookを発火させる
                                  Navigator.of(context).pop(model.title);
                                  // trueの信号を送る
                                } catch(e){
                                  final snackBar = SnackBar(
                                      content: Text(e.toString()
                                      )
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              } : null,
                              //isUpdatedはfalseの場合はnull = ボタンが非活性状態 = 押せなくなる
                              child: Text('内容を編集する')
                          ),
                        ]
                    )
                );
              }
              )
          )
      ),
    );

  }
}