class ModelArancelContactoSeccion {
  final Paginado? paginado;
  final List<Arancel>? lista;
  final int? tipoRespuesta;
  final String? mensaje;
  final bool? existosa;

  ModelArancelContactoSeccion({
    this.paginado,
    this.lista,
    this.tipoRespuesta,
    this.mensaje,
    this.existosa,
  });

  factory ModelArancelContactoSeccion.fromJson(Map<String, dynamic> json) {
    return ModelArancelContactoSeccion(
      paginado:
          json['paginado'] != null ? Paginado.fromJson(json['paginado']) : null,
      lista: json['lista'] != null
          ? (json['lista'] as List).map((e) => Arancel.fromJson(e)).toList()
          : null,
      tipoRespuesta: json['tipoRespuesta'],
      mensaje: json['mensaje'],
      existosa: json['existosa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paginado': paginado?.toJson(),
      'lista': lista?.map((e) => e.toJson()).toList(),
      'tipoRespuesta': tipoRespuesta,
      'mensaje': mensaje,
      'existosa': existosa,
    };
  }
}

class Paginado {
  final int? totalRegistros;
  final int? registrosPorPagina;
  final int? pagina;
  final int? totalPaginas;

  Paginado({
    this.totalRegistros,
    this.registrosPorPagina,
    this.pagina,
    this.totalPaginas,
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

class Arancel {
  final int? idArancel;
  final String? seccion;
  final String? codigoArancel;
  final String? descripcion;
  final num? tipoCambio;
  final num? costo;
  final num? costoML;
  final List<dynamic>? listaRequisito;

  Arancel({
    this.idArancel,
    this.seccion,
    this.codigoArancel,
    this.descripcion,
    this.tipoCambio,
    this.costo,
    this.costoML,
    this.listaRequisito,
  });

  factory Arancel.fromJson(Map<String, dynamic> json) {
    return Arancel(
      idArancel: json['idArancel'],
      seccion: json['seccion'],
      codigoArancel: json['codigoArancel'],
      descripcion: json['descripcion'],
      tipoCambio: json['tipoCambio'],
      costo: json['costo'],
      costoML: json['costoML'],
      listaRequisito: json['listaRequisito'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idArancel': idArancel,
      'seccion': seccion,
      'codigoArancel': codigoArancel,
      'descripcion': descripcion,
      'tipoCambio': tipoCambio,
      'costo': costo,
      'costoML': costoML,
      'listaRequisito': listaRequisito,
    };
  }
}
