class TramiteVisasResponse {
  final TramiteVisasObjeto objeto;
  final String tipoRespuesta;
  final String mensaje;
  final bool exitosa;

  TramiteVisasResponse({
    required this.objeto,
    required this.tipoRespuesta,
    required this.mensaje,
    required this.exitosa,
  });

  factory TramiteVisasResponse.fromJson(Map<String, dynamic> json) {
    return TramiteVisasResponse(
      objeto: TramiteVisasObjeto.fromJson(json['objeto']),
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

class TramiteVisasObjeto {
  final int id;
  final String codigo;
  final String personaNombre1;
  final String? personaApellido1;
  final String? personaApellido2;
  final String fecReg;
  final String grupo;
  final String estado;
  final String? observacion;
  final String aranceDescripcion;
  final String? nroDeposito;
  final String fechaDeposito;
  final double? montoDeposito;

  TramiteVisasObjeto({
    required this.id,
    required this.codigo,
    required this.personaNombre1,
    required this.personaApellido1,
    required this.personaApellido2,
    required this.fecReg,
    required this.grupo,
    required this.estado,
    required this.observacion,
    required this.aranceDescripcion,
    required this.nroDeposito,
    required this.fechaDeposito,
    required this.montoDeposito,
  });

  factory TramiteVisasObjeto.fromJson(Map<String, dynamic> json) {
    return TramiteVisasObjeto(
      id: json['id'],
      codigo: json['codigo'],
      personaNombre1: json['personaNombre1'],
      personaApellido1: json['personaApellido1'],
      personaApellido2: json['personaApellido2'],
      fecReg: json['fecReg'],
      grupo: json['grupo'],
      estado: json['estado'],
      observacion: json['observacion'],
      aranceDescripcion: json['aranceDescripcion'],
      nroDeposito: json['nroDeposito'],
      fechaDeposito: json['fechaDeposito'],
      montoDeposito: json['montoDeposito']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'personaNombre1': personaNombre1,
      'personaApellido1': personaApellido1,
      'personaApellido2': personaApellido2,
      'fecReg': fecReg,
      'grupo': grupo,
      'estado': estado,
      'observacion': observacion,
      'aranceDescripcion': aranceDescripcion,
      'nroDeposito': nroDeposito,
      'fechaDeposito': fechaDeposito,
      'montoDeposito': montoDeposito,
    };
  }
}
