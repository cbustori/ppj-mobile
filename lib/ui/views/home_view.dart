import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/navigation/navigation.dart';
import 'package:ppj/core/enums/app_tab.dart';
import 'package:ppj/core/models/user.dart';

import 'events_list_tab/event_list.dart';
import 'events_map_tab/event_map_view.dart';
import 'favorites_tab/favorites_view.dart';
import 'planning_tab/manager_planning_view.dart';
import 'profile_tab/profile_view.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({this.user});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgets = new List();
  List<BottomNavigationBarItem> _items = new List();

  @override
  void initState() {
    super.initState();
    _widgets.addAll(
        [EventList(), EventOnMapView(), FavoritesView(), ProfileView()]);
    _items.addAll(const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu), title: Text("")),
      BottomNavigationBarItem(icon: Icon(Icons.place), title: Text("")),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text("")),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), title: Text("")),
    ]);
    if (widget.user.managedPlaces?.isNotEmpty ?? false) {
      _widgets.insert(3, PlanningEventView());
      _items.insert(
          3,
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgets,
        ),
        bottomNavigationBar: BottomNavigationBar(
          //selectedItemColor: const Color(0xFF94af76),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: _items,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      );
    });
  }

  AppTab _getTabByIndex() {
    switch (_selectedIndex) {
      case 0:
        return AppTab.events;
      case 1:
        return AppTab.map;
      case 2:
        return AppTab.favorites;
      case 3:
        return (widget.user.managedPlaces?.isNotEmpty ?? false)
            ? AppTab.calendar
            : AppTab.profile;
      case 4:
        return AppTab.profile;
      default:
        return AppTab.events;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      BlocProvider.of<NavigationBloc>(context).add(UpdateTab(_getTabByIndex()));
    });
  }
}
