import 'package:get_it/get_it.dart';
import 'package:ppj/core/services/graphql_service.dart';
import 'package:ppj/core/services/token_service.dart';
import 'core/blocs/deep_link.dart';
import 'core/services/api_auth_service.dart';
import 'core/services/event_service.dart';
import 'core/services/location_service.dart';
import 'core/services/tag_service.dart';
import 'core/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => ApiAuthService());
  locator.registerLazySingleton(() => GraphQLService());
  locator.registerLazySingleton(() => EventService());
  locator.registerLazySingleton(() => TagService());
  locator.registerLazySingleton(() => TokenService());

  locator.registerFactory(() => DeepLinkBloc());
}
