class PhotoUploadResponse {
  final String tiporespuesta;
  final String mensaje;
  final bool exitosa;
  final String codigo;

  PhotoUploadResponse({
    required this.tiporespuesta,
    required this.mensaje,
    required this.exitosa,
    required this.codigo,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      tiporespuesta: json['tiporespuesta'] as String? ?? '',
      mensaje: json['mensaje'] as String? ?? '',
      exitosa: json['exitosa'] as bool? ?? false,
      codigo: json['codigo'] as String? ?? '',
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
