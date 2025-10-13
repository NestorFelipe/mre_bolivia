class TramiteVivenciasResponse {
  final TramiteVivencias objeto;
  final String tipoRespuesta;
  final String mensaje;
  final bool exitosa;

  TramiteVivenciasResponse({
    required this.objeto,
    required this.tipoRespuesta,
    required this.mensaje,
    required this.exitosa,
  });

  factory TramiteVivenciasResponse.fromJson(Map<String, dynamic> json) {
    return TramiteVivenciasResponse(
      objeto: TramiteVivencias.fromJson(json['objeto']),
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

class TramiteVivencias {
  final int id;
  final String contacto;
  final String descripcion;
  final String nombreCompleto;
  final String fechaLocal;
  final String fechaRegistro;
  final int gestionVivencia;
  final String periodo;
  final String estado;
  final String entidad;
  final List<Seguimiento> listaSeguimiento;

  TramiteVivencias({
    required this.id,
    required this.contacto,
    required this.descripcion,
    required this.nombreCompleto,
    required this.fechaLocal,
    required this.fechaRegistro,
    required this.gestionVivencia,
    required this.periodo,
    required this.estado,
    required this.entidad,
    required this.listaSeguimiento,
  });

  factory TramiteVivencias.fromJson(Map<String, dynamic> json) {
    return TramiteVivencias(
      id: json['id'],
      contacto: json['contacto'],
      descripcion: json['descripcion'],
      nombreCompleto: json['nombreCompleto'],
      fechaLocal: json['fechaLocal'],
      fechaRegistro: json['fechaRegistro'],
      gestionVivencia: json['gestionVivencia'],
      periodo: json['periodo'],
      estado: json['estado'],
      entidad: json['entidad'],
      listaSeguimiento: (json['listaSeguimiento'] as List)
          .map((e) => Seguimiento.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contacto': contacto,
      'descripcion': descripcion,
      'nombreCompleto': nombreCompleto,
      'fechaLocal': fechaLocal,
      'fechaRegistro': fechaRegistro,
      'gestionVivencia': gestionVivencia,
      'periodo': periodo,
      'estado': estado,
      'entidad': entidad,
      'listaSeguimiento': listaSeguimiento.map((e) => e.toJson()).toList(),
    };
  }
}

class Seguimiento {
  final int idEstado;
  final String estado;
  final String fecha;

  Seguimiento({
    required this.idEstado,
    required this.estado,
    required this.fecha,
  });

  factory Seguimiento.fromJson(Map<String, dynamic> json) {
    return Seguimiento(
      idEstado: json['idEstado'],
      estado: json['estado'],
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEstado': idEstado,
      'estado': estado,
      'fecha': fecha,
    };
  }
}
