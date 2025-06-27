class Endpoint {
  static final v1 = V1('/api');
}

class V1 {
  final String _baseUrl;
  V1(this._baseUrl);

  late final me = "$_baseUrl/v1/me";

  late final userLogout = "$_baseUrl/v1/auth/logout";
}
