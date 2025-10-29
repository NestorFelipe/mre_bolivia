class ServiciosTramitesResponse {
  final List<ServicioTramite> data;
  final String typeMessage;
  final String message;

  ServiciosTramitesResponse({
    required this.data,
    required this.typeMessage,
    required this.message,
  });

  factory ServiciosTramitesResponse.fromJson(Map<String, dynamic> json) {
    return ServiciosTramitesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ServicioTramite.fromJson(e as Map<String, dynamic>))
          .toList(),
      typeMessage: json['typeMessage'] as String,
      message: json['message'] as String,
    );
  }
}

class ServicioTramite {
  final String id;
  final String nombre;
  final String? descripcion;
  final String entidadNombre;
  final String? entidadSigla;
  final String entidadCodigoPortal;
  final int precio;
  final String codigoPortal;
  final List<Monto> monto;
  final dynamic otros;
  final String url;

  ServicioTramite({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.entidadNombre,
    required this.entidadSigla,
    required this.entidadCodigoPortal,
    required this.precio,
    required this.codigoPortal,
    required this.monto,
    this.otros,
    required this.url,
  });

  factory ServicioTramite.fromJson(Map<String, dynamic> json) {
    return ServicioTramite(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      entidadNombre: json['entidad_nombre'] as String,
      entidadSigla: json['entidad_sigla'] as String?,
      entidadCodigoPortal: json['entidad_codigo_portal'] as String,
      precio: json['precio'] as int,
      codigoPortal: json['codigo_portal'] as String,
      monto: (json['monto'] as List<dynamic>)
          .map((e) => Monto.fromJson(e as Map<String, dynamic>))
          .toList(),
      otros: json['otros'],
      url: json['url'] as String,
    );
  }
}

class Monto {
  final int monto;
  final String cuenta;

  Monto({
    required this.monto,
    required this.cuenta,
  });

  factory Monto.fromJson(Map<String, dynamic> json) {
    return Monto(
      monto: json['monto'] as int,
      cuenta: json['cuenta'] as String,
    );
  }
}
