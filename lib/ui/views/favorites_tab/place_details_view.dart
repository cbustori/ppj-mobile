import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/favorites/favorites_bloc.dart';
import 'package:ppj/core/blocs/place_details/place_details.dart';
import 'package:ppj/core/models/place.dart';

import 'place_details.dart';

class PlaceDetailsView extends StatelessWidget {
  final FavoritesBloc favoritesBloc;
  final Place place;

  PlaceDetailsView({@required this.favoritesBloc, @required this.place})
      : assert(favoritesBloc != null && place != null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceDetailsBloc>(
        builder: (context) => PlaceDetailsBloc(favoritesBloc: favoritesBloc)
          ..add(new LoadEventDetails(place: place)),
        child: PlaceDetails(place: place));
  }
}
