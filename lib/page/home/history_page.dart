import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sozluk/page/word_detail_page.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:sozluk/widget/homepage/tdk_cover.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  PageController _pageController = PageController(initialPage: 0);
  bool isEmpty = true;
  List<Widget> perguntasHistory;
  int _selectedCategory = 0;

  Future<void> getStory()
  async {
    perguntasHistory= List<Widget>();
    Map<String,String> params={
      "servID":"321",
      "userID":AppConstant.userID.toString() ,
    };

    String response= await httputils.Post(params);
    if(response=="W")
      {
        setState(() {
          isEmpty=true;
        });
        debugPrint("lista vazia");
      }
    else{
      try{
        var perguntasjson= jsonDecode(response);
        for(int i=0;i<perguntasjson.length;i++)
          {
            String title= perguntasjson[i]["resposta"].toString().isEmpty?"Pergunta":"Respondida";
            perguntasHistory.add(_historyItem(title:  title+ " - "+ perguntasjson[i]["pergunta"].toString().substring(0,18)+"...", infos:perguntasjson[i]));

          }
        setState(() {
          isEmpty=false;
        });

      }on Exception catch(e) {

        setState(() {
          isEmpty=true;

        });

        httputils.errorBox("Falha ao obter perguntas\n"+response, context);
      }


      }

  }
  @override void initState() {
    getStory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _isKeyboardVisible =false;
    return Scaffold(

      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              TdkCover(isKeyboardVisible: _isKeyboardVisible, context: context, scale: 0.20),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .14),
                  child: Column(
                    children: <Widget>[
                      Text("Minhas Perguntas", style: TextStyle(fontSize: 14, color: Colors.white)),

                    ],
                  ),
                ),
              ),
              AppWidget.pullDown(AppConstant.colorPullDown1),
            ],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: isEmpty ? httputils.renderEmptyState('Você ainda não perguntou nada') : _renderHistory(),
            ),
          ),
        ],
      ),
    );
  }



  Widget _renderHistory() {
    return Column(
      children: <Widget>[
        Expanded(
          child: _words()
          /*PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _selectedCategory = page;
              });
            },
            children: <Widget>[_words(), _idioms(), _lorem(), _ipsum(), _dolor()],
          ),*/
        ),
      ],
    );
  }

  Widget _words() {
    return SingleChildScrollView(
        child:Column(
            children: perguntasHistory,
    )
    );
  }

  Widget _idioms() {
    return Column(
      children: <Widget>[_historyItem(title: 'Kalemiyle yaşamak veya geçinmek'), _historyItem(title: 'Kalemine dolamak')],
    );
  }

  Widget _lorem() {
    return Column(
      children: <Widget>[
        _historyItem(title: 'Lorem ipsum dolor sit'),
      ],
    );
  }

  Widget _ipsum() {
    return Column(
      children: <Widget>[
        _historyItem(title: 'Lorem ipsum'),
      ],
    );
  }

  Widget _dolor() {
    return Column(
      children: <Widget>[
        _historyItem(title: 'Adispicing sit elit'),
      ],
    );
  }

  Widget _horizontalCategoryItem({@required int id, @required String title}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });

        _pageController.animateToPage(id, duration: Duration(milliseconds: 300), curve: Curves.ease);
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: _selectedCategory == id ? FontWeight.bold : FontWeight.normal,
                )),
            SizedBox(
              height: 4,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 2,
              width: _selectedCategory == id ? title.length * 4.5 : 0,
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyItem({@required String title,Map<String,dynamic> infos}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => WordDetailPage(infos)));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$title',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.colorPrimary,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
