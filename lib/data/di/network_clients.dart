import 'package:flutter_core/domain/models/boot_load.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkClientInjector {
  @Named("debugBasicAuth")
  @lazySingleton
  String get debugBasicAuth => GetIt.I.get<BootLoad>().debugBasicAuth ?? '';

  @Named("debugJwt")
  @lazySingleton
  String get debugJwt => GetIt.I.get<BootLoad>().debugJwt ?? '';

/*  @lazySingleton
  RestApiClient get apiClient => RestApiClient.create(
    GetIt.I.get<TokenProvider>(),
    GetIt.I.get<UserInfo>(),
  );

  @lazySingleton
  GQLClient get defaultGqlClient => GQLClient.create(
    tokenProvider: GetIt.I.get<TokenProvider>(),
    userInfo: GetIt.I.get<UserInfo>(),
    endpoint: Endpoints.graphQLBaseEndpoint(),
  );*/
}
