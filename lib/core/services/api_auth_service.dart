import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ppj/core/enums/social_type.dart';
import 'package:ppj/core/enums/user_type.dart';

class ApiAuthService {
  static const localEndpoint = 'https://dev.plaplajour.fr/auth/login';
  static const socialEndpoint = 'https://dev.plaplajour.fr/auth/social/login';

  var client = new http.Client();

  Future<String> getToken(String email, String password) async {
    var response = await client.post('$localEndpoint',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({"email": email, "password": password}));

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body)['accessToken'];
    }
    return null;
  }

  Future<String> getTokenSocial(SocialType type, String tokenId) async {
    var response = await client.post('$socialEndpoint',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({
          "socialType": SocialTypeHelper.getValueToString(type),
          "tokenId": tokenId,
          "type": UserTypeHelper.getValueToString(UserType.SUBSCRIBER)
        }));

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body)['accessToken'];
    }
    return null;
  }
}
