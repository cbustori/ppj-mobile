import 'package:ppj/core/services/tag_service.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/locator.dart';
import 'package:bloc/bloc.dart';

import 'filtered_events_event.dart';
import 'filtered_events_state.dart';

class FilteredEventsBloc
    extends Bloc<FilteredEventsEvent, FilteredEventsState> {
  final _tagService = locator<TagService>();

  @override
  FilteredEventsState get initialState => EventsFiltersUninitialized();

  @override
  Stream<FilteredEventsState> mapEventToState(
      FilteredEventsEvent event) async* {
    if (event is LoadEventsFilters) {
      yield EventsFiltersLoading();
      try {
        List<String> tags = await _tagService.getTags('food-type');
        yield EventsFiltersLoaded(filter: event.filter, tags: tags);
      } on AppException catch (e) {
        yield EventsFiltersError(errorMsg: e.toString());
      }
    }
  }
}
