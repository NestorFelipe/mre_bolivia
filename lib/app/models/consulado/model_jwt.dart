class JwtModel {
  final String uniqueName;
  final String ni;
  final String aceptoTerminos;
  final String idPersona;
  final String jti;
  final int exp;
  final String iss;
  final String aud;

  JwtModel({
    required this.uniqueName,
    required this.ni,
    required this.aceptoTerminos,
    required this.idPersona,
    required this.jti,
    required this.exp,
    required this.iss,
    required this.aud,
  });

  factory JwtModel.fromJson(Map<String, dynamic> json) {
    return JwtModel(
      uniqueName: json['unique_name'] as String,
      ni: json['NI'] as String,
      aceptoTerminos: json['AceptoTerminos'] as String,
      idPersona: json['IdPersona'] as String,
      jti: json['jti'] as String,
      exp: json['exp'] as int,
      iss: json['iss'] as String,
      aud: json['aud'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unique_name': uniqueName,
      'NI': ni,
      'AceptoTerminos': aceptoTerminos,
      'IdPersona': idPersona,
      'jti': jti,
      'exp': exp,
      'iss': iss,
      'aud': aud,
    };
  }
}
