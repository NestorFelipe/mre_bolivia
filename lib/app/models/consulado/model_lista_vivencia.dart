class ListaVivenciaResponse {
  final Paginado? paginado;
  final List<Vivencia>? lista;
  final int? tipoRespuesta;
  final String? mensaje;
  final bool? existosa;

  ListaVivenciaResponse({
    this.paginado,
    this.lista,
    this.tipoRespuesta,
    this.mensaje,
    this.existosa,
  });

  factory ListaVivenciaResponse.fromJson(Map<String, dynamic> json) {
    return ListaVivenciaResponse(
      paginado: Paginado.fromJson(json['paginado']),
      lista: (json['lista'] as List<dynamic>)
          .map((e) => Vivencia.fromJson(e as Map<String, dynamic>))
          .toList(),
      tipoRespuesta: json['tipoRespuesta'],
      mensaje: json['mensaje'],
      existosa: json['existosa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paginado': paginado!.toJson(),
      'lista': lista!.map((e) => e.toJson()).toList(),
      'tipoRespuesta': tipoRespuesta,
      'mensaje': mensaje,
      'existosa': existosa,
    };
  }
}

class Paginado {
  final int totalRegistros;
  final int registrosPorPagina;
  final int pagina;
  final int totalPaginas;

  Paginado({
    required this.totalRegistros,
    required this.registrosPorPagina,
    required this.pagina,
    required this.totalPaginas,
  });

  factory Paginado.fromJson(Map<String, dynamic> json) {
    return Paginado(
      totalRegistros: json['totalRegistros'],
      registrosPorPagina: json['registrosPorPagina'],
      pagina: json['pagina'],
      totalPaginas: json['totalPaginas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRegistros': totalRegistros,
      'registrosPorPagina': registrosPorPagina,
      'pagina': pagina,
      'totalPaginas': totalPaginas,
    };
  }
}

class Vivencia {
  final int id;
  final int codContacto;

  final String codTramite;

  final String descripcion;
  final int idPersona;
  final String nombreCompleto;

  final String fechaLocal;
  final String fechaRegistro;
  final int gestionVivencia;
  final int idPeriodo;
  final String periodo;
  final String apoderado;
  final String niApoderado;
  final String direccionApoderado;
  final String departamentoApoderado;
  final String tipoResidencia;
  final int idTipoResidencia;

  final int idTipoRenta;
  final int idEstado;
  final String estado;

  final String entidad;

  Vivencia({
    required this.id,
    required this.codContacto,
    required this.codTramite,
    required this.descripcion,
    required this.idPersona,
    required this.nombreCompleto,
    required this.fechaLocal,
    required this.fechaRegistro,
    required this.gestionVivencia,
    required this.idPeriodo,
    required this.periodo,
    required this.apoderado,
    required this.niApoderado,
    required this.direccionApoderado,
    required this.departamentoApoderado,
    required this.tipoResidencia,
    required this.idTipoResidencia,
    required this.idTipoRenta,
    required this.idEstado,
    required this.estado,
    required this.entidad,
  });

  factory Vivencia.fromJson(Map<String, dynamic> json) {
    return Vivencia(
      id: json['id'],
      codContacto: json['codContacto'],
      codTramite: json['codTramite'],
      descripcion: json['descripcion'],
      idPersona: json['idPersona'],
      nombreCompleto: json['nombreCompleto'],
      fechaLocal: json['fechaLocal'],
      fechaRegistro: json['fechaRegistro'],
      gestionVivencia: json['gestionVivencia'],
      idPeriodo: json['idPeriodo'],
      periodo: json['periodo'],
      apoderado: json['apoderado'],
      niApoderado: json['niApoderado'],
      direccionApoderado: json['direccionApoderado'],
      departamentoApoderado: json['departamentoApoderado'],
      tipoResidencia: json['tipoResidencia'],
      idTipoResidencia: json['idTipoResidencia'],
      idTipoRenta: json['idTipoRenta'],
      idEstado: json['idEstado'],
      estado: json['estado'],
      entidad: json['entidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codContacto': codContacto,
      'codTramite': codTramite,
      'descripcion': descripcion,
      'idPersona': idPersona,
      'nombreCompleto': nombreCompleto,
      'fechaLocal': fechaLocal,
      'fechaRegistro': fechaRegistro,
      'gestionVivencia': gestionVivencia,
      'idPeriodo': idPeriodo,
      'periodo': periodo,
      'apoderado': apoderado,
      'niApoderado': niApoderado,
      'direccionApoderado': direccionApoderado,
      'departamentoApoderado': departamentoApoderado,
      'tipoResidencia': tipoResidencia,
      'idTipoResidencia': idTipoResidencia,
      'idTipoRenta': idTipoRenta,
      'idEstado': idEstado,
      'estado': estado,
      'entidad': entidad,
    };
  }
}
