import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/filtered_events/filtered_events.dart';
import 'package:ppj/core/enums/filter_place_type.dart';
import 'package:ppj/ui/shared/event_filters.dart';
import 'package:ppj/ui/widgets/app_bar.dart';

class EventFilterForm extends StatefulWidget {
  final EventFilter filter;
  EventFilterForm({this.filter});
  @override
  State<StatefulWidget> createState() => EventFilterFormState();
}

class EventFilterFormState extends State<EventFilterForm> {
  double _minPrice = 10;
  double _maxPrice = 40;
  double _maxDistance = 2;
  String _placeType;
  var _selectedFoodTypes = List<String>();

  @override
  void initState() {
    _minPrice = widget.filter?.minPrice ?? _minPrice;
    _maxPrice = widget.filter?.maxPrice ?? _maxPrice;
    _maxDistance = widget.filter?.maxDistance ?? _maxDistance;
    _placeType = FilterPlaceTypeHelper.stringValue(widget.filter?.placeType);
    _selectedFoodTypes = widget.filter?.foodTags ?? _selectedFoodTypes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildChoiceList(EventsFiltersLoaded state) {
      List<Widget> choices = List();
      state.tags.forEach((item) {
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
            selected: _selectedFoodTypes.contains(item),
            labelStyle: TextStyle(color: Colors.black),
            selectedColor: Theme.of(context).accentColor,
            onSelected: (selected) {
              setState(() {
                _selectedFoodTypes.contains(item)
                    ? _selectedFoodTypes.remove(item)
                    : _selectedFoodTypes.add(item);
              });
            },
          ),
        ));
      });
      return choices;
    }

    return BlocListener<FilteredEventsBloc, FilteredEventsState>(
        listener: (context, state) {
      if (state is EventsFiltersError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child: BlocBuilder<FilteredEventsBloc, FilteredEventsState>(
            builder: (context, state) {
      if (state is EventsFiltersLoaded) {
        return Scaffold(
          appBar: PPJAppBar(
            backButtonVisible: true,
            titleName: "Filtres",
          ),
          body: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.topLeft,
                child: new Text(
                  'Fourchette de prix',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                margin: new EdgeInsets.only(left: 20.0, bottom: 5.0, top: 30.0),
              ),
              new Container(
                child: new RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0.0,
                  max: 70.0,
                  labels: RangeLabels(
                      "${_minPrice.round()}€", "${_maxPrice.round()}€"),
                  divisions: 7,
                  onChanged: (values) {
                    setState(() {
                      _minPrice = values.start.roundToDouble();
                      _maxPrice = values.end.roundToDouble();
                    });
                  },
                ),
                margin: new EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              new Container(
                alignment: Alignment.topLeft,
                child: new Text(
                  "Type d'établissement",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                margin: new EdgeInsets.only(left: 20.0, bottom: 5.0, top: 30.0),
              ),
              Card(
                  elevation: 2.0,
                  margin:
                      new EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: DropdownButton<String>(
                      value: _placeType,
                      hint: Text('Tous...'),
                      underline: Container(),
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _placeType = newValue;
                        });
                      },
                      items: FilterPlaceTypeHelper.getTypes()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              new Container(
                alignment: Alignment.topLeft,
                child: new Text(
                  'Proximité',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                margin: new EdgeInsets.only(left: 20.0, bottom: 5.0, top: 30.0),
              ),
              new Container(
                child: new Slider(
                  value: _maxDistance,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: "Moins de ${_maxDistance.round()} km",
                  onChanged: (values) {
                    setState(() {
                      _maxDistance = values;
                    });
                  },
                ),
                margin: new EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              new Container(
                alignment: Alignment.topLeft,
                child: new Text(
                  'Type de cuisine',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                margin: new EdgeInsets.only(left: 20.0, bottom: 5.0, top: 20.0),
              ),
              Wrap(
                children: _buildChoiceList(state),
              ),
            ],
          )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _applyFilters,
            isExtended: true,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text('Afficher les résultats'),
          ),
        );
      } else if (state is EventsFiltersLoading) {
        return Container(
            color: Theme.of(context).primaryColorDark,
            child: Center(child: CircularProgressIndicator()));
      } else {
        return Container();
      }
    }));
  }

  void _applyFilters() {
    EventFilter ef = EventFilter()
      ..foodTags = _selectedFoodTypes
      ..placeType = FilterPlaceTypeHelper.fromType(_placeType)
      ..minPrice = _minPrice
      ..maxPrice = _maxPrice
      ..maxDistance = _maxDistance;
    Navigator.pop(context, ef);
  }
}
