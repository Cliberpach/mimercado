import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:anvic/beans/pic.dart';

class VGalleryProduct extends StatefulWidget {
  List<Pic> pics = [];
  Pic pic = null;

  VGalleryProduct({Key key, this.pics, this.pic});

  @override
  _VGalleryProductState createState() => _VGalleryProductState();
}

class _VGalleryProductState extends State<VGalleryProduct> {
  _VGalleryProductState();

  init() {
    if (widget.pics.length == 0) {
      widget.pics.add(widget.pic);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Colors.black,
      child: Container(
          child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.pics[index].pic_large),
            heroTag: widget.pics[index].id,
            initialScale: PhotoViewComputedScale.contained * 0.98,
            minScale: PhotoViewComputedScale.contained * 0.98,
            maxScale: PhotoViewComputedScale.contained * 3.5,
          );
        },
        itemCount: widget.pics.length,
        loadingChild: null,
        pageController: null,
        onPageChanged: null,
      )),
    );
  }
}
