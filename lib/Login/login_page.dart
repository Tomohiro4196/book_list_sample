import 'package:book_list_sample/Login/login_model.dart';
import 'package:book_list_sample/Register/Register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      //book_list_model内の「変更したよ」という通知を受け取る
      create: (_) => LoginModel(),
      //book_list_pageから持ってきたインスタンスをEditBookModelに代入
      //EditBookModelにはインスタンスを1つ与える必要がある（edit_book_model.dartのイニシャライズの際に設定）
      //モデルから関数を引っ張ってくる場合は「.」（ピリオドが2つ必要）
      child: Scaffold(
          appBar: AppBar(
            title: Text('本を編集する'),
          ),
          body: Center(
              child: Consumer<LoginModel>(builder: (context,model,child){
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: [
                          TextField(
                            controller: model.emailController,
                            //"model."でimportしているモデル内を参照する
                            //"edit_book_model"からtitleControllerを持ってくる
                            decoration: InputDecoration(
                              hintText: 'メールアドレス',
                            ),
                            onChanged: (text) {
                              model.setEmail(text);
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: model.passwordController,
                            decoration: InputDecoration(
                              hintText: 'パスワード',
                            ),
                            onChanged: (text) {
                              model.setPassWord(text);
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ElevatedButton(
                              onPressed: (){
                                try{
                                  model.SignUp();
                                  Navigator.of(context).pop();
                                } catch(e){
                                  final snackBar = SnackBar(
                                      backgroundColor: Colors.black26,
                                      content: Text('アカウントの登録に失敗しました')
                                  );
                                }
                              },
                              child: Text('アカウントを作成する')
                          ),

                          TextButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder:
                                      (context) => Registerpage()
                                  )
                                );
                              },
                              child: Text('新規のアカウントを作成する')
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