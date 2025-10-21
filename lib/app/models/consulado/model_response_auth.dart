class ModelResponseAuth {
  final String? token;
  final DateTime? expiration;

  ModelResponseAuth({
    required this.token,
    required this.expiration,
  });

  factory ModelResponseAuth.fromJson(Map<String, dynamic> json) {
    return ModelResponseAuth(
      token: json['token'] as String,
      expiration: json['expiration'] != ""
          ? DateTime.parse(json['expiration'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiration': expiration == null ? "" : expiration?.toIso8601String(),
    };
  }
}
