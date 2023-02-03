import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ppj/core/exceptions/app_exception.dart';

class GraphQLService {
  final _baseUrl = 'https://dev.plaplajour.fr/graphql';
 // final _baseUrl = 'http://192.168.1.27:40027/graphql';
  FlutterSecureStorage _storage;

  GraphQLService() {
    _storage = new FlutterSecureStorage();
  }

  Future<String> _getToken() async {
    String token = await _storage.read(key: 'token');
    return token;
  }

  Future<GraphQLClient> getGraphQLClient() async {
    String token = await _getToken();
    final HttpLink httpLink = HttpLink(
      uri: _baseUrl,
    );

    Link _link = httpLink;
    if (token != null) {
      final AuthLink authLink = AuthLink(
        getToken: () async => 'Bearer ' + token,
      );
      _link = authLink.concat(httpLink);
    }

    return GraphQLClient(
      link: _link,
      cache: InMemoryCache(),
    );
  }

  Future<dynamic> post(QueryOptions options, String method) async {
    var result;
    try {
      GraphQLClient client = await getGraphQLClient();
      result = await client.query(options);
      result = _returnResponse(result, method);
    } on Exception {
      throw FetchDataException('No Internet connection');
    }
    return result;
  }

  dynamic _returnResponse(QueryResult result, String method) {
    if (result.hasException) {
      if (result.exception.clientException is NetworkException) {
        throw new NetworkAccessException(
            '${result.exception.clientException.message}');
      }
      throw FetchDataException(
          'Error occured while Communication with Server : ${result.exception.graphqlErrors.first.message}');
    }
    return result.data[method] as List<dynamic>;
  }
}
