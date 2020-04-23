
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/widget/homepage/bottom_sheet.dart';
import 'package:sozluk/widget/homepage/tdk_cover.dart';

class ConfigPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>  ConfigPageState();

}
class ConfigPageState extends State<ConfigPage>{


  int _selectedCategory = 0;
  PageController _pageController = PageController(initialPage: 0);
  var _isKeyboardVisible = false;


  Widget get _buildDrawerItem => Column(
    children: <Widget>[
      Stack(
        children: <Widget>[
          TdkCover(isKeyboardVisible: _isKeyboardVisible, context: context, scale: 0.20),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .14),
              child: Column(
                children: <Widget>[
                  Text("App Sobre", style: TextStyle(fontSize: 14, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(AppConstant.appVersion, style: TextStyle(fontSize: 12, color: AppConstant.colorVersionText)),
                  ),
                ],
              ),
            ),
          ),
          AppWidget.pullDown(AppConstant.colorPullDown1),
        ],
      ),
      SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: MaterialButton(
              minWidth: 328,
              height: 48,
              elevation: 0,
              color: AppConstant.colorDrawerButton,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
              child: Text("Sobre", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppConstant.colorHeading)),
              onPressed: () {
                __onSobrePressed();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: MaterialButton(
              minWidth: 328,
              height: 48,
              elevation: 0,
              color: AppConstant.colorDrawerButton,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
              child: Text("Contato", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppConstant.colorHeading)),
              onPressed: () {
                _onContatoPress();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: MaterialButton(
              minWidth: 328,
              height: 48,
              elevation: 0,
              color: AppConstant.colorDrawerButton,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
              child: Text("Sair", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppConstant.colorPullDown1)),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();

                Navigator.pushReplacementNamed(context, AppConstant.pageLogin);

              },
            ),
          ),
        ],
      )
    ],
  );
  void __onSobrePressed() {
    //Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * .5,
            child: Container(
              child: AppBottomSheetWidgets.buildHakkindaItem(_itemTopMenu("")),
              decoration: AppBottomSheetWidgets.bottomSheetBoxDecoration,
            ),
          );
        });
  }
  void _onContatoPress() {
    //Navigator.pop(context);
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Container(
              height: MediaQuery.of(context).size.height * .9,
              child: Container(child: _renderItem(setState), decoration: AppBottomSheetWidgets.bottomSheetBoxDecoration),
            ),
          );
        });
  }
  Widget _itemTopMenu(String heading) => Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        /*new RawMaterialButton(
          onPressed: () {
            Navigator.pop(context);
            _onDrawerButtonPressed();
          },
          child: new Icon(Icons.arrow_back_ios, color: AppConstant.colorBackButton, size: 13.0),
          shape: new CircleBorder(),
          elevation: 0,
          fillColor: AppConstant.colorDrawerButton,
          padding: const EdgeInsets.all(15.0),
        ),*/
        Spacer(),
       // Text(heading, style: TextStyle(fontSize: 14, color: AppConstant.colorHeading, fontWeight: FontWeight.w500)),
        //Spacer(),
        //Spacer(),
      ],
    ),
  );
  void _onDrawerButtonPressed() {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {}
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * .5,
            child: Container(child: _buildDrawerItem, decoration: AppBottomSheetWidgets.bottomSheetBoxDecoration),
          );
        });
  }
  Widget _renderItem(StateSetter setState) => Column(
    children: <Widget>[
      Expanded(
        child: AppBottomSheetWidgets.buildcontatoPage(_itemTopMenu(AppConstant.iletisimBilgileri)),
      ),

    ],
  );

  Widget _horizontalCategoryItem({@required int id, @required String title}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = 1;
        });
        _pageController.animateToPage(_selectedCategory, duration: Duration(milliseconds: 300), curve: Curves.ease);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: AppConstant.colorPageBg,
        height: MediaQuery.of(context).size.height * .10,
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$title',
                  textAlign: TextAlign.center, style: TextStyle(fontWeight: _selectedCategory == id ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
              SizedBox(height: 4),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 2,
                width: _selectedCategory == id ? title.length * 2.5 : 0,
                decoration: BoxDecoration(color: AppConstant.colorPrimary, borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(child: _buildDrawerItem, decoration: AppBottomSheetWidgets.bottomSheetBoxDecoration);
  }

}