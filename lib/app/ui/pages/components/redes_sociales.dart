import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mre_bolivia/app/data/data_file.dart';
import 'package:mre_bolivia/app/models/consulado/model_redes_sociales.dart';
import 'package:mre_bolivia/base/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class RedesSocialesWidget extends StatelessWidget {
  const RedesSocialesWidget({super.key});

  Future<void> _abrirRedSocial(
      String url, String nombre, BuildContext context) async {
    try {
      if (url.trim().isEmpty) {
        _mostrarError(context, 'URL no válida o vacía');
        return;
      }

      String finalUrl = url.trim();
      if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
        finalUrl = 'https://$finalUrl';
      }

      final Uri uri = Uri.parse(finalUrl);

      if (!uri.hasScheme || uri.host.isEmpty) {
        _mostrarError(context, 'URL no válida: $url');
        return;
      }

      // Intentar abrir en la app nativa primero, luego en navegador
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Si falla, intentar con el navegador
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );

        if (!launched) {
          // ignore: use_build_context_synchronously
          _mostrarError(context, 'No se puede abrir $nombre');
        }
      }
    } catch (e) {
      print('❌ Error al abrir $nombre: $e');
      // ignore: use_build_context_synchronously
      _mostrarError(context, 'Error al abrir $nombre');
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar solo redes sociales activas
    List<RedesSociales> redesActivas =
        DataFile.redesSociales.where((red) => red.isActive).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12.w,
        runSpacing: 12.h,
        children: redesActivas.map((redSocial) {
          return _buildRedSocialIcon(context, redSocial);
        }).toList(),
      ),
    );
  }

  Widget _buildRedSocialIcon(BuildContext context, RedesSociales redSocial) {
    return InkWell(
      onTap: () => _abrirRedSocial(redSocial.url, redSocial.nombre, context),
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 42.w,
        height: 42.w,
        child: SvgPicture.asset(
          "${Constant.assetImagePath}${redSocial.icono}",
          width: 42.w,
          height: 42.w,
          fit: BoxFit.contain,
          // No aplicar colorFilter para mantener los colores originales
          placeholderBuilder: (context) => Container(
            width: 42.w,
            height: 42.w,
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 24.w, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

// Widget legacy para mantener compatibilidad (si se usa en otro lugar)
Widget redSocialIcon(String assetPath, String url) {
  return Builder(
    builder: (context) {
      return InkWell(
        onTap: () async {
          try {
            if (url.trim().isEmpty) return;

            String finalUrl = url.trim();
            if (!finalUrl.startsWith('http://') &&
                !finalUrl.startsWith('https://')) {
              finalUrl = 'https://$finalUrl';
            }

            final Uri uri = Uri.parse(finalUrl);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (e) {
            print('Error al abrir enlace: $e');
          }
        },
        child: SvgPicture.asset(
          "${Constant.assetImagePath}$assetPath",
          width: 28.w,
          height: 28.w,
          fit: BoxFit.contain,
        ),
      );
    },
  );
}
