import 'package:mre_bolivia/app/models/consulado/model_paises.dart';

class RegionesResponse {
  final List<Region> regiones;

  RegionesResponse({
    required this.regiones,
  });

  factory RegionesResponse.fromJson(Map<String, dynamic> json) {
    return RegionesResponse(
      regiones: (json['regiones'] as List<dynamic>)
          .map((e) => Region.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regiones': regiones.map((e) => e.toJson()).toList(),
    };
  }
}

class Region {
  final String id;
  final String nombre;
  final String codigo;
  final List<Pais> paises;

  Region({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.paises,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      paises: (json['paises'] as List<dynamic>)
          .map((e) => Pais.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'paises': paises.map((e) => e.toJson()).toList(),
    };
  }
}

