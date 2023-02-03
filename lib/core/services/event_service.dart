import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:ppj/core/enums/event_date_filter.dart';
import 'package:ppj/core/models/dish.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/place.dart';
import 'package:ppj/core/services/graphql_service.dart';
import 'package:intl/intl.dart';
import 'package:ppj/locator.dart';
import 'package:ppj/ui/shared/event_filters.dart';

class EventService {
  GraphQLService _graphqlService = locator<GraphQLService>();
  final formatter = new DateFormat('yyyy-MM-dd');
  final maxDistance = 3;

  Future<List<Event>> getEvents(EventDateFilterEnum period, LatLng position,
      EventFilter filters, int start, int limit) async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .query(QueryOptions(
          documentNode: gql(_queryEventsAroundMe),
          variables: <String, dynamic>{
            'position': [position.latitude, position.longitude],
            'availableOn': describeEnum(period),
            'start': start,
            'limit': limit,
            'filters' : filters?.toJson(),
          },
        ))
        .catchError((e) => {print('error caught')});
    return _toEvent(result, 'eventsAroundMe');
  }

  Future<List<Event>> getEventsByPlace(
      Place place, int start, int limit) async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .query(QueryOptions(
          documentNode: gql(_queryEventsByPlace),
          variables: <String, dynamic>{
            'placeId': place.id,
            'start': start,
            'limit': limit
          },
        ))
        .catchError((e) => {print('error caught')});
    return _toEvent(result, 'eventsByPlace');
  }

  Future<List<Event>> getEventsByUserAndDate(DateTime date) async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .query(QueryOptions(
          documentNode: gql(_queryEventsByUserAndDate),
          variables: <String, dynamic>{'availableOn': formatter.format(date)},
        ))
        .catchError((e) => {print('error caught')});
    return _toEvent(result, 'eventsByUserAndDate');
  }

  List<Event> _toEvent(QueryResult queryResult, String method) {
    if (queryResult.hasException) {
      print(queryResult.exception);
      throw Exception();
    }

    final list = queryResult.data[method] as List<dynamic>;
    return list?.map((repoJson) => Event.fromJson(repoJson))?.toList() ??
        List();
  }

  Event _toSingleEvent(QueryResult queryResult, String method) {
    if (queryResult.hasException) {
      throw Exception();
    }
    final json = queryResult.data[method] as Map<String, dynamic>;
    return Event.fromJson(json);
  }

  Future<Event> createDish(Dish event) async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .mutate(MutationOptions(
            documentNode: gql(_mutateEvent),
            variables: <String, dynamic>{
              'eventId': event.id,
              'placeId': event.place.id,
              'desc': event.description,
              'price': event.price,
              'availableOn': formatter.format(event.availableOn),
              'tags': event.tags
            }))
        .catchError((e) => {print('error caught')});
    return _toSingleEvent(result, 'createDish');
  }

  Future<bool> deleteEvent(Event event) async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    await _client
        .mutate(MutationOptions(
            documentNode: gql(_deleteEvent),
            variables: <String, dynamic>{'eventId': event.id}))
        .catchError((e) => {print('error caught')});
    return true;
  }

  static String _fragmentEvent = r'''id
            title
            description
            type
            availableOn
            place {
              id
              name
              type
              pictures {
                url
              }
              address {
                street
                city
                zipCode
                country
                location
              }
            }
            pictures {
              url
              publicId
            }
            tags
            ... on Dish {
              price
            }''';

  final String _queryEventsAroundMe = r'''
  query($position: [Float!]!, $availableOn: EventDateFilterEnum!, $start: Int!, $limit: Int!, $filters: EventFiltersInput) {
          eventsAroundMe(position: $position, availableOn: $availableOn, start: $start, limit: $limit, filters: $filters) {
            ''' +
      _fragmentEvent +
      '''
          }
  }''';

  final String _queryEventsByPlace = r'''
  query($placeId: ID!, $start: Int!, $limit: Int!) {
          eventsByPlace(placeId: $placeId, start: $start, limit: $limit) {
            ''' +
      _fragmentEvent +
      '''
          }
  }''';

  final String _queryEventsByUserAndDate = r'''
  query($availableOn: Date!) {
          eventsByUserAndDate(availableOn: $availableOn) { 
            ''' +
      _fragmentEvent +
      ''' 
          }
  }''';
  final String _mutateEvent =
      r'''mutation ($eventId: ID, $placeId: ID!, $desc: String!, $price: Float, $availableOn: Date!, $tags: [String]){
            createDish(dish: {event: {eventId: $eventId, placeId: $placeId, description: $desc, availableOn: $availableOn, tags: $tags}, price: $price}) {
            ''' +
          _fragmentEvent +
          '''
            }
        }''';
  final String _deleteEvent = r'''mutation ($eventId: ID!){
            deleteEvent(eventId: $eventId)
          }''';
}
