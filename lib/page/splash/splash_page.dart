import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sozluk/util/app_constant.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTimeout() {
    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint(prefs.containsKey("email").toString() +"  "+prefs.containsKey("pass").toString());
      if(prefs.containsKey("email")&&prefs.containsKey("pass")){
        Navigator.pushReplacementNamed(context, AppConstant.pageHome);
        debugPrint("Entrou aqui login fast");
      }else  Navigator.pushReplacementNamed(context, AppConstant.pageLogin);

    }
    );
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
            ),
           )
    );
  }
}
