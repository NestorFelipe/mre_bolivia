class TramitePassaportesResponse {
  final TramitePassaportes objeto;
  final String tipoRespuesta;
  final String mensaje;
  final bool exitosa;

  TramitePassaportesResponse({
    required this.objeto,
    required this.tipoRespuesta,
    required this.mensaje,
    required this.exitosa,
  });

  factory TramitePassaportesResponse.fromJson(Map<String, dynamic> json) {
    return TramitePassaportesResponse(
      objeto: TramitePassaportes.fromJson(json['objeto']),
      tipoRespuesta: json['tipoRespuesta'] ?? '',
      mensaje: json['mensaje'] ?? '',
      exitosa: json['exitosa'] ?? false,
    );
  }
}

class TramitePassaportes {
  final List<Seguimiento> listaSeguimiento;
  final int id;
  final int idSolicitante;
  final String nombre;
  final String paterno;
  final String materno;
  final String email;
  final String estado;
  final String codSolicitud;
  final String fechaReg;
  final int gestion;
  final int mes;

  TramitePassaportes({
    required this.listaSeguimiento,
    required this.id,
    required this.idSolicitante,
    required this.nombre,
    required this.paterno,
    required this.materno,
    required this.email,
    required this.estado,
    required this.codSolicitud,
    required this.fechaReg,
    required this.gestion,
    required this.mes,
  });

  factory TramitePassaportes.fromJson(Map<String, dynamic> json) {
    return TramitePassaportes(
      listaSeguimiento: (json['listaSeguimiento'] as List<dynamic>?)
              ?.map((e) => Seguimiento.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      id: json['id'] ?? 0,
      idSolicitante: json['idSolicitante'] ?? 0,
      nombre: json['nombre'] ?? '',
      paterno: json['paterno'] ?? '',
      materno: json['materno'] ?? '',
      email: json['email'] ?? '',
      estado: json['estado'] ?? '',
      codSolicitud: json['codSolicitud'] ?? '',
      fechaReg: json['fechaReg'] ?? '',
      gestion: json['gestion'] ?? 0,
      mes: json['mes'] ?? 0,
    );
  }
}

class Seguimiento {
  final int id;
  final String fechareg;
  final String estado;
  final String observacion;
  final int diasTranscurridos;

  Seguimiento({
    required this.id,
    required this.fechareg,
    required this.estado,
    required this.observacion,
    required this.diasTranscurridos,
  });

  factory Seguimiento.fromJson(Map<String, dynamic> json) {
    return Seguimiento(
      id: json['id'] ?? 0,
      fechareg: json['fechareg'] ?? '',
      estado: json['estado'] ?? '',
      observacion: json['observacion'] ?? '',
      diasTranscurridos: json['diasTranscurridos'] ?? 0,
    );
  }
}
