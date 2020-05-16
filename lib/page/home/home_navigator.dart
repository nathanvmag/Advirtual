import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sozluk/page/home/history_page.dart';
import 'package:sozluk/page/home/home_page.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/httputils.dart';
import 'package:sozluk/widget/homepage/bottom_sheet.dart';
import 'package:sozluk/widget/homepage/tdk_cover.dart';

import 'config_page.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  static int userID;

  var _currentPage =1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
  }
  Future<void> getID()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String,String> params={
      "servID":"543",
      "email":prefs.getString("email"),
      "senha":prefs.getString("pass"),
    };

    String response= await httputils.Post(params);
    if(response=="W")
    {
      httputils.errorBox("Falha ao se autenticar, tente novamente", context);
      prefs.clear();
      debugPrint("Erro senha");
      Navigator.pushReplacementNamed(context, AppConstant.pageLogin);
    }
    else if(httputils.isNumeric(response))
    {
      userID=  int.parse(response);
      debugPrint("Meu id: "+userID.toString());
      AppConstant.userID=userID;
    }
    else {
      httputils.errorBox("Ocorreu um erro, por favor entre novamente", context);
      Navigator.pushReplacementNamed(context, AppConstant.pageLogin);

    }
  }


  @override
  Widget build(BuildContext context)  {

    List<Widget> _pages = [HistoryPage(), HomePage(),ConfigPage()];//, Center(child: Text('Todo'))];

    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        color: AppConstant.colorParagraph2,
        backgroundColor: Colors.white,
        activeColor: AppConstant.colorPrimary,
        elevation: 0.5,
        //height causes layout overflow on some devies
        //height: 56,
        onTap: (int val) {
          if (val == _currentPage) return;
          setState(() {
            _currentPage = val;
          });
        },
        initialActiveIndex: _currentPage,
        style: TabStyle.fixedCircle,
        items: <TabItem>[
          TabItem(icon: Icons.list, title: 'Perguntas'),
          TabItem(icon: FontAwesomeIcons.question,title:""),
          TabItem(icon:Icons.settings ,title: 'Configurações'),

        ],
      ),
      body: _pages[_currentPage],
    );
  }
}