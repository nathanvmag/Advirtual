import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sozluk/util/app_constant.dart';
import 'package:sozluk/util/app_widget.dart';
import 'package:sozluk/util/screen_util.dart';

class SearchBox extends StatelessWidget {
  final bool isKeyboardVisible;
  final bool isScrollSearchBody;
  final double searchBoxScrollPosition;
  final FocusNode focusNode;
  final TextEditingController searchController;

  SearchBox({this.isKeyboardVisible, this.focusNode, this.isScrollSearchBody, this.searchBoxScrollPosition ,this.searchController  } );

  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
      duration: Duration(milliseconds: !isKeyboardVisible ? 220 : 0),
      top: isKeyboardVisible ? searchBoxScrollPosition : ScreenUtil.getHeight(context) * .2 - 26,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 220),
        opacity: !isScrollSearchBody && isKeyboardVisible ? 0.0 : 1.0,
        child: Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height:  isKeyboardVisible?3.0*52: 52.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isKeyboardVisible ? Color(0xFFF3A5B1) : Colors.transparent),
                    boxShadow: [
                      !isKeyboardVisible
                          ? BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5.0, offset: Offset(0, 10))
                          : BoxShadow(color: AppConstant.colorPrimary.withOpacity(0.1), offset: Offset(0, 0), blurRadius: 3, spreadRadius: 1)
                    ]),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Theme(
                  data: AppWidget.getThemeData().copyWith(primaryColor: Colors.grey),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: searchController,
                          maxLines: isKeyboardVisible?7:1,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.left,

                          decoration: InputDecoration(
                            hintText: 'Digite aqui sua pergunta',
                            hintStyle: TextStyle(fontSize: 14, color: AppConstant.colorBackButton),
                            //
                            filled: true,


                            fillColor: Colors.white,
                            prefixIcon: isKeyboardVisible? null:Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child: Icon(
                                FontAwesomeIcons.questionCircle,
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
                      isKeyboardVisible
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: AppConstant.colorBackButton,
                                size: 20,
                              ),
                              onPressed: () {
                                searchController.text = "";
                                FocusScope.of(context).requestFocus(FocusNode());

                              },
                            )
                          : Container()
                    ],
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
//                          FocusScope.of(context).requestFocus(FocusNode());