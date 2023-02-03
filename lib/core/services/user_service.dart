import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/core/models/place.dart';
import '../../locator.dart';
import '../models/user.dart';
import '../services/graphql_service.dart';

class UserService {
  GraphQLService _graphqlService = locator<GraphQLService>();

  final formatter = new DateFormat('yyyy-MM-dd');

  static String _fragmentProfile = r'''
            __typename
            id
            firstName
            name
            email
            phoneNumber
            backgroundPicture {
              url
            }
            profilePicture {
              url
            }
            managedPlaces {
              role
              place {
                id
                name
                type
                pictures{
                  url
                }
                address {
                  street
                  city
                  zipCode
                  country
                  location
                }
                tags
              }
            }
            favoritePlaces {
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
              tags 
            }''';

  final String _queryMe = r'''
  query{
          me {
            ''' +
      _fragmentProfile +
      ''' 
          }
  } ''';

  final String _queryProfile = r'''
  mutation($id: ID!, $lastName: String!, $firstName: String, $email: String!, $street: String!, $zipCode: String!, $city: String!, $country: String!, $phoneNumber: String) {
          updateProfile(user: {id: $id, lastName: $lastName, firstName: $firstName, email: $email, address: {street: $street, zipCode: $zipCode, city: $city, country: $country}, phoneNumber: $phoneNumber}) {
            ''' +
      _fragmentProfile +
      ''' 
          }
  } ''';

  final String _likePlace = r'''
  mutation($userId: ID!, $placeId: ID!) {
          likePlace(userId: $userId, placeId: $placeId) {
            ''' +
      _fragmentProfile +
      ''' 
          }
  }
''';

  Future<User> getCurrentUser() async {
    return getUser();
  }

  Future<User> getUser() async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .query(_queryOptions())
        .catchError((e) => {print('error caught')});
    return _toUser(result, "me");
  }

  Future<User> saveUser(User user) async {
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .mutate(_mutationOptions(user))
        .catchError((e) => {print('error caught')});
    return _toUser(result, "updateProfile");
  }

  Future<User> likePlace(Place place) async {
    User user = await getCurrentUser();
    GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .mutate(MutationOptions(
            documentNode: gql(_likePlace),
            variables: <String, dynamic>{
              'userId': user.id,
              'placeId': place.id,
            }))
        .catchError((e) => {print('error caught')});
    return _toUser(result, "likePlace");
  }

  MutationOptions _mutationOptions(User user) {
    MutationOptions options = MutationOptions(
      documentNode: gql(_queryProfile),
      variables: <String, dynamic>{
        'id': user.id,
        'lastName': user.name,
        'firstName': user.firstName,
        'email': user.email,
        'phoneNumber': user.phoneNumber
      },
    );
    return options;
  }

  QueryOptions _queryOptions() {
    QueryOptions options = QueryOptions(
      documentNode: gql(_queryMe),
    );
    return options;
  }

  User _toUser(QueryResult queryResult, String method) {
    if (queryResult.hasException) {
      print(queryResult.exception);
      throw FetchDataException('Impossible de lire les informations');
    }

    final list = queryResult.data[method] as Map<String, dynamic>;
    return User.fromJson(list);
  }
}
