import 'package:anvic/util/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MaskedDateFormatter.dart';

class GlobalTextFormField extends StatefulWidget {
  //Theme
  Color themeColor;
  Color themeColorError;

  //Container Margin
  double width;
  double margin;
  double marginTop;
  double marginRight;
  double marginBottom;
  double marginLeft;
  double padding;
  double paddingTop;
  double paddingRight;
  double paddingBottom;
  double paddingLeft;
  Color background;

  //Border Radius
  double radius;
  double radiusTopLeft;
  double radiusTopRight;
  double radiusBottomLeft;
  double radiusBottomRight;

  TextEditingController controller;
  FocusNode focusNode;
  TextInputAction textInputAction;
  TextCapitalization textCapitalization;
  TextInputType keyboardType;
  String textType;
  int maxLength;
  FocusNode requestFocus;
  FormFieldValidator validator;
  String labelText;
  VoidCallback onFieldSubmitted;

  GlobalTextFormField(
      {Key key,
      this.themeColor,
      this.themeColorError,
      this.width,
      this.margin,
      this.marginTop = 5.0,
      this.marginRight = 5.0,
      this.marginBottom = 5.0,
      this.marginLeft = 5.0,
      this.padding,
      this.paddingTop = 5.0,
      this.paddingRight = 5.0,
      this.paddingBottom = 5.0,
      this.paddingLeft = 5.0,
      this.background,
      this.radius,
      this.radiusTopLeft = 0.0,
      this.radiusTopRight = 0.0,
      this.radiusBottomLeft = 0.0,
      this.radiusBottomRight = 0.0,
      this.controller,
      this.focusNode,
      this.textInputAction = TextInputAction.next,
      this.textCapitalization: TextCapitalization.sentences,
      this.keyboardType: TextInputType.text,
      this.textType = "",
      this.maxLength,
      this.requestFocus,
      this.validator,
      this.labelText,
      this.onFieldSubmitted = null})
      : super(key: key);

  @override
  _GlobalTextFormFieldState createState() => _GlobalTextFormFieldState();
}

class _GlobalTextFormFieldState extends State<GlobalTextFormField> {
  bool textClear = false;
  var hidePassword = true;

  init() {
    widget.controller.addListener(() {
      if (widget.controller.text == "") {
        setState(() => textClear = false);
      } else {
        setState(() => textClear = true);
      }

      print("PRINT: ${widget.controller.text} TYPE: ${widget.textType}");
    });
  }

  clear() {
    widget.controller.text = "";
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: widget.width,
        margin: widget.margin != null
            ? EdgeInsets.all(widget.margin)
            : EdgeInsets.fromLTRB(widget.marginLeft, widget.marginTop,
                widget.marginRight, widget.marginBottom),
        padding: widget.padding != null
            ? EdgeInsets.all(widget.padding)
            : EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
                widget.paddingRight, widget.paddingBottom),
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: widget.radius != null
              ? BorderRadius.circular(widget.radius)
              : BorderRadius.only(
                  topLeft: Radius.circular(widget.radiusTopLeft),
                  topRight: Radius.circular(widget.radiusTopRight),
                  bottomLeft: Radius.circular(widget.radiusBottomLeft),
                  bottomRight: Radius.circular(widget.radiusBottomRight),
                ),
        ),
        child: Theme(
          data: ThemeData(
              primaryColor: Config.colorPrimary,
              accentColor: Config.colorAccent),
          child: TextFormField(
            controller: widget.controller,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            keyboardType: widget.keyboardType,
            obscureText: widget.textType == "password" ? hidePassword : false,
            inputFormatters: widget.textType == "date"
                ? [
                    MaskedDateFormatter(),
                  ]
                : widget.maxLength != null
                    ? widget.textType == "number"
                        ? [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(widget.maxLength),
                          ]
                        : [
                            LengthLimitingTextInputFormatter(widget.maxLength),
                          ]
                    : null,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: TextStyle(color: Config.colorTextAccent),
              prefix: widget.textType == "password"
                  ? Container(
                      height: 22.0,
                      width: 22.0,
                      margin: EdgeInsets.only(top: 0, right: 5),
                      color: Config.colorTransparent,
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        child: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Config.colorAccent,
                        ),
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    )
                  : Container(
                      height: 22.0, width: 1.0, color: Config.colorTransparent),
              suffixIcon: textClear
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: clear,
                    )
                  : null,
              border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Config.colorTextAccent, width: 2)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Config.colorTextAccent, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Config.colorPrimary, width: 4)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Config.colorDanger, width: 2)),
            ),
            style: TextStyle(color: Config.colorText),
            validator: widget.validator,
            onFieldSubmitted: (_) {
              try {
                widget.onFieldSubmitted();
              } catch (e) {
                print("Error :: onFielSubmitted");
              }

              FocusScope.of(context).requestFocus(widget.requestFocus);
            },
          ),
        ),
      ),
    );
  }
}
