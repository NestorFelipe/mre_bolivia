class RedesSociales {
  final int id;
  final String url;
  final String nombre;
  final String icono;
  final bool isActive;

  RedesSociales({
    required this.id,
    required this.url,
    required this.nombre,
    required this.icono,
    this.isActive = true,
  });
}
