class ModelGenericResponse {
  final String tiporespuesta;
  final String mensaje;
  final bool exitosa;
  final String codigo;

  ModelGenericResponse({
    required this.tiporespuesta,
    required this.mensaje,
    required this.exitosa,
    required this.codigo,
  });

  factory ModelGenericResponse.fromJson(Map<String, dynamic> json) {
    return ModelGenericResponse(
      tiporespuesta: json['tiporespuesta'] ?? '',
      mensaje: json['mensaje'] ?? '',
      exitosa: json['exitosa'] ?? false,
      codigo: json['codigo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tiporespuesta': tiporespuesta,
      'mensaje': mensaje,
      'exitosa': exitosa,
      'codigo': codigo,
    };
  }
}
