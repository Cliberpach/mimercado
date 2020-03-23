import 'package:flutter/material.dart';
import '../util/util.dart';
import '../models/globalTexts.dart';
import '../models/globalButtons.dart';

class GlobalAlerts {
  Util util = Util();
  GlobalTexts globalTexts = GlobalTexts();
  GlobalButtons globalButtons = GlobalButtons();


  Widget alertOne(
    context, {
    borderRadius: 10.0,
    color: 0xFFFFFFFF,
    paddingX: 10.0,
    paddingY: 10.0,
    icon: null,
    iconColor: 0xFFFFFFFF,
    iconSize: 80.0,
    title: "Hmmm...",
    titleSize: 20.0,
    titleColor: 0xFF253239,
    description: "Parece que estás desconectado.",
    descSize: 16.0,
    descColor: 0xFF253239,
    optionsPaddingX: 15.0,
    optionsPaddingY: 15.0,
    optionOneBackground: 0xFFFFFFFF,
    optionOne: "",
    optionOneSize: 18.0,
    optionOneColor: 0xFF000000,
    optionOneEvt(),
    optionTwoBackground: 0xFFFFFFFF,
    optionTwo: "",
    optionTwoSize: 18.0,
    optionTwoColor: 0xFF000000,
    optionTwoEvt(),
    closeBackground: 0xFFFFFFFF,
    close: "Cerrar",
    closeSize: 18.0,
    closeColor: 0xFF99C6F6,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(0.0),
          backgroundColor: Color(0x00000000),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.fromLTRB(
                        paddingX, paddingY, paddingX, paddingY),
                    decoration: BoxDecoration(
                      color: Color(color),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        icon != null
                            ? Container(
                                child: Icon(icon,
                                    color: Color(iconColor), size: iconSize),
                              )
                            : SizedBox(),
                        SizedBox(height: 10.0),
                        title != ""
                            ? Text(
                                "${title}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: titleSize,
                                    color: Color(titleColor)),
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(),
                        SizedBox(height: 10.0),
                        description != ""
                            ? Text(
                                "${description}",
                                style: TextStyle(
                                    fontSize: descSize,
                                    color: Color(descColor)),
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      optionOne != ""
                          ? Expanded(
                              child: Material(
                                color: Color(optionOneBackground),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(borderRadius),
                                  bottomRight: Radius.circular(borderRadius),
                                ),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        optionsPaddingX,
                                        optionsPaddingY,
                                        optionsPaddingX,
                                        optionsPaddingY),
                                    child: Center(
                                      child: Text(
                                        "${optionOne}",
                                        style: TextStyle(
                                            color: Color(optionOneColor),
                                            fontSize: optionOneSize,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
                                  ),
                                  onTap: optionOneEvt,
                                ),
                              ),
                            )
                          : SizedBox(),
                      optionTwo != ""
                          ? Expanded(
                              child: Material(
                                color: Color(optionTwoBackground),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(borderRadius),
                                  bottomRight: Radius.circular(borderRadius),
                                ),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        optionsPaddingX,
                                        optionsPaddingY,
                                        optionsPaddingX,
                                        optionsPaddingY),
                                    child: Center(
                                      child: Text(
                                        "${optionTwo}",
                                        style: TextStyle(
                                            color: Color(optionTwoColor),
                                            fontSize: optionTwoSize,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
                                  ),
                                  onTap: optionTwoEvt,
                                ),
                              ),
                            )
                          : SizedBox(),
                      optionOne == "" && optionTwo == ""
                          ? Expanded(
                              child: Material(
                                color: Color(closeBackground),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(borderRadius),
                                  bottomRight: Radius.circular(borderRadius),
                                ),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        optionsPaddingX,
                                        optionsPaddingY,
                                        optionsPaddingX,
                                        optionsPaddingY),
                                    child: Center(
                                      child: Text(
                                        "${close}",
                                        style: TextStyle(
                                            color: Color(closeColor),
                                            fontSize: closeSize,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
                                  ),
                                  onTap: () => Navigator.pop(context),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget loading(context,
      {title: "",
      description: "",
      progressColor: 0xFFFFFFFF,
      progressStroke: 5.0,
      progressSize: 30.0}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color(0x91000000),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(progressColor)),
                  strokeWidth: progressStroke),
              height: progressSize,
              width: progressSize,
            ),
            title != ""
                ? Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Text(
                      "${title}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),
            description != ""
                ? Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      "${description}",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void snackBar(scaffoldKey, title, duration) {
    return scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(title),
      duration: Duration(seconds: duration),
    ));
  }

  Widget error(context, evt(),
      {img: "assets/img/error.png",
      icon: null,
      title: "Algo no está funcionando como esperábamos",
      textButton: "Reintentar"}) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            img != ""
                ? Container(
                    height: 160,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(img),
                    )),
                  )
                : SizedBox(),
            icon != null && img == "" ? icon : SizedBox(),
            globalTexts.textOne(
              marginTop: 20.0,
              marginBottom: 20.0,
              title: title,
              fontSize: 30.0,
              fontFamily: "GeoBlack",
              textColor: util.colorSix,
              textAlign: TextAlign.center,
            ),
            globalButtons.buttonTwo(context,
                minWidth: double.minPositive,
                colorButton: util.greenAccent,
                title: textButton,
                fontFamily: "GeoBold",
                evt: evt(),
                borderRadius: 5.0,
                paddingY: 10.0)
          ],
        ),
      ),
    );
  }
}
