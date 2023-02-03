import 'package:graphql_flutter/graphql_flutter.dart';
import '../../locator.dart';
import 'graphql_service.dart';

class TagService {
  GraphQLService _graphqlService = locator<GraphQLService>();
  final String _queryTagsByName = r'''
        query($name: String!) {
          tags(name: $name)
        }
''';

  Future<List<String>> getTags(String name) async {
    /* GraphQLClient _client = await _graphqlService.getGraphQLClient();
    QueryResult result = await _client
        .query(QueryOptions(
          documentNode: gql(_queryTagsByName),
          variables: <String, dynamic>{'name': name},
        ))
        .catchError((e) => {print('error caught')});
    return _toTag(result, 'tags'); */
    return new List();
  }

  List<String> _toTag(QueryResult queryResult, String method) {
    if (queryResult.hasException) {
      throw Exception();
    }

    final list = queryResult.data[method] as List<dynamic>;

    if (list != null) {
      return list.map((repoJson) => repoJson.toString()).toList();
    }
    return null;
  }
}
