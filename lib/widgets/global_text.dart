import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../util/Config.dart';

//Flexible
//Aligment false

class GlobalText extends StatelessWidget {
  //Alignment
  Alignment alignment;
  Alignment alignmentContent;

  //Container Margin
  double width;
  double height;
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

  //Text properties
  String textTitle;
  TextOverflow textOverflow;
  bool textSoftWrap;
  int textMaxLines;
  TextAlign textAlign;

  //Text properties
  Color textColor;
  String textFontFamily;
  double textFontSize;
  FontWeight textFontWeight;

  //Icon
  Icon icon;

  //Img
  String imgUrl;
  String imgPlaceholder;
  String imgAsset;
  double imgWidth;
  double imgHeight;
  BoxFit imgBoxFit;

  //Callback
  VoidCallback callback;

  GlobalText(
      {Key key,
      this.alignment,
      this.alignmentContent,
      this.width,
      this.height,
      this.margin,
      this.marginTop = 10.0,
      this.marginRight = 10.0,
      this.marginBottom = 10.0,
      this.marginLeft = 10.0,
      this.padding,
      this.paddingTop = 0.0,
      this.paddingRight = 0.0,
      this.paddingBottom = 0.0,
      this.paddingLeft = 0.0,
      this.background,
      this.radius,
      this.radiusTopLeft = 0.0,
      this.radiusTopRight = 0.0,
      this.radiusBottomLeft = 0.0,
      this.radiusBottomRight = 0.0,
      this.textTitle = "",
      this.textOverflow = TextOverflow.fade,
      this.textSoftWrap = false,
      this.textMaxLines,
      this.textAlign,
      this.textColor,
      this.textFontFamily,
      this.textFontSize,
      this.textFontWeight,
      this.icon,
      this.imgUrl,
      this.imgPlaceholder = "",
      this.imgAsset,
      this.imgWidth = 60.0,
      this.imgHeight = 60.0,
      this.imgBoxFit = BoxFit.cover,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment != null ? alignment : Alignment.centerLeft,
            child: GlobalText(
              alignment: null,
              width: width,
              height: height,
              margin: margin,
              marginTop: marginTop,
              marginRight: marginRight,
              marginBottom: marginBottom,
              marginLeft: marginLeft,
              padding: padding,
              paddingTop: paddingTop,
              paddingRight: paddingRight,
              paddingBottom: paddingBottom,
              paddingLeft: paddingLeft,
              background: background,
              radius: radius,
              radiusTopLeft: radiusTopLeft,
              radiusTopRight: radiusTopRight,
              radiusBottomLeft: radiusBottomLeft,
              radiusBottomRight: radiusBottomRight,
              textTitle: textTitle,
              textOverflow: textOverflow,
              textSoftWrap: textSoftWrap,
              textMaxLines: textMaxLines,
              textAlign: textAlign,
              textColor: textColor,
              textFontFamily: textFontFamily,
              textFontSize: textFontSize,
              textFontWeight: textFontWeight,
              icon: icon,
              imgUrl: imgUrl,
              imgPlaceholder: imgPlaceholder,
              imgAsset: imgAsset,
              imgWidth: imgWidth,
              imgHeight: imgHeight,
              imgBoxFit: imgBoxFit,
              callback: callback,
            ),
          )
        : Container(
            height: height,
            width: width,
            margin: margin != null
                ? EdgeInsets.all(margin)
                : EdgeInsets.fromLTRB(
                    marginLeft, marginTop, marginRight, marginBottom),
            decoration: BoxDecoration(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius)
                  : BorderRadius.only(
                      topLeft: Radius.circular(radiusTopLeft),
                      topRight: Radius.circular(radiusTopRight),
                      bottomLeft: Radius.circular(radiusBottomLeft),
                      bottomRight: Radius.circular(radiusBottomRight),
                    ),
            ),
            child: Material(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius)
                  : BorderRadius.only(
                      topLeft: Radius.circular(radiusTopLeft),
                      topRight: Radius.circular(radiusTopRight),
                      bottomLeft: Radius.circular(radiusBottomLeft),
                      bottomRight: Radius.circular(radiusBottomRight),
                    ),
              color: background != null ? background : Color(0x00000000),
              child: InkWell(
                child: Container(
                  padding: padding != null
                      ? EdgeInsets.all(padding)
                      : EdgeInsets.fromLTRB(
                          paddingLeft, paddingTop, paddingRight, paddingBottom),
                  child: icon != null
                      ? alignmentContent != null
                          ? Align(
                              alignment: alignmentContent,
                              child: icon,
                            )
                          : icon
                      : imgUrl != null || imgAsset != null
                          ? ClipRRect(
                              borderRadius: radius != null
                                  ? BorderRadius.circular(radius)
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(radiusTopLeft),
                                      topRight: Radius.circular(radiusTopRight),
                                      bottomLeft:
                                          Radius.circular(radiusBottomLeft),
                                      bottomRight:
                                          Radius.circular(radiusBottomRight),
                                    ),
                              child: imgUrl != null
                                  ? CachedNetworkImage(
                                      width: imgWidth,
                                      height: imgHeight,
                                      fit: imgBoxFit,
                                      imageUrl: imgUrl,
                                      placeholder: (context, url) => Image(
                                        height: imgHeight,
                                        width: imgWidth,
                                        fit: imgBoxFit,
                                        image: AssetImage(imgPlaceholder),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image(
                                        height: imgHeight,
                                        width: imgWidth,
                                        fit: imgBoxFit,
                                        image: AssetImage(imgPlaceholder),
                                      ),
                                    )
                                  : Image(
                                      height: imgHeight,
                                      width: imgWidth,
                                      fit: imgBoxFit,
                                      image: AssetImage(imgAsset),
                                    ),
                            )
                          : alignmentContent != null
                              ? Align(
                                  alignment: alignmentContent,
                                  child: Text(
                                    textTitle,
                                    overflow: textOverflow,
                                    softWrap: textSoftWrap,
                                    maxLines: textMaxLines,
                                    textAlign: textAlign,
                                    style: TextStyle(
                                      color: textColor != null
                                          ? textColor
                                          : Config.colorText,
                                      fontFamily: textFontFamily,
                                      fontSize: textFontSize,
                                      fontWeight: textFontWeight,
                                    ),
                                  ),
                                )
                              : Text(
                                  textTitle,
                                  overflow: textOverflow,
                                  softWrap: textSoftWrap,
                                  maxLines: textMaxLines,
                                  textAlign: textAlign,
                                  style: TextStyle(
                                    color: textColor != null
                                        ? textColor
                                        : Config.colorText,
                                    fontFamily: textFontFamily,
                                    fontSize: textFontSize,
                                    fontWeight: textFontWeight,
                                  ),
                                ),
                ),
                borderRadius: radius != null
                    ? BorderRadius.circular(radius)
                    : BorderRadius.only(
                        topLeft: Radius.circular(radiusTopLeft),
                        topRight: Radius.circular(radiusTopRight),
                        bottomLeft: Radius.circular(radiusBottomLeft),
                        bottomRight: Radius.circular(radiusBottomRight),
                      ),
                onTap: callback,
              ),
            ),
          );
  }
}
