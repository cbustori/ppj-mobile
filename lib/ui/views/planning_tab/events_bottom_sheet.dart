import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppj/core/models/event.dart';

class EventsBottomSheet extends StatelessWidget {
  final Event event;
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  const EventsBottomSheet({Key key, this.event, this.onTap, this.onDismissed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formatter = DateFormat('dd MMMM', 'fr_FR');
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Column(children: <Widget>[
          SizedBox(
              height: 80.0,
              child: Dismissible(
                  key: Key('EventItem__${event.id}'),
                  background: Container(color: Colors.red),
                  onDismissed: onDismissed,
                  child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      title: Text(event.description),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).buttonColor,
                        radius: 20.0,
                        child: FlutterLogo(),
                      ),
                      isThreeLine: true,
                      subtitle: Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.0),
                        ),
                        Icon(Icons.event,
                            color: Theme.of(context).primaryColorDark,
                            size: 18.0),
                        Padding(padding: EdgeInsets.only(right: 5.0)),
                        Text(_formatter.format(event.availableOn)),
                        Padding(padding: EdgeInsets.only(right: 5.0)),
                        Icon(Icons.place,
                            color: Theme.of(context).primaryColorDark,
                            size: 18.0),
                        Padding(padding: EdgeInsets.only(right: 5.0)),
                        Text(event.place.name)
                      ]),
                      onTap: onTap))),
        ]));
  }
}
