import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sozluk/page/search_page.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:sozluk/util/system_overlay.dart';
import 'package:sozluk/widget/homepage/bottom_sheet.dart';
import 'package:sozluk/widget/homepage/home_page_list_view.dart';
import 'package:sozluk/widget/homepage/search_box.dart';
import 'package:sozluk/widget/homepage/tdk_cover.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode _searchFn = FocusNode();
  ScrollController _scrollController;
  double _searchBoxScrollPosition = 40;
  bool _isKeyboardVisible = false;
  bool _isScrollSearchBody = true;
  int questionQuant = 5;
  TextEditingController searchController;
  List<dynamic> perguntasjson;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(() {
          _searchBoxScrollPosition = 50 - _scrollController.offset;
          _isScrollSearchBody = _scrollController.offset <= 30;
          if (_scrollController.position.atEdge) {
            if (_scrollController.position.pixels != 0) {
              questionQuant += 5;
              getperguntasInDB();

            }
          }

      });

    _searchFn.addListener(() {
      setState(() {
        _isKeyboardVisible = _searchFn.hasFocus;
      });
    });
    getperguntasInDB();


  }

  void getperguntasInDB() async {
    Map<String, String> params = {
      "servID": "322",
      "limit": questionQuant.toString(),
    };

    String response = await httputils.Post(params);
    if (response == "W") {
      debugPrint("lista vazia");
      perguntasjson=null;
    } else {
      try {
        setState(() {
          perguntasjson = jsonDecode(response);

        });
        debugPrint("Carregada com sucesso");
      } on Exception catch (e) {
        perguntasjson=null;
        httputils.errorBox("Falha ao obter perguntas\n" + response, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //getperguntasInDB();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayHelper.statusBarBrightness(_isKeyboardVisible),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              TdkCover(
                  isKeyboardVisible: _isKeyboardVisible,
                  context: context,
                  scale: 0.2),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: _isKeyboardVisible ? 4 * 54.0 : 52, bottom: 32),
                    child: _isKeyboardVisible
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 64,
                            child: Column(children: [
                              InkWell(
                                  onTap: () async {
                                    debugPrint("Logar");
                                    if (searchController.text.length <
                                        30) {
                                      httputils.errorBox(
                                          "A pergunta deve conter no mínimo 30 caracteres",
                                          context);
                                      return;
                                    }
                                    if (AppConstant.userID == 0) {
                                      httputils.errorBox(
                                          "Login não efetuada corretamente",
                                          context);
                                      return;
                                    }
                                    Map<String, String> params = {
                                      "servID": "442",
                                      "pergunta": searchController.text,
                                      "userID":
                                      AppConstant.userID.toString(),
                                    };

                                    String response =
                                    await httputils.Post(params);
                                    if (response == "OK") {
                                      searchController.text = "";
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());

                                      var alertStyle = AlertStyle(
                                        animationType:
                                        AnimationType.fromTop,
                                        isCloseButton: false,
                                        isOverlayTapDismiss: false,
                                        descStyle: TextStyle(
                                            fontWeight:
                                            FontWeight.bold),
                                        animationDuration:
                                        Duration(milliseconds: 400),
                                        alertBorder:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        titleStyle: TextStyle(
                                          color: Colors.green,
                                        ),
                                      );
                                      Alert(
                                        context: context,
                                        style: alertStyle,
                                        type: AlertType.success,
                                        title: "Sucesso",
                                        desc:
                                        "Pergunta efetuada com sucesso, aguarde a resposta.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: AppConstant
                                                .colorPrimary,
                                            radius:
                                            BorderRadius.circular(
                                                10.0),
                                          ),
                                        ],
                                      ).show();
                                    } else {
                                      httputils.errorBox(
                                          "Erro ao efetuar pergunta\n" +
                                              response,
                                          context);
                                    }
                                  },
                                  child: Container(
                                      height: 60,
                                      margin:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: AppConstant.colorPrimary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child:Text("Enviar pergunta",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                      )),
                              )
                              ,
                              SizedBox(height: 20),
                              Text(
                                  "As respostas das perguntas aqui formuladas serão respondidas a medida em que os profissionais jurídicos tiverem acesso a esta e seus pareceres estiverem protos. Estas ingressaram em uma fila por ordem de chegada ao aplicativo e serão todas atendidas dentro da capacitação técnica e pertinência da dúvida. As perguntas elaboradas não possuem custos ou encargos. O Aplicativo não tem a pretensão de elaborar teses ou tratados, expressando apenas a opinião e o entendimento a cerca das diversas linhas de pensamentos do mundo jurídico. Ciente que não teremos todas as respostas, mas certos que compartilharemos todo o nosso conhecimento para formar cidadãos melhores informados e uma sociedade melhor para todos nós.\n*O momento em que o usuário realizar a pergunta, permitirá que esta seja exposta no quadro de notícias do aplicativo.",
                                  textAlign: TextAlign.justify)
                            ]))
                        : HomePageListView(perguntasjson, context),
                  ),
                ),
              ),
            ],
          ),
          SearchBox(
            isKeyboardVisible: _isKeyboardVisible,
            focusNode: _searchFn,
            isScrollSearchBody: _isScrollSearchBody,
            searchBoxScrollPosition: _searchBoxScrollPosition,
            searchController: searchController,
          ),
          buildMoreButton()
        ],
      ),
    );
  }

  buildMoreButton() {
    return _isKeyboardVisible
        ? Container()
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[],
            ),
          );
  }
}
