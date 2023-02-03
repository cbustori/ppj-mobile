import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/enums/social_type.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/services/api_auth_service.dart';
import 'package:ppj/core/services/user_service.dart';
import 'package:ppj/locator.dart';

class UserRepository {
  final _storage = new FlutterSecureStorage();
  final _apiAuthService = locator<ApiAuthService>();
  final _userService = locator<UserService>();

  Future<String> authenticate({
    @required String email,
    @required String password,
  }) async {
    var token = await _apiAuthService.getToken(email, password);
    return token;
  }

  Future<String> authenticateSocial(
      {@required String tokenId, @required SocialType type}) async {
    var token = await _apiAuthService.getTokenSocial(type, tokenId);
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
    //await _storage.delete(key: 'id');
    await _storage.delete(key: 'expireDate');
    return;
  }

  Future<void> persistToken(String token, String id, int expireDate) async {
    await _storage.write(key: 'token', value: token);
    //await _storage.write(key: 'id', value: id);
    await _storage.write(key: 'expireDate', value: expireDate.toString());
    return;
  }

  Future<bool> hasToken() async {
    String token = await _storage.read(key: 'token');
    if (token != null) {
      String expireDate = await _storage.read(key: 'expireDate');
      int currentDate = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (expireDate != null && currentDate < int.parse(expireDate)) {
        return true;
      }
    }
    return false;
  }

  Future<User> getUser() async {
    User user = await _userService.getUser();
    return user;
  }
}
