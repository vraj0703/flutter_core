import 'package:graphql_flutter/graphql_flutter.dart';

abstract class GQLClient {
  Future<Map<String, dynamic>> query(QueryOptions<Query> query);

  Future<Map<String, dynamic>?> mutation(MutationOptions<Mutation> mutation);
}
