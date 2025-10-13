class TramiteAsistenciaConsularResponse {
  final TramiteAsistenciaConsular? objeto;
  final String tipoRespuesta;
  final String mensaje;
  final bool exitosa;

  TramiteAsistenciaConsularResponse({
    this.objeto,
    required this.tipoRespuesta,
    required this.mensaje,
    required this.exitosa,
  });

  factory TramiteAsistenciaConsularResponse.fromJson(
      Map<String, dynamic> json) {
    return TramiteAsistenciaConsularResponse(
      objeto: json['objeto'] != null
          ? TramiteAsistenciaConsular.fromJson(json['objeto'])
          : null,
      tipoRespuesta: json['tipoRespuesta'] ?? '',
      mensaje: json['mensaje'] ?? '',
      exitosa: json['exitosa'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objeto': objeto?.toJson(),
      'tipoRespuesta': tipoRespuesta,
      'mensaje': mensaje,
      'exitosa': exitosa,
    };
  }
}

class TramiteAsistenciaConsular {
  final int id;
  final String fecha;
  final String uniOrganizacional;
  final String tipoAsistenciaNombre;
  final String codAsistencia;
  final String pais;
  final Afectado afectado;

  TramiteAsistenciaConsular({
    required this.id,
    required this.fecha,
    required this.uniOrganizacional,
    required this.tipoAsistenciaNombre,
    required this.codAsistencia,
    required this.pais,
    required this.afectado,
  });

  factory TramiteAsistenciaConsular.fromJson(Map<String, dynamic> json) {
    return TramiteAsistenciaConsular(
      id: json['id'] ?? 0,
      fecha: json['fecha'] ?? '',
      uniOrganizacional: json['uniOrganizacional'] ?? '',
      tipoAsistenciaNombre: json['tipoAsistenciaNombre'] ?? '',
      codAsistencia: json['codAsistencia'] ?? '',
      pais: json['pais'] ?? '',
      afectado: Afectado.fromJson(json['afectado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'uniOrganizacional': uniOrganizacional,
      'tipoAsistenciaNombre': tipoAsistenciaNombre,
      'codAsistencia': codAsistencia,
      'pais': pais,
      'afectado': afectado.toJson(),
    };
  }
}

class Afectado {
  final int id;
  final String nombre;
  final String apellido;
  final String numDocumento;

  Afectado({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numDocumento,
  });

  factory Afectado.fromJson(Map<String, dynamic> json) {
    return Afectado(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      numDocumento: json['numDocumento'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'numDocumento': numDocumento,
    };
  }
}
