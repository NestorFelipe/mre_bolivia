import 'package:mre_bolivia/app/models/consulado/model_detalle.dart';

class Intro {
  final int id;
  final String titulo;
  final String descripcion;
  final String? imagen;
  final int orden;
  final String tipo;
  final List<Detalle> detalle;

  Intro({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.imagen,
    required this.orden,
    required this.tipo,
    required this.detalle,
  });

  factory Intro.fromJson(Map<String, dynamic> json) {
    return Intro(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      imagen: json['imagen'] as String?,
      orden: json['orden'] as int,
      tipo: json['tipo'] as String,
      detalle: (json['detalle'] as List<dynamic>?)
              ?.map((e) => Detalle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'imagen': imagen,
      'orden': orden,
      'tipo': tipo,
      'detalle': detalle.map((e) => e.toJson()).toList(),
    };
  }
}

