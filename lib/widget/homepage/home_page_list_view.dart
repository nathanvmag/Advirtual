import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:sozluk/widget/idiom_card.dart';

class HomePageListView extends StatelessWidget {
  List<dynamic> respostas;
  bool isEmpty=false;
  BuildContext context;
  HomePageListView(List<dynamic> rc ,BuildContext ctx)
  {
    respostas=rc;
    context=ctx;
  }

    List<Widget>  getRespostas()  {
    List <Widget> respostasArray =new List<Widget>();

    for(var i =0;i<respostas.length;i++)
    {
      respostasArray.add(respostaObject(respostas[i]["nome"],httputils.formatData(DateTime.parse(respostas[i]["dataResposta"])),respostas[i]["pergunta"], respostas[i]["resposta"]));
     // respostasArray.add(respostaObject());
    }
    return respostasArray;
  }


  Widget respostaObject(String nome, String data, String pergunta, String resposta)
  {
    return Container(
      child:
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    nome,
                    style: TextStyle(color: AppConstant.colorProverbsIdiomsText,fontSize: 15),
                  )]),
                Row(
                  children:[

                  Text(
                     data,
                    style: TextStyle(color: AppConstant.colorProverbsIdiomsText,fontSize: 11),
                  ),
                ],
              ),
              SizedBox(height: 8),
              IdiomCard(title: pergunta, content: resposta),
              SizedBox(height: 24),
            ],
          )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: respostas==null? [ httputils.renderEmptyState('Nenhuma pergunta foi respodida até o momento')]: getRespostas(),
      ),
    );
  }
}
