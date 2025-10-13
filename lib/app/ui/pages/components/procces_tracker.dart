import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mi_cancilleria/app/models/consulado/model_tipo_tramite.dart';
import 'package:mi_cancilleria/app/ui/pages/components/tramite_asistenciaconsular.dart';
import 'package:mi_cancilleria/app/ui/pages/components/tramite_passaportes.dart';
import 'package:mi_cancilleria/app/ui/pages/components/tramite_poderes.dart';
import 'package:mi_cancilleria/app/ui/pages/components/tramite_visas.dart';
import 'package:mi_cancilleria/app/ui/pages/components/tramite_vivencias.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:mi_cancilleria/base/utils/utils.dart';
import 'package:mi_cancilleria/controllers/consulado/seguimiento_tramite_controller.dart';

Widget processTracker(
    BuildContext context, SeguimientoTramiteController controller) {
  return Obx(() {
    final processTrackerNum = controller.processTrackerNum.value;

    if (processTrackerNum == 2) {
      return Container();
    }

    return Row(
      children: [
        Container(
          height: 52.h,
          width: 52.h,
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
              color: procced, borderRadius: BorderRadius.circular(52.h)),
          child: getSvgImage("select.svg", height: 64.h, width: 64.w),
        ),
        Expanded(
          child: DottedLine(
            dashColor:
                processTrackerNum < 1 ? const Color(0xFFBEC4D3) : blueColor,
            lineThickness: 1.h,
          ),
        ),
        Container(
          height: 52.h,
          width: 52.h,
          padding: EdgeInsets.all(10.h),
          decoration: processTrackerNum < 1
              ? BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
                  borderRadius: BorderRadius.circular(50.h))
              : BoxDecoration(
                  color: procced, borderRadius: BorderRadius.circular(52.h)),
          child: getSvgImage("input.svg",
              color:
                  processTrackerNum < 1 ? const Color(0xFFBEC4D3) : blueColor),
        ),
        Expanded(
          child: DottedLine(
            dashColor:
                processTrackerNum < 2 ? const Color(0xFFBEC4D3) : blueColor,
            lineThickness: 1.h,
          ),
        ),
        Container(
          height: 52.h,
          width: 52.h,
          padding: EdgeInsets.all(10.h),
          decoration: processTrackerNum < 2
              ? BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
                  borderRadius: BorderRadius.circular(50.h))
              : BoxDecoration(
                  color: procced, borderRadius: BorderRadius.circular(52.h)),
          child: getSvgImage("tramite.svg",
              color:
                  processTrackerNum < 2 ? const Color(0xFFBEC4D3) : blueColor),
        ),
      ],
    );
  });
}

Widget mensajeProceso(
    BuildContext context, SeguimientoTramiteController controller) {
  return Obx(() {
    final processTrackerNum = controller.processTrackerNum.value;
    final TipoTramite? selectedTipo = controller.selectedTipo.value;
    final codigoTramite = controller.codigoTramite.value;

    return processTrackerNum == 2
        ? Container()
        : Column(
            children: [
              if (processTrackerNum == 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: getCustomFont(
                    "Tipo Trámite (${selectedTipo?.tramite ?? ''})",
                    20,
                    blueColor,
                    1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 241, 241),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: getCustomFont(
                    processTrackerNum == 0
                        ? "Seleccione el tipo de trámite que desea consultar, y luego presione Siguiente."
                        : processTrackerNum == 1
                            ? "Ingrese el código único de trámite correspondiente a ${selectedTipo?.tramite ?? ''} y luego presione Buscar."
                            : "Tipo Trámite: ${selectedTipo?.tramite ?? ''}\nCódigo Trámite: $codigoTramite",
                    18,
                    const Color.fromARGB(255, 30, 28, 115),
                    4,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          );
  });
}

Widget confirmButton(
    BuildContext context, SeguimientoTramiteController controller) {
  return Obx(() {
    final isEnabled = controller.selectedTipo.value != null;
    final processTrackerNum = controller.processTrackerNum.value;
    final isEnableBuscar = controller.codigoTramite.value.isNotEmpty;
    final isfinishSearch = controller.isfinishSearch.value;

    if (processTrackerNum == 0) {
      // Solo botón "Continuar"
      return Container(
        color: backGroundColor,
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled ? () => controller.avanzarProceso() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? blueColor : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: isEnabled ? 2 : 0,
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.white70,
            ),
            child: Text(
              "Siguiente",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      );
    } else {
      // Dos botones: "Atrás" y "Siguiente" o "Buscar"
      // En processTrackerNum == 2, los botones se deshabilitan hasta que isfinishSearch sea true
      final bool enableButtons =
          processTrackerNum == 1 || (processTrackerNum == 2 && isfinishSearch);

      return Container(
        color: backGroundColor,
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: enableButtons
                      ? () => controller.retrocederProceso()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        enableButtons ? Colors.grey[300] : Colors.grey,
                    foregroundColor: enableButtons
                        ? const Color.fromARGB(255, 20, 53, 125)
                        : Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: enableButtons ? 2 : 0,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white70,
                  ),
                  child: Text(
                    "Atrás",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: enableButtons
                          ? const Color.fromARGB(255, 20, 53, 125)
                          : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: isEnableBuscar && processTrackerNum == 1
                      ? () => controller.avanzarProceso()
                      : enableButtons && processTrackerNum == 2
                          ? () => controller.reiniciarProceso()
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (isEnableBuscar && processTrackerNum == 1) ||
                                (enableButtons && processTrackerNum == 2)
                            ? blueColor
                            : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: (isEnableBuscar && processTrackerNum == 1) ||
                            (enableButtons && processTrackerNum == 2)
                        ? 2
                        : 0,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white70,
                  ),
                  child: Text(
                    processTrackerNum == 1 ? "Buscar" : "Reiniciar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: (isEnableBuscar && processTrackerNum == 1) ||
                              (enableButtons && processTrackerNum == 2)
                          ? Colors.white
                          : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  });
}

Widget listaTramites(
    BuildContext context, SeguimientoTramiteController controller) {
  return Expanded(
    child: Obx(() {
      if (controller.tiposTramite.isEmpty) {
        return const Center(
          child: Text('No hay tipos de trámite disponibles.'),
        );
      }
      return ListView.builder(
        shrinkWrap: false,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.tiposTramite.length,
        itemBuilder: (context, index) {
          final tipo = controller.tiposTramite[index];
          return Obx(() {
            final isSelected = controller.selectedTipo.value?.id == tipo.id;
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isSelected ? procced : Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.assignment,
                  color: isSelected
                      ? const Color.fromARGB(255, 20, 53, 125)
                      : Colors.grey,
                ),
                title: Text(
                  tipo.tramite,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? const Color.fromARGB(255, 20, 53, 125)
                        : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle,
                        color: Color.fromARGB(255, 20, 53, 125))
                    : null,
                onTap: () => controller.seleccionarTipo(tipo),
              ),
            );
          });
        },
      );
    }),
  );
}

Widget inputCodTramite(
    BuildContext context, SeguimientoTramiteController controller) {
  return Container(
    margin: const EdgeInsets.only(left: 50, right: 40, top: 20, bottom: 40),
    child: TextField(
      controller: controller.codigoTramiteController,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.0,
      ),
      decoration: InputDecoration(
        labelText: "Cod. Trámite",
        hintText: "",
        hintStyle: const TextStyle(
          fontSize: 20,
          letterSpacing: 1.0,
        ),
        labelStyle: const TextStyle(
          fontSize: 22,
          letterSpacing: 1.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

Widget renderContent(
    BuildContext context, SeguimientoTramiteController controller) {
  return Obx(() {
    final processTrackerNum = controller.processTrackerNum.value;

    if (processTrackerNum == 0) {
      return listaTramites(context, controller);
    } else if (processTrackerNum == 1) {
      return inputCodTramite(context, controller);
    } else if (processTrackerNum == 2) {
      return renderTramite(context, controller);
    } else {
      return Container(); // O cualquier otro widget para el paso 2
    }
  });
}

Widget renderTramite(
    BuildContext context, SeguimientoTramiteController controller) {
  final TipoTramite tipoTramite = controller.selectedTipo.value!;
  final String codigoTramite = controller.codigoTramite.value;

  return FutureBuilder(
    future: controller.obtenerTramite(tipoTramite.id, codigoTramite),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Mostrar animación de carga mientras se consulta
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 241, 241),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedLogo(),
              const SizedBox(height: 30),
              _AnimatedLoadingText(),
            ],
          ),
        );
      } else {
        // Una vez terminada la consulta, setear isFinishSearch en true DESPUÉS del build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.setIsFinishSearch(true);
        });

        // Renderizar el widget correspondiente según el tipo de trámite
        switch (tipoTramite.id) {
          case '1': // Visas
            return visas(context, controller);
          case '2': // Poderes
            return poderes(context, controller);
          case '3': // Pasaporte
            return pasaportes(context, controller);
          case '4': // Vivencias
            return vivencias(context, controller);
          case '5': // AsistenciaConsular
            return asistenciaConsular(context, controller);
          default:
            return const Center(
              child: Text('Tipo de trámite no reconocido'),
            );
        }
      }
    },
  );
}

Widget renderEmpty(BuildContext context) {
  return Expanded(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 108.h,
            width: 108.h,
            decoration: BoxDecoration(
              image: getDecorationAssetImage(context, "search_screen.png"),
            ),
          ),
          SizedBox(height: 16),
          getCustomFont("No se encontraron resultados", 22, Colors.black, 1,
              fontWeight: FontWeight.w800),
          Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verifique que el código ingresado sea correcto e intente nuevamente.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

class _AnimatedLogo extends StatefulWidget {
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Anillo exterior giratorio
            Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      const Color.fromARGB(255, 20, 100, 180).withOpacity(0.3),
                      const Color.fromARGB(255, 20, 100, 180),
                      const Color.fromARGB(255, 20, 100, 180).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            // Logo SVG con shimmer
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 20, 100, 180)
                        .withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Logo PNG a todo color
                  Image.asset(
                    'assets/images/chakanafullcolor.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  // Efecto shimmer pasante
                  ClipOval(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Transform.translate(
                        offset: Offset(
                          (_controller.value * 2 - 0.5) * 200,
                          0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.4),
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedLoadingText extends StatefulWidget {
  @override
  State<_AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<_AnimatedLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int dots = (_controller.value * 3).floor();
        String dotText = '.' * (dots + 1);
        return Text(
          "Buscando información del trámite$dotText",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 30, 28, 115),
          ),
        );
      },
    );
  }
}
