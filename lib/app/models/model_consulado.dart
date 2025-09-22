class ModelConsulado {
  final List<ModelDefinicion> definiciones;
  final List<ModelAsistencia> asistencia;
  final List<ModelViaje> viajes;
  final List<ModelEntidad> entidad;
  final Map<String, dynamic> tramites;
  final List<ModelTramiteTipo> tramitesTipos;
  final Map<String, dynamic> consulados;
  final List<ModelPais> pais;
  final Map<String, List<ModelPais>> paisRegion;

  ModelConsulado({
    required this.definiciones,
    required this.asistencia,
    required this.viajes,
    required this.entidad,
    required this.tramites,
    required this.tramitesTipos,
    required this.consulados,
    required this.pais,
    required this.paisRegion,
  });

  factory ModelConsulado.fromJson(Map<String, dynamic> json) {
    return ModelConsulado(
      definiciones: (json['definiciones'] as List?)
          ?.map((x) => ModelDefinicion.fromJson(x))
          .toList() ?? [],
      asistencia: (json['asistencia'] as List?)
          ?.map((x) => ModelAsistencia.fromJson(x))
          .toList() ?? [],
      viajes: (json['viajes'] as List?)
          ?.map((x) => ModelViaje.fromJson(x))
          .toList() ?? [],
      entidad: (json['entidad'] as List?)
          ?.map((x) => ModelEntidad.fromJson(x))
          .toList() ?? [],
      tramites: json['tramites'] ?? {},
      tramitesTipos: (json['tramitesTipos'] as List?)
          ?.map((x) => ModelTramiteTipo.fromJson(x))
          .toList() ?? [],
      consulados: json['consulados'] ?? {},
      pais: (json['pais'] as List?)
          ?.map((x) => ModelPais.fromJson(x))
          .toList() ?? [],
      paisRegion: Map<String, List<ModelPais>>.from(
        (json['paisRegion'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            key,
            (value as List?)?.map((x) => ModelPais.fromJson(x)).toList() ?? [],
          ),
        ),
      ),
    );
  }
}

class ModelDefinicion {
  String? funcionId;
  String? tipo;
  String? titulo;
  String? valor;
  String? image;
  String? orderf;
  String? link;

  ModelDefinicion({
    this.funcionId,
    this.tipo,
    this.titulo,
    this.valor,
    this.image,
    this.orderf,
    this.link,
  });

  factory ModelDefinicion.fromJson(Map<String, dynamic> json) {
    return ModelDefinicion(
      funcionId: json['funcion_id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      valor: json['valor'],
      image: json['image'],
      orderf: json['orderf'],
      link: json['link'],
    );
  }
}

class ModelAsistencia {
  String? funcionId;
  String? tipo;
  String? titulo;
  String? valor;
  String? image;
  String? orderf;
  String? link;

  ModelAsistencia({
    this.funcionId,
    this.tipo,
    this.titulo,
    this.valor,
    this.image,
    this.orderf,
    this.link,
  });

  factory ModelAsistencia.fromJson(Map<String, dynamic> json) {
    return ModelAsistencia(
      funcionId: json['funcion_id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      valor: json['valor'],
      image: json['image'],
      orderf: json['orderf'],
      link: json['link'],
    );
  }
}

class ModelViaje {
  String? funcionId;
  String? tipo;
  String? titulo;
  String? valor;
  String? image;
  String? orderf;
  String? link;

  ModelViaje({
    this.funcionId,
    this.tipo,
    this.titulo,
    this.valor,
    this.image,
    this.orderf,
    this.link,
  });

  factory ModelViaje.fromJson(Map<String, dynamic> json) {
    return ModelViaje(
      funcionId: json['funcion_id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      valor: json['valor'],
      image: json['image'],
      orderf: json['orderf'],
      link: json['link'],
    );
  }
}

class ModelEntidad {
  String? entidadId;
  String? nombre;
  String? descripcion;
  String? oficinaConsular;
  String? logo;
  String? link;
  String? direccion;
  String? telefono;
  String? countryCode;
  String? ciudad;
  String? nombreConsulado;

  ModelEntidad({
    this.entidadId,
    this.nombre,
    this.descripcion,
    this.oficinaConsular,
    this.logo,
    this.link,
    this.direccion,
    this.telefono,
    this.countryCode,
    this.ciudad,
    this.nombreConsulado,
  });

  factory ModelEntidad.fromJson(Map<String, dynamic> json) {
    return ModelEntidad(
      entidadId: json['entidad_id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      oficinaConsular: json['oficina_consular'],
      logo: json['logo'],
      link: json['link'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      countryCode: json['country_code'],
      ciudad: json['ciudad'],
      nombreConsulado: json['nombreConsulado'],
    );
  }
}

class ModelTramiteTipo {
  String? codTipoArray;
  String? nombre;

  ModelTramiteTipo({
    this.codTipoArray,
    this.nombre,
  });

  factory ModelTramiteTipo.fromJson(Map<String, dynamic> json) {
    return ModelTramiteTipo(
      codTipoArray: json['codTipoArray'],
      nombre: json['nombre'],
    );
  }
}

class ModelPais {
  String? paisId;
  String? name;
  String? alpha2;
  String? alpha3;
  String? countryCode;
  String? region;
  String? subRegion;
  String? regionCode;
  String? subRegionCode;
  int? intCodigo;

  ModelPais({
    this.paisId,
    this.name,
    this.alpha2,
    this.alpha3,
    this.countryCode,
    this.region,
    this.subRegion,
    this.regionCode,
    this.subRegionCode,
    this.intCodigo,
  });

  factory ModelPais.fromJson(Map<String, dynamic> json) {
    return ModelPais(
      paisId: json['pais_id'],
      name: json['name'],
      alpha2: json['alpha_2'],
      alpha3: json['alpha_3'],
      countryCode: json['country_code'],
      region: json['region'],
      subRegion: json['sub_region'],
      regionCode: json['region_code'],
      subRegionCode: json['sub_region_code'],
      intCodigo: int.tryParse(json['intCodigo']?.toString() ?? '0'),
    );
  }
}