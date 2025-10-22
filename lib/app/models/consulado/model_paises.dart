import 'package:mre_bolivia/app/models/consulado/model_consulados.dart';

class Pais {
  final String id;
  final String nombre;
  final String alpha2;
  final String alpha3;
  final String codigoPais;
  final String subRegion;
  final int codigoNumerico;
  final List<Consulado> consulados;

  Pais({
    required this.id,
    required this.nombre,
    required this.alpha2,
    required this.alpha3,
    required this.codigoPais,
    required this.subRegion,
    required this.codigoNumerico,
    required this.consulados,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      alpha2: json['alpha_2'] as String,
      alpha3: json['alpha_3'] as String,
      codigoPais: json['codigo_pais'] as String,
      subRegion: json['sub_region'] as String,
      codigoNumerico: json['codigo_numerico'] as int,
      consulados: (json['consulados'] as List<dynamic>)
          .map((e) => Consulado.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'alpha_2': alpha2,
      'alpha_3': alpha3,
      'codigo_pais': codigoPais,
      'sub_region': subRegion,
      'codigo_numerico': codigoNumerico,
      'consulados': consulados.map((e) => e.toJson()).toList(),
    };
  }
}

