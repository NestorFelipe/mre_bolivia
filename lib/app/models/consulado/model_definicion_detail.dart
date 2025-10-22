import 'package:mre_bolivia/app/models/consulado/model_intro.dart';
import 'package:mre_bolivia/app/models/consulado/model_servicio.dart';

class ModelDefinicionDetail {
  final List<Intro> intros;
  final List<Servicio> servicios;

  ModelDefinicionDetail({
    required this.intros,
    required this.servicios,
  });

  factory ModelDefinicionDetail.fromJson(Map<String, dynamic> json) {
    return ModelDefinicionDetail(
      intros: (json['intros'] as List<dynamic>?)
              ?.map((e) => Intro.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      servicios: (json['servicios'] as List<dynamic>?)
              ?.map((e) => Servicio.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intros': intros.map((e) => e.toJson()).toList(),
      'servicios': servicios.map((e) => e.toJson()).toList(),
    };
  }
}

