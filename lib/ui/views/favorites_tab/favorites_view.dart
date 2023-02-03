import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/favorites/favorites.dart';
import 'package:ppj/core/enums/place_state.dart' as placeState;
import 'package:ppj/core/models/place.dart';
import 'package:ppj/ui/widgets/app_bar.dart';

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    ListTile _makeListTile(Place place) => ListTile(
        onTap: () {
          Navigator.pushNamed(context, 'place-details',
              arguments: [BlocProvider.of<FavoritesBloc>(context), place]);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(right: new BorderSide(width: 1.0))),
          child: Icon(place.icon),
        ),
        title: Text(
          place.name,
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
                child:
                    Text(placeState.PlaceStateHelper.fromValue(place.state))),
          ],
        ),
        trailing: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'place-details',
                  arguments: [BlocProvider.of<FavoritesBloc>(context), place]);
            },
            icon: Icon(Icons.keyboard_arrow_right),
            iconSize: 30.0));

    Widget _getChips(Place place) {
      if (place.tags == null) {
        return new Container();
      }
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: place.tags
                  .map((item) => Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: new Chip(label: Text(item))))
                  .toList()));
    }

    Card _makeCard(Place place) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          child: Container(
            child: Column(children: <Widget>[
              SizedBox(height: 70.0, child: _makeListTile(place)),
              Padding(
                padding: EdgeInsets.only(left: 60.0),
                child: _getChips(place),
              ),
              SizedBox(height: 10),
            ]),
          ),
        ));

    ListView _makeBody(List<Place> data) => ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return _makeCard(data[index]);
          },
        );

    Widget _getWidgetByState(FavoritesState state) {
      if (state is FavoritesLoading) {
        return Container(
            color: Theme.of(context).primaryColorDark,
            child: Center(child: CircularProgressIndicator()));
      } else if (state is FavoritesLoaded) {
        return Scaffold(
            appBar: PPJAppBar(
              titleName: "Favoris",
            ),
            body: state.places.isNotEmpty
                ? _makeBody(state.places)
                : Center(
                    child: Text(
                    "Aucun favori",
                    style: TextStyle(fontSize: 20),
                  )));
      }
      return Container();
    }

    return BlocListener<FavoritesBloc, FavoritesState>(listener:
        (context, state) {
      if (state is FavoritesError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child:
        BlocBuilder<FavoritesBloc, FavoritesState>(builder: (context, state) {
      return _getWidgetByState(state);
    }));
  }
}
