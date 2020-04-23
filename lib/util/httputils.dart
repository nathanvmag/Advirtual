import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sozluk/util/app_constant.dart';

class httputils {
  static Future<String> Post(Map<String,String> params) async {
    var url = AppConstant.serverAdress;

    var response = await http.post(
        url,
        headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: params,
        encoding: Encoding.getByName("utf-8")
    );

    return response.body;

  }
  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
  static void errorBox(String text,BuildContext context)
  {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );
    Alert(
      context:context,
      style: alertStyle,
      type: AlertType.error,
      title: "Erro",
      desc: text,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: AppConstant.colorPrimary,
          radius: BorderRadius.circular(10.0),
        ),
      ],
    ).show();
  }
  static String formatData(DateTime dt)
  {
    var meses = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"];

    return dt.day.toString()+" de "+meses[dt.month-1]+" de "+dt.year.toString();
  }
  static Widget renderEmptyState(String text ) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.history,
            size: 48,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: AppConstant.colorParagraph2),
          ),
        ],
      ),
    );
  }
}
