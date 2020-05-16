import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBottomSheetWidgets {
  static Widget selectCategory(Widget widget, Widget widget2) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[widget, widget2],
        ),
      );
  static Widget buildHakkindaItem(Widget widget) => Column(
        children: <Widget>[
          AppWidget.pullDown(AppConstant.colorPullDown2),
          widget,
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(child: SvgPicture.asset(AppConstant.svgLogoRed, height: 32)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppConstant.colorAppDescription),
                  children: <TextSpan>[
                    TextSpan(text: AppConstant.appLongRichDescription, style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: AppConstant.appLongDescription),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  static Widget buildAlteraItem(Widget widget,BuildContext context) {
    TextEditingController oldsenhaTx,nsenhaTx,confirmasenhaTx;
    oldsenhaTx= new TextEditingController();
    nsenhaTx= new TextEditingController();
    confirmasenhaTx= new TextEditingController();

    return
    Column(
      children: <Widget>[
        AppWidget.pullDown(AppConstant.colorPullDown2),
        widget,

        Padding(
          padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
          child: Center(
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(AppConstant.svgLogoRed, height: 32),
                  SizedBox(height: 16),
                  InputField("Senha Atual", FontAwesomeIcons.lock, oldsenhaTx,
                      TextInputType.text, passwordfiedl: true),
                  SizedBox(height: 16),
                  InputField("Nova Senha", FontAwesomeIcons.lock, nsenhaTx,
                      TextInputType.text, passwordfiedl: true),
                  SizedBox(height: 16),
                  InputField("Confirmar", FontAwesomeIcons.lock, confirmasenhaTx,
                      TextInputType.text, passwordfiedl: true),
                  SizedBox(height: 16),

                  InkWell(
                      onTap: () async {
                        if(nsenhaTx.text!=confirmasenhaTx.text)
                          {
                            httputils.errorBox("As senhas devem coincidir!", context);
                            return;
                          }
                        Map<String, String> params = {
                          "servID": "776",
                          "userID": AppConstant.userID.toString(),
                          "oldsenha":oldsenhaTx.text,
                          "nsenha":nsenhaTx.text
                        };

                        String response = await httputils.Post(params);
                        if(response=="OK")
                          {
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
                              "Senha alterada com sucesso!",
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
                            nsenhaTx.text="";
                            oldsenhaTx.text="";
                            confirmasenhaTx.text="";

                          }
                        else if(response=="W"){
                          httputils.errorBox("Senha incorreta!", context);

                        }
                        else {
                          httputils.errorBox("Erro desconhecido\n"+response, context);

                        }
                      },
                      child: Container(
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppConstant.colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text("Alterar Senha",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)))
                      )
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }

  static Widget buildKatkiItem(Widget widget) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppWidget.pullDown(AppConstant.colorPullDown2),

          widget,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(child: SvgPicture.asset(AppConstant.svgLogoRed, height: 32)),
                ),
                SvgPicture.asset(AppConstant.svgMessage, height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 30, 32, 24),
                  child: Center(child: Text(AppConstant.katkiOneriDetails, style: _bottomSheetTextStyleF14W500)),
                ),
                AppBottomSheetWidgets.btnEpostaYaz,
              ],
            ),
          )
        ],
      );

  static Widget buildcontatoPage(Widget widget) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppWidget.pullDown(AppConstant.colorPullDown2),
            widget,
            Padding(padding: const EdgeInsets.only(top: 32.0), child: AppBottomSheetWidgets.sectionItem(AppConstant.appDescription, AppConstant.address)),
            Padding(padding: const EdgeInsets.only(left: 32), child: AppBottomSheetWidgets.phoneRow(Icons.phone,"(51) 8939-4501")),
            Padding(padding: const EdgeInsets.only(left: 32), child: AppBottomSheetWidgets.btnEpostaYaz),
            Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 22), child: Divider(color: AppConstant.colorBottomSheetDivider, thickness: 1)),
            /*AppBottomSheetWidgets.sectionItem(AppConstant.magaza, AppConstant.magazaAddress),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 0, 0),
              child: MaterialButton(
                minWidth: 314,
                height: 48,
                elevation: 0,
                color: AppConstant.colorDrawerButton,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
                child: Text(AppConstant.eMagaza, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppConstant.colorHeading)),
                onPressed: _launchURL,
              ),
            ),*/
          ],
        ),
      );
  static Widget InputField(String hintText, IconData icon,
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
  static Widget sectionItem(String header, String address) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(header, style: TextStyle(color: AppConstant.colorBottomSheetItemHeader, fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(padding: const EdgeInsets.only(top: 20.0, bottom: 10), child: Text(address, style: _bottomSheetTextStyleF14W500)),
            phoneRow(Icons.phone," (51) 3508-1257"),
          ],
        ),
      );

  static Widget get btnEpostaYaz => MaterialButton(
        minWidth: 152,
        height: 48,
        elevation: 0,
        color: AppConstant.colorDrawerButton,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
        child: Text(AppConstant.epostayaz, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppConstant.colorHeading)),
        onPressed: _launchURL,
      );

  static Widget phoneRow(IconData icon,String phone) => Row(
        children: <Widget>[
          Icon(icon, size: 15, color: AppConstant.colorPrimary),
          FlatButton(onPressed: _callPhone, child: Text(phone)),
        ],
      );

  static _sendMail() async {
    final String mail = 'mailto:bilgi@tdk.gov.tr';
    if (await canLaunch(mail)) {
      await launch(mail);
    } else {
      throw 'Mail Gönderilmedi';
    }
  }

  static _callPhone() async {
    final String phone = 'tel:+903124575200';
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Arama Yapılamadı';
    }
  }

  static _launchURL() async {
    final String url = AppConstant.whatsppUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Erro ao abrir whatsapp';
    }
  }

  static BoxDecoration get bottomSheetBoxDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: const Radius.circular(15.0), topRight: const Radius.circular(15.0)),
      );

  static TextStyle get _bottomSheetTextStyleF14W500 => TextStyle(color: AppConstant.colorParagraph2, fontSize: 14, fontWeight: FontWeight.w500);
}
