abstract class TokenProvider {
  Future<Map<String, String>> getAccessToken(
    bool forceRefresh,
    bool isGql,
    int? clientId,
  );
}
