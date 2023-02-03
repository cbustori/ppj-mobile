import 'package:equatable/equatable.dart';
import 'package:ppj/core/enums/app_tab.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class UpdateTab extends NavigationEvent {
  final AppTab tab;

  const UpdateTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}
