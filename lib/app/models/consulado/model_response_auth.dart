class ModelResponseAuth {
  final String? token;
  final DateTime? expiration;
  final String? mensaje;
  final bool? isBlocked;

  ModelResponseAuth({
    required this.token,
    required this.expiration,
    this.mensaje,
    this.isBlocked = false,
  });

  factory ModelResponseAuth.fromJson(Map<String, dynamic> json) {
    return ModelResponseAuth(
      token: json['token'] as String?,
      expiration: json['expiration'] != ""
          ? DateTime.tryParse(json['expiration'] as String)
          : null,
      mensaje: json['mensaje'] as String?,
      isBlocked: json['isBlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiration': expiration == null ? "" : expiration?.toIso8601String(),
      'mensaje': mensaje,
      'isBlocked': isBlocked
    };
  }
}
