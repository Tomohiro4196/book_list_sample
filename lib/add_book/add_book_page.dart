
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_book_model.dart';

class AddBookPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      //book_list_model内の「変更したよ」という通知を受け取る
      create: (_) => AddBookModel()..addBook(),
      //モデルから関数を引っ張ってくる場合は「.」（ピリオドが2つ必要）
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Center(
            child: Consumer<AddBookModel>(builder: (context,model,child){
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: SizedBox(
                            height: 140,
                            width: 100,
                            child: model.imageFile != null
                                ? Image.file(model.imageFile!)
                                : Container(color: Colors.grey),
                          ),
                          onTap: () async {
                            await model.pickImage();
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'タイトル'
                          ),
                          onChanged: (text){
                            // TODO: ここで取得したTEXTを利用する
                            model.title = text;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: '本の作者'
                          ),
                          onChanged: (text){
                            // TODO: ここで取得したTEXTを利用する
                            model.author = text;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // ▼レコードを追加する処理
                              try {
                                model.startLoading();
                              await model.addBook();
                              //add_book_model内のAddBookを発火させる
                              Navigator.of(context).pop(true);
                              // trueの信号を送る
                              } catch(e){
                                final snackBar = SnackBar(
                                content: Text(e.toString()
                              )
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } finally {
                                //catchしてもしなくても発生する処理
                                model.endLoading();
                                }
                              },
                            child: Text('追加する')
                                      ),
                                  ]
                                )
                               ),
                            if(model.isLoading)
                              //ロード中のみ回ってる感じのやつをだす
                                Container(
                                    color: Colors.white54,
                                    child: Center(
                                    child: CircularProgressIndicator(),
                                    ),
                                    ),
                              ],
                            );
                          }
                        )
                      )
                    ),
                  );

                }
              }