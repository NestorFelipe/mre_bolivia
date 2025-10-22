import 'package:mre_bolivia/app/models/consulado/model_consulado_redes_sociales.dart';

class Consulado {
  final int id;
  final String nombre;
  final String tipo;
  final String direccion;
  final double? latitud;
  final double? longitud;
  final String horariosAtencion;
  final String telefono;
  final String telefonoEmergencia;
  final String correoElectronico;
  final String paginaWeb;
  final String circunscripcion;
  final List<RedSocial> consuladoRedesSociales;

  Consulado({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.direccion,
    this.latitud,
    this.longitud,
    required this.horariosAtencion,
    required this.telefono,
    required this.telefonoEmergencia,
    required this.correoElectronico,
    required this.paginaWeb,
    required this.circunscripcion,
    required this.consuladoRedesSociales,
  });

  factory Consulado.fromJson(Map<String, dynamic> json) {
    return Consulado(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      direccion: json['direccion'] as String,
      latitud: json['latitud'] as double?,
      longitud: json['longitud'] as double?,
      horariosAtencion: json['horarios_atencion'] as String,
      telefono: json['telefono'] as String,
      telefonoEmergencia: json['telefono_emergencia'] as String,
      correoElectronico: json['correo_electronico'] as String,
      paginaWeb: json['pagina_web'] as String,
      circunscripcion: json['circunscripcion'] as String,
      consuladoRedesSociales:
          (json['consulado_redes_sociales'] as List<dynamic>)
              .map((e) => RedSocial.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
      'horarios_atencion': horariosAtencion,
      'telefono': telefono,
      'telefono_emergencia': telefonoEmergencia,
      'correo_electronico': correoElectronico,
      'pagina_web': paginaWeb,
      'circunscripcion': circunscripcion,
      'consulado_redes_sociales':
          consuladoRedesSociales.map((e) => e.toJson()).toList(),
    };
  }
}

