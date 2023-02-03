import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:ppj/core/models/dish.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/ui/shared/distance_helper.dart';
import 'package:ppj/ui/widgets/carousel_pictures.dart';
import 'package:share/share.dart';

class EventListWidget extends StatelessWidget {
  final NumberFormat _formatter = new NumberFormat('0.##€', 'fr_FR');
  final Event event;
  final LatLng position;

  EventListWidget(this.event, this.position);

  @override
  Widget build(BuildContext context) {
    void share(Event e) {
      final RenderBox box = context.findRenderObject().parent.parent;
      Share.share('Plat du jour incroyable https://dev.plaplajour.fr/${e.id}',
          subject: e.description,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    String _calculateDistance(LatLng pos1, LatLng pos2) {
      Distance distance = new Distance();
      double m = distance.as(LengthUnit.Meter, pos1, pos2);
      return DistanceHelper.getDistance(m);
    }

    ListTile _makeListTile(Event event) => ListTile(
        onTap: () {
          Navigator.pushNamed(context, 'event-details', arguments: event);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        isThreeLine: true,
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(right: new BorderSide(width: 1.0))),
          child: Icon(event.place.icon),
        ),
        title: Text(
          event.title,
          style: TextStyle(fontSize: 15),
        ),
        subtitle: Text(event.place.name));

    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: ClipPath(
          child: Container(
            child: Column(children: <Widget>[
              CarouselPictures(imgList: event.pictures),
              Container(
                height: 60,
                child: _makeListTile(event),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 5.0,
                  left: 10.0,
                ),
                width: double.infinity,
                height: 80,
                child: Text(event.description, style: TextStyle(fontSize: 17)),
                decoration: new BoxDecoration(
                    border: new Border(bottom: new BorderSide(width: 0.15))),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10.0),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ButtonBar(
                      buttonPadding: EdgeInsets.all(0),
                      children: <Widget>[
                        IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.share),
                          color: Colors.grey,
                          onPressed: () => share(event),
                        ),
                        IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite),
                          color: Colors.grey,
                          onPressed: () => null,
                        ),
                      ],
                    ),
                    Text(
                      event is Dish
                          ? _formatter.format((event as Dish).price)
                          : "",
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 22),
                    ),
                  ],
                ),
              )
            ]),
          ),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))),
        ));
  }
}
