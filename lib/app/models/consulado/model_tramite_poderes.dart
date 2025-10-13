class TramitePoderesResponse {
  final TramitePoderes objeto;
  final String tipoRespuesta;
  final String mensaje;
  final bool exitosa;

  TramitePoderesResponse({
    required this.objeto,
    required this.tipoRespuesta,
    required this.mensaje,
    required this.exitosa,
  });

  factory TramitePoderesResponse.fromJson(Map<String, dynamic> json) {
    return TramitePoderesResponse(
      objeto: TramitePoderes.fromJson(json['objeto']),
      tipoRespuesta: json['tipoRespuesta'],
      mensaje: json['mensaje'],
      exitosa: json['exitosa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objeto': objeto.toJson(),
      'tipoRespuesta': tipoRespuesta,
      'mensaje': mensaje,
      'exitosa': exitosa,
    };
  }
}

class TramitePoderes {
  final int id;
  final String codTramite;
  final String oficinaConsular;
  final String descripcionArancel;
  final String nombreCompleto;
  final String fecha;
  final String estado;
  final List<Seguimiento> listaSeguimiento;

  TramitePoderes({
    required this.id,
    required this.codTramite,
    required this.oficinaConsular,
    required this.descripcionArancel,
    required this.nombreCompleto,
    required this.fecha,
    required this.estado,
    required this.listaSeguimiento,
  });

  factory TramitePoderes.fromJson(Map<String, dynamic> json) {
    return TramitePoderes(
      id: json['id'],
      codTramite: json['codTramite'],
      oficinaConsular: json['oficinaConsular'],
      descripcionArancel: json['descripcionArancel'],
      nombreCompleto: json['nombreCompleto'],
      fecha: json['fecha'],
      estado: json['estado'],
      listaSeguimiento: (json['listaSeguimiento'] as List)
          .map((e) => Seguimiento.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codTramite': codTramite,
      'oficinaConsular': oficinaConsular,
      'descripcionArancel': descripcionArancel,
      'nombreCompleto': nombreCompleto,
      'fecha': fecha,
      'estado': estado,
      'listaSeguimiento': listaSeguimiento.map((e) => e.toJson()).toList(),
    };
  }
}

class Seguimiento {
  final int id;
  final String estado;
  final String observacion;
  final String fecha;

  Seguimiento({
    required this.id,
    required this.estado,
    required this.observacion,
    required this.fecha,
  });

  factory Seguimiento.fromJson(Map<String, dynamic> json) {
    return Seguimiento(
      id: json['id'],
      estado: json['estado'],
      observacion: json['observacion'],
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estado': estado,
      'observacion': observacion,
      'fecha': fecha,
    };
  }
}
