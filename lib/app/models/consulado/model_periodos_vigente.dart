class ModelPeriodosVigente {
  final Paginado paginado;
  final List<Periodo> lista;
  final int tipoRespuesta;
  final String mensaje;
  final bool existosa;

  ModelPeriodosVigente({
    required this.paginado,
    required this.lista,
    required this.tipoRespuesta,
    required this.mensaje,
    required this.existosa,
  });

  factory ModelPeriodosVigente.fromJson(Map<String, dynamic> json) {
    return ModelPeriodosVigente(
      paginado: Paginado.fromJson(json['paginado']),
      lista: (json['lista'] as List).map((e) => Periodo.fromJson(e)).toList(),
      tipoRespuesta: json['tipoRespuesta'],
      mensaje: json['mensaje'],
      existosa: json['existosa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paginado': paginado.toJson(),
      'lista': lista.map((e) => e.toJson()).toList(),
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

class Periodo {
  int? id;
  String? descripcion;
  List<dynamic>? viVivencia;

  Periodo({
    this.id,
    this.descripcion,
    this.viVivencia,
  });

  factory Periodo.fromJson(Map<String, dynamic> json) {
    return Periodo(
      id: json['id'],
      descripcion: json['descripcion'],
      viVivencia: json['viVivencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'viVivencia': viVivencia,
    };
  }
}
