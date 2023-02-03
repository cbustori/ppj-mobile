import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppj/core/blocs/deep_link.dart';
import 'package:ppj/ui/views/events_list_tab/event_list_view.dart';
import 'package:provider/provider.dart';

class DeepLinkWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return EventListView();
        } else {
          return Container(child: Center(child: Text('${snapshot.data}')));
        }
      },
    );
  }
}
