class Detalle {
  final int id;
  final String titulo;
  final String? descripcion;
  final String? imagen;
  final int? orden;
  final String? tipo;

  Detalle({
    required this.id,
    required this.titulo,
    this.descripcion,
    this.imagen,
    this.orden,
    this.tipo,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) {
    return Detalle(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      imagen: json['imagen'] as String?,
      orden: json['orden'] as int?,
      tipo: json['tipo'] as String?,
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
    };
  }
}

