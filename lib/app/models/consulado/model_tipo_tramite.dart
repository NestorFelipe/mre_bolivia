class TipoTramite {
  final String id;
  final String tramite;

  TipoTramite({
    required this.id,
    required this.tramite,
  });

  factory TipoTramite.fromJson(Map<String, dynamic> json) {
    return TipoTramite(
      id: json['id'] as String,
      tramite: json['tramite'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tramite': tramite,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TipoTramite && other.id == id && other.tramite == tramite;
  }

  @override
  int get hashCode => id.hashCode ^ tramite.hashCode;
}

class TipoTramiteResponse {
  final List<TipoTramite> data;
  final String typeMessage;
  final String message;

  TipoTramiteResponse({
    required this.data,
    required this.typeMessage,
    required this.message,
  });

  factory TipoTramiteResponse.fromJson(Map<String, dynamic> json) {
    return TipoTramiteResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TipoTramite.fromJson(e as Map<String, dynamic>))
          .toList(),
      typeMessage: json['typeMessage'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'typeMessage': typeMessage,
      'message': message,
    };
  }
}
