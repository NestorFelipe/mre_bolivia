class ModelVivenciaSave {
  final int? idperiodo;
  final int? idresidencia;
  final String? apoderado;
  final String? niapoderado;
  final String? dptoapoderado;
  final String? direccionapoderado;
  final int? iddepartamental;

  ModelVivenciaSave({
    this.idperiodo,
    this.idresidencia,
    this.apoderado,
    this.niapoderado,
    this.dptoapoderado,
    this.direccionapoderado,
    this.iddepartamental,
  });

  Map<String, dynamic> toJson() => {
        'idperiodo': idperiodo,
        'idresidencia': idresidencia,
        'apoderado': apoderado,
        'niapoderado': niapoderado,
        'dptoapoderado': dptoapoderado,
        'direccionapoderado': direccionapoderado,
        'iddepartamental': iddepartamental,
      };
}
