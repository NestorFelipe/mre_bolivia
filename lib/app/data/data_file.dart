import 'package:mre_bolivia/app/models/consulado/model_ciudad.dart';
import 'package:mre_bolivia/app/models/consulado/model_departamento.dart';
import 'package:mre_bolivia/app/models/consulado/model_redes_sociales.dart';
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

  static List<RedesSociales> redesSociales = [
    RedesSociales(
        icono: "facebook.svg",
        id: 1,
        nombre: "FaceBook",
        url: "https://www.facebook.com/CancilleriaBolivia",
        isActive: true),
    RedesSociales(
        icono: "twitter.svg",
        id: 2,
        nombre: "X-Twitter",
        url: "https://x.com/MRE_Bolivia",
        isActive: true),
    RedesSociales(
        icono: "tiktoker.svg",
        id: 3,
        nombre: "TikTok",
        url: "https://www.tiktok.com/@cancilleriabolivia",
        isActive: true),
    RedesSociales(
        icono: "youtube.svg",
        id: 4,
        nombre: "YouTube",
        url: "https://www.youtube.com/@prensarree",
        isActive: true),
    RedesSociales(
        icono: "instagram_fixed.svg",
        id: 5,
        nombre: "Instagram",
        url:
            "https://www.instagram.com/cancilleriabolivia/?igshid=MmJiY2I4NDBkZg%3D%3D",
        isActive: true),
    RedesSociales(
        icono: "whatsapp.svg",
        id: 6,
        nombre: "WhatsApp",
        url:
            "https://api.whatsapp.com/send?phone=https://whatsapp.com/channel/0029VacUT241CYoPyObiYU0S",
        isActive: false),
  ];
}
