import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:sozluk/widget/homepage/tdk_cover.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var _isKeyboardVisible = false;
  var emailinputTx = TextEditingController();
  var senhainputTx = TextEditingController();
  var nomeinputTx = TextEditingController();
  var telefoneinputTx =  new MaskedTextController(mask: '(00) 00000-0000');


  TapGestureRecognizer cadastraReconizer;
  TapGestureRecognizer esqueceReconizer;
  TapGestureRecognizer voltarReconizer;
  List<Column> pages;
  List<String> titles;
  int pagecontroller=0;

  @override
  void initState()  {
    super.initState();
    get();

    pagecontroller=0;
    cadastraReconizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          debugPrint("Hello click");
          pagecontroller=2;

        });
      };
    esqueceReconizer = TapGestureRecognizer()
      ..onTap = () {
        debugPrint("Esqueceu");
        setState(() {
          pagecontroller=1;

        });
      };
    voltarReconizer= TapGestureRecognizer()..onTap=(){
      debugPrint("voltou");
      setState(() {
        pagecontroller=0;
      });
    };

  }
  void get()
  async {

  }

  @override
  Widget build(BuildContext context) {
    pages= [loginEntry(esqueceReconizer,cadastraReconizer),EsqueceuSenha(voltarReconizer),cadastroPage(voltarReconizer)];
    titles=["Entre já e tire suas dúvidas","Recupere seu acesso","Cadastre-se já"];
    // TODO: implement build
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            TdkCover(
                isKeyboardVisible: _isKeyboardVisible,
                context: context,
                scale: 0.3),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .22),
                child: Column(
                  children: <Widget>[
                    Text(titles[pagecontroller],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
            AppWidget.pullDown(AppConstant.colorPullDown1),
          ],
        ),
        Expanded(
            child: SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7 > (pagecontroller==2?500:400)
                        ? MediaQuery.of(context).size.height * 0.7
                        : (pagecontroller==2?500:400),
                    child: pages[pagecontroller])))
      ],
    ));
  }

    Widget EsqueceuSenha(TapGestureRecognizer voltarrec) {
    return Column(children: <Widget>[
      SizedBox(height: 48),
      InputField("Email", FontAwesomeIcons.solidUserCircle, emailinputTx,
          TextInputType.emailAddress),

          SizedBox(height: 32),
          Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppConstant.colorPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: InkWell(
                      onTap: () {
                        debugPrint("Logar");
                      },
                      child: Text("Enviar",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))
              )
          ),
          SizedBox(height: 20),
           RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
              style: TextStyle(fontSize: 17, color: AppConstant.colorBackButton),
          children: <TextSpan>[
            TextSpan(text: "", ),
            TextSpan(text: "Voltar",style: TextStyle(fontWeight: FontWeight.bold,color: AppConstant.colorPrimary),recognizer: voltarrec ),
          ],

    ))],
      )
;
  }
  Widget loginEntry(TapGestureRecognizer esquecegesture,TapGestureRecognizer cadastresegesture) {
    return Column(children: <Widget>[
      SizedBox(height: 48),
      InputField("Email", FontAwesomeIcons.solidUserCircle, emailinputTx,
          TextInputType.emailAddress),
      SizedBox(height: 16),
      InputField(
          "Senha", FontAwesomeIcons.lock, senhainputTx, TextInputType.text,
          passwordfiedl: true),
      SizedBox(height: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child:  RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle( color: AppConstant.colorBackButton),
                    children: <TextSpan>[
                      TextSpan(text: "Esqueceu sua senha ?" ,recognizer: esquecegesture),
                    ],
                  ))),

          SizedBox(height: 32),
          InkWell(
              onTap: () async {
                Map<String,String> params={
                  "servID":"542",
                  "email":emailinputTx.text,
                  "senha":senhainputTx.text
                };

                String response= await httputils.Post(params);
                if(response=="OK")
                  {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString("email",emailinputTx.text);
                    await prefs.setString("pass",senhainputTx.text);
                    Navigator.pushReplacementNamed(context, AppConstant.pageHome);

                  }
                else if(response=="W")
                  {
                    httputils.errorBox("Credenciais inválidas",context);
                    return;
                  }
                else {
                  httputils.errorBox("Erro desconhecido\n"+response,context);
                }

              },
              child:Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppConstant.colorPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child:  Text("Entrar",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))
              )
          ),
          SizedBox(height: 20),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 17, color: AppConstant.colorBackButton),
                children: <TextSpan>[
                  TextSpan(text: "Não possui conta? ", ),
                  TextSpan(text: "Cadastre-se",style: TextStyle(fontWeight: FontWeight.bold,color: AppConstant.colorPrimary),recognizer:cadastresegesture ),
                ],

              ))],
      )
    ]);
  }
  Widget cadastroPage(TapGestureRecognizer voltarrec) {
    return Column(children: <Widget>[
      SizedBox(height: 32),
      InputField("Nome e Sobrenome", FontAwesomeIcons.solidUserCircle,nomeinputTx,
          TextInputType.text),
      SizedBox(height: 16),
      InputField("Telefone", FontAwesomeIcons.phone, null,TextInputType.phone,mask:telefoneinputTx),
      SizedBox(height: 16),
      InputField("Email", FontAwesomeIcons.solidEnvelope,emailinputTx ,
          TextInputType.emailAddress),
      SizedBox(height: 16),
      InputField(
          "Senha", FontAwesomeIcons.lock, senhainputTx, TextInputType.text,
          passwordfiedl: true),
      SizedBox(height: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child:  RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle( color: AppConstant.colorBackButton),
                    children: <TextSpan>[
                      TextSpan(text: "Todos os campos são obrigatórios" ),
                    ],
                  ))),

          SizedBox(height: 16),
          InkWell(
              onTap: () async {
                debugPrint("Logar");
                if(emailinputTx.text.isEmpty||nomeinputTx.text.isEmpty|emailinputTx.text.isEmpty|senhainputTx.text.isEmpty)
                  {
                    httputils.errorBox("Você deve preencher todos os campos",context);
                    return;
                  }
                if(senhainputTx.text.length<6)
                  {
                    httputils.errorBox("Sua senha deve ter no mínimo 6 caracteres",context);
                    return;
                  }
                Map<String,String> params={
                  "servID":"30",
                  "nome":nomeinputTx.text,
                  "telefone":telefoneinputTx.text,
                  "email":emailinputTx.text,
                  "senha":senhainputTx.text
                };

                String response= await httputils.Post(params);
                if(response=="DE")
                  {
                    httputils.errorBox("Esse email já foi cadastrado",context);
                    return;
                  }
                if(response!="OK")
                  {
                    httputils.errorBox("Erro desconhecido\n"+response,context);
                    return;
                  }
                debugPrint("Cadastrado com sucesso");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString("email",emailinputTx.text);
                await prefs.setString("pass",senhainputTx.text);
                Navigator.pushReplacementNamed(context, AppConstant.pageHome);
              },
              child:Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppConstant.colorPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child:  Text("Cadastrar",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))
              )
          ),
          SizedBox(height: 20),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 17, color: AppConstant.colorBackButton),
                children: <TextSpan>[                  
                  TextSpan(text: "Voltar",style: TextStyle(fontWeight: FontWeight.bold,color: AppConstant.colorPrimary),recognizer:voltarrec ),
                ],

              ))],
      )
    ]);
  }


  Widget InputField(String hintText, IconData icon,
      TextEditingController controller, TextInputType inputType,{MaskedTextController mask=null,
      bool passwordfiedl: false}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppConstant.colorBackButton),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5.0,
                offset: Offset(0, 10))
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Theme(
        data: AppWidget.getThemeData().copyWith(primaryColor: Colors.grey),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                keyboardType: inputType,
                obscureText: passwordfiedl,
                controller: controller==null?mask:controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontSize: 14, color: AppConstant.colorBackButton),
                  //
                  filled: true,

                  fillColor: Colors.white,
                  prefixIcon: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: Icon(
                      icon,
                      color: AppConstant.colorBackButton,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
