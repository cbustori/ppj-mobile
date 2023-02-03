import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ppj/core/blocs/events_to_add/events_to_add.dart';
import 'package:ppj/core/models/dish.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/place.dart';
import 'package:ppj/ui/widgets/app_bar.dart';

class AddEventView extends StatefulWidget {
  final DateTime date;
  final Event event;
  AddEventView({this.date, this.event}) : assert(date != null);

  @override
  State<StatefulWidget> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formatter = DateFormat('dd/MM/yyyy');
  final _dateController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  Place _place;
  var _selectedChoices = List<String>();
  var _dateEvent;

  @override
  void initState() {
    _dateEvent = widget.date;
    _dateController.text = _formatter.format(_dateEvent);
    if (widget.event != null) {
      _dateEvent = widget.event.availableOn;
      _dateController.text = _formatter.format(widget.event.availableOn);
      _descController.text = widget.event?.description;
      _place = widget.event?.place;
      if (widget.event is Dish) {
        _priceController.text = (widget.event as Dish).price?.toString();
      }
      _selectedChoices = widget.event.tags;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildChoiceList(EventsToAddLoaded state) {
      List<Widget> choices = List();
      state.tags.forEach((item) {
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
            labelStyle: TextStyle(color: Colors.black),
            selectedColor: Theme.of(context).accentColor,
            selected: _selectedChoices.contains(item),
            onSelected: (selected) {
              setState(() {
                _selectedChoices.contains(item)
                    ? _selectedChoices.remove(item)
                    : _selectedChoices.add(item);
              });
            },
          ),
        ));
      });
      return choices;
    }

    void _addEvent() {
      String priceText = _priceController.text;
      String desc = _descController.text;
      double price = priceText.isNotEmpty ? double.parse(priceText) : 0;
      if (_dateEvent == null || _place == null || desc.isEmpty || price == 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Informations incomplètes'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      Event event = new Dish(
          widget.event?.id, "", desc, _dateEvent, _place, _selectedChoices, null,
          price: price);
      BlocProvider.of<EventsToAddBloc>(context).add(AddEvent(event: event));
    }

    Widget _getWidgetByState(EventsToAddState state) {
      if (state is EventsToAddLoading) {
        return Container(child: Center(child: CircularProgressIndicator()));
      } else if (state is EventsToAddLoaded) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: PPJAppBar(
              titleName: widget.event == null
                  ? 'Plat du jour'
                  : widget.event.description,
              backButtonVisible: true,
              trailingButton: IconButton(
                  onPressed: _addEvent,
                  icon: Icon(
                    Icons.check,
                  )),
            ),
            body: Container(
                margin: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    TextField(
                      controller: _dateController,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(width: 2.0)),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        var date = await showDatePicker(
                            context: context,
                            initialDate: widget.date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          _dateController.text = _formatter.format(date);
                          _dateEvent = date;
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                          child: TextField(
                              controller: _descController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 12,
                              maxLength: 140,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                labelText: 'Description',
                                helperText: '140 caractères maximum',
                                alignLabelWithHint: true,
                                hintText:
                                    'Décrivez ici votre plat du jour en quelques mots...',
                                border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 2.0)),
                              ))),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                    ),
                    TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          labelText: 'Prix',
                          suffixIcon: Icon(Icons.euro_symbol, size: 18.0),
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2.0)),
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                    ),
                    Card(
                        elevation: 2.0,
                        child: Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: DropdownButton<Place>(
                              underline: Container(),
                              hint: Text('Choisir un établissement...'),
                              value: _place,
                              isExpanded: true,
                              onChanged: (Place newValue) {
                                setState(() {
                                  _place = newValue;
                                });
                              },
                              items: state.places
                                  .map<DropdownMenuItem<Place>>((Place value) {
                                return DropdownMenuItem<Place>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                  ),
                                );
                              }).toList()),
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Wrap(
                      children: _buildChoiceList(state),
                    ),
                  ],
                ))));
      }
      return Container();
    }

    return BlocListener<EventsToAddBloc, EventsToAddState>(
        listener: (context, state) {
      if (state is EventsToAddError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (state is EventAdded) {
        Navigator.pop(context, state.event);
      }
    }, child: BlocBuilder<EventsToAddBloc, EventsToAddState>(
            builder: (context, state) {
      return _getWidgetByState(state);
    }));
  }
}
