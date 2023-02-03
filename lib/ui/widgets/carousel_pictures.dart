import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ppj/core/models/picture.dart';

class CarouselPictures extends StatefulWidget {
  final List<Picture> imgList;

  CarouselPictures({this.imgList});

  @override
  State<StatefulWidget> createState() {
    return CarouselPicturesState();
  }
}

class CarouselPicturesState extends State<CarouselPictures> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      CarouselSlider(
        items: getSlider(),
        options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imgList.map((url) {
          int index = widget.imgList.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    ]));
  }

  List<Widget> getSlider() {
    return widget.imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item.url,
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                        /*   Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ), */
                      ],
                    )),
              ),
            ))
        .toList();
  }
}
