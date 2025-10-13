class SeccionArancel {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? icono;

  SeccionArancel({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
  });

  factory SeccionArancel.fromJson(Map<String, dynamic> json) {
    return SeccionArancel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      icono: json['icono'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
    };
  }

  /// Obtener datos por defecto de las secciones de aranceles
  static List<SeccionArancel> obtenerSeccionesDefault() {
    return [
      SeccionArancel(
        id: 12,
        nombre: 'REGISTRO CIVIL',
        descripcion: 'Servicios de registro civil',
        icono: 'description',
      ),
      SeccionArancel(
        id: 13,
        nombre: 'ACTOS NOTARIALES',
        descripcion: 'Servicios notariales y certificaciones',
        icono: 'gavel',
      ),
      SeccionArancel(
        id: 14,
        nombre: 'TRADUCCIONES',
        descripcion: 'Servicios de traducción oficial',
        icono: 'translate',
      ),
      SeccionArancel(
        id: 15,
        nombre: 'PROTECCION CONSULAR',
        descripcion: 'Servicios de protección y asistencia consular',
        icono: 'security',
      ),
      SeccionArancel(
        id: 16,
        nombre: 'VISAS',
        descripcion: 'Servicios de visado y documentación migratoria',
        icono: 'card_travel',
      ),
      SeccionArancel(
        id: 17,
        nombre: 'TRAMITES GRATUITOS',
        descripcion: 'Servicios consulares sin costo',
        icono: 'money_off',
      ),
      SeccionArancel(
        id: 18,
        nombre: 'PASAPORTES',
        descripcion: 'Emisión y renovación de pasaportes',
        icono: 'book',
      ),
    ];
  }

  /// Obtener sección por ID
  static SeccionArancel? obtenerSeccionPorId(int id) {
    try {
      return obtenerSeccionesDefault()
          .firstWhere((seccion) => seccion.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Buscar secciones por nombre
  static List<SeccionArancel> buscarSeccionesPorNombre(String nombre) {
    if (nombre.isEmpty) return obtenerSeccionesDefault();

    final nombreBusqueda = nombre.toLowerCase();
    return obtenerSeccionesDefault()
        .where(
            (seccion) => seccion.nombre.toLowerCase().contains(nombreBusqueda))
        .toList();
  }

  @override
  String toString() {
    return 'SeccionArancel{id: $id, nombre: $nombre, descripcion: $descripcion, icono: $icono}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SeccionArancel &&
        other.id == id &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.icono == icono;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        descripcion.hashCode ^
        icono.hashCode;
  }
}
