import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:url_launcher/url_launcher.dart';
class WordDetailPage extends StatefulWidget {
  var infs;
  WordDetailPage(Map<String, dynamic> infos) {
    infs = infos;
  }

  @override
  _WordDetailPageState createState() => _WordDetailPageState(infs);
}

class _WordDetailPageState extends State<WordDetailPage> {
  bool isKeyboardVisible;
  int _selectedCategory = 0;
  String pergunta, resposta;
  DateTime respostaTime;
  DateFormat Formatter;
  _WordDetailPageState(Map<String, dynamic> infos)  {
    pergunta = infos["pergunta"];
    resposta = infos["resposta"];
    respostaTime = DateTime.parse(infos["dataResposta"]);
    debugPrint(pergunta);
    debugPrint(resposta);

  }
  TapGestureRecognizer gestureRecognizer;
  @override
  void initState() {
    // TODO: implement initState
    gestureRecognizer= new TapGestureRecognizer();
    gestureRecognizer..onTap=(){

      launch(AppConstant.whatsppUrl);

    };

    super.initState();


  }




  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppConstant.colorHeading,
          ),
        ),
        elevation: 0,
        backgroundColor: AppConstant.colorPageBg,
        title: Text(
          'Detalhes da Pergunta',
          style: TextStyle(color: AppConstant.colorHeading),
        ),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          resposta.isEmpty
                              ? "Aguardando Resposta"
                              : "Respondida",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          resposta.isEmpty
                              ? ""
                              : 'Respondida em '+httputils.formatData(respostaTime),
                          style: TextStyle(color: AppConstant.colorParagraph),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Material(
                          color: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.black38,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                RespostaRow(),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget RespostaRow() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            '',
            style: TextStyle(color: AppConstant.colorParagraph2),
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              pergunta,
              style: TextStyle(
                color: AppConstant.colorPrimary,
              ),
            ),
          )
        ]),
             Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      resposta.isEmpty?"Você será respondido em breve, por favor aguarde.":resposta,textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                            resposta.isEmpty? 'Caso sua dúvida seja urgente, entre em contato conosco no whatsapp clicando ': 'Essa é uma resposta prévia, para mais informações entre em contato no whatsapp clicando ',
                          style: TextStyle(color: AppConstant.colorParagraph),
                        ),
                        TextSpan(

                          text: 'aqui.',
                          style: TextStyle(color: AppConstant.colorPullDown1),
                          recognizer:gestureRecognizer
                        ),
                      ]),
                    )
                  ],
                ),
              ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _horizontalCategoryItem({@required int id, @required String title}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });

        _pageController.animateToPage(id,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
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
                  fontWeight: _selectedCategory == id
                      ? FontWeight.bold
                      : FontWeight.normal,
                )),
            SizedBox(
              height: 4,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 2,
              width: _selectedCategory == id ? title.length * 4.5 : 0,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}
