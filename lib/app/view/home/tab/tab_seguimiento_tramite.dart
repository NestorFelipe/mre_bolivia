import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mi_cancilleria/app/ui/pages/components/procces_tracker.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:mi_cancilleria/base/utils/utils.dart';
import 'package:mi_cancilleria/controllers/consulado/seguimiento_tramite_controller.dart';

class SeguimientoTramite extends GetView<SeguimientoTramiteController> {
  const SeguimientoTramite({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Column(
            children: [
              getPaddingWidget(
                EdgeInsets.only(left: 15.w, right: 15.w, top: 0, bottom: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCustomFont(
                      "Seguimiento de Trámites",
                      24,
                      const Color.fromARGB(255, 51, 51, 51),
                      2,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              getVerSpace(10.h),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: processTracker(context, controller),
              ),
              getVerSpace(10.h),
              mensajeProceso(context, controller),
              getVerSpace(20.h),
              renderContent(context, controller),
              confirmButton(context, controller)
            ],
          ),
        ),
      ),
    );
  }
}
