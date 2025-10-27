import 'package:mre_bolivia/app/models/consulado/model_ciudad.dart';
import 'package:mre_bolivia/app/models/consulado/model_departamento.dart';
import 'package:mre_bolivia/app/models/consulado/model_residencia.dart';

class DataFile {
  static List<Residencia> residencia = [
    Residencia(
      idresidencia: 1,
      descripcion: "Temporal",
    ),
    Residencia(
      idresidencia: 2,
      descripcion: "Permanente",
    ),
  ];

  static List<Departamento> departamento = [
    Departamento(
      iddepartamento: 1,
      descripcion: "La Paz",
    ),
    Departamento(
      iddepartamento: 2,
      descripcion: "Oruro",
    ),
    Departamento(
      iddepartamento: 3,
      descripcion: "Cochabamba",
    ),
    Departamento(
      iddepartamento: 4,
      descripcion: "Santa Cruz",
    ),
    Departamento(
      iddepartamento: 5,
      descripcion: "Potosi",
    ),
    Departamento(
      iddepartamento: 6,
      descripcion: "Beni",
    ),
    Departamento(
      iddepartamento: 7,
      descripcion: "Tarija",
    ),
    Departamento(
      iddepartamento: 8,
      descripcion: "Chuquisaca",
    ),
    Departamento(
      iddepartamento: 9,
      descripcion: "Pando",
    ),
  ];

  static List<Ciudad> ciudad = [
    Ciudad(
      idciudad: 5905,
      descripcion: "La Paz",
    ),
    Ciudad(
      idciudad: 5138,
      descripcion: "Cochabamba",
    ),
    Ciudad(
      idciudad: 5902,
      descripcion: "Santa Cruz",
    ),
  ];
}
