class ArancelConsulado {
  final Paginado? paginado;
  final List<ItemConsulado>? lista;
  final String? tipoRespuesta;
  final String? mensaje;
  final bool? exitosa;

  ArancelConsulado({
    this.paginado,
    this.lista,
    this.tipoRespuesta,
    this.mensaje,
    this.exitosa,
  });

  factory ArancelConsulado.fromJson(Map<String, dynamic> json) {
    return ArancelConsulado(
      paginado:
          json['paginado'] != null ? Paginado.fromJson(json['paginado']) : null,
      lista: json['lista'] != null
          ? (json['lista'] as List)
              .map((item) => ItemConsulado.fromJson(item))
              .toList()
          : null,
      tipoRespuesta: json['tipoRespuesta'],
      mensaje: json['mensaje'],
      exitosa: json['exitosa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paginado': paginado?.toJson(),
      'lista': lista?.map((item) => item.toJson()).toList(),
      'tipoRespuesta': tipoRespuesta,
      'mensaje': mensaje,
      'exitosa': exitosa,
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

class ItemConsulado {
  final int? id;
  final String? ubicacion;
  final String? tipoMision;
  final String? nombre;
  final String? direccion;
  final bool? estaActiva;
  final double? latitudDD;
  final double? longitudDD;
  final String? ciudadNombre;
  final String? paisNombre;
  final String? paisNombreIso;
  final int? paisId;
  final String? correoElectronicoMision;
  final String? paginaWeb;
  final String? enlaceFacebook;
  final String? enlaceTwitter;
  final String? enlaceYoutube;
  final String? horarioAtencion;
  final String? telefonoOficina;
  final String? telefonoEmergencia;
  final String? telefonoWhatsapp;

  ItemConsulado({
    this.id,
    this.ubicacion,
    this.tipoMision,
    this.nombre,
    this.direccion,
    this.estaActiva,
    this.latitudDD,
    this.longitudDD,
    this.ciudadNombre,
    this.paisNombre,
    this.paisNombreIso,
    this.paisId,
    this.correoElectronicoMision,
    this.paginaWeb,
    this.enlaceFacebook,
    this.enlaceTwitter,
    this.enlaceYoutube,
    this.horarioAtencion,
    this.telefonoOficina,
    this.telefonoEmergencia,
    this.telefonoWhatsapp,
  });

  factory ItemConsulado.fromJson(Map<String, dynamic> json) {
    return ItemConsulado(
      id: json['id'],
      ubicacion: json['ubicacion'],
      tipoMision: json['tipoMision'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      estaActiva: json['estaActiva'],
      latitudDD: json['latitudDD']?.toDouble(),
      longitudDD: json['longitudDD']?.toDouble(),
      ciudadNombre: json['ciudadNombre'],
      paisNombre: json['paisNombre'],
      paisNombreIso: json['paisNombreIso'],
      paisId: json['paisId'],
      correoElectronicoMision: json['correoElectronicoMision'],
      paginaWeb: json['paginaWeb'],
      enlaceFacebook: json['enlaceFacebook'],
      enlaceTwitter: json['enlaceTwitter'],
      enlaceYoutube: json['enlaceYoutube'],
      horarioAtencion: json['horarioAtencion'],
      telefonoOficina: json['telefonoOficina'],
      telefonoEmergencia: json['telefonoEmergencia'],
      telefonoWhatsapp: json['telefonoWhatsapp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ubicacion': ubicacion,
      'tipoMision': tipoMision,
      'nombre': nombre,
      'direccion': direccion,
      'estaActiva': estaActiva,
      'latitudDD': latitudDD,
      'longitudDD': longitudDD,
      'ciudadNombre': ciudadNombre,
      'paisNombre': paisNombre,
      'paisNombreIso': paisNombreIso,
      'paisId': paisId,
      'correoElectronicoMision': correoElectronicoMision,
      'paginaWeb': paginaWeb,
      'enlaceFacebook': enlaceFacebook,
      'enlaceTwitter': enlaceTwitter,
      'enlaceYoutube': enlaceYoutube,
      'horarioAtencion': horarioAtencion,
      'telefonoOficina': telefonoOficina,
      'telefonoEmergencia': telefonoEmergencia,
      'telefonoWhatsapp': telefonoWhatsapp,
    };
  }
}
