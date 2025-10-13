import 'package:flutter/material.dart';
import 'package:mi_cancilleria/app/ui/pages/components/procces_tracker.dart';
import 'package:mi_cancilleria/controllers/consulado/seguimiento_tramite_controller.dart';

Widget asistenciaConsular(
    BuildContext context, SeguimientoTramiteController controller) {
  final tramite = controller.tramiteAsistenciaConsular.value;

  if (tramite == null) {
    return renderEmpty(context);
  }

  final objeto = tramite.objeto!;
  final estado = tramite.exitosa ? 'Registrado' : 'Pendiente';

  return Expanded(
    child: ListView(
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 0.0, bottom: 0.0),
      children: [
        // Header con estado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF14357D), Color(0xFF1E4FA0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Asistencia Consular',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _getEstadoIcon(estado),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      estado,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Información del Afectado
        _buildSection(
          title: 'Datos del Afectado',
          icon: Icons.person,
          children: [
            _buildInfoRow('Nombre Completo',
                '${objeto.afectado.nombre} ${objeto.afectado.apellido}'),
            _buildInfoRow('N° Documento', objeto.afectado.numDocumento),
          ],
        ),
        const SizedBox(height: 5),

        // Información del Trámite
        _buildSection(
          title: 'Información del Trámite',
          icon: Icons.description,
          children: [
            _buildInfoRow('Código', objeto.codAsistencia),
            _buildInfoRow('Fecha de Registro', _formatDate(objeto.fecha)),
            _buildInfoRow('Tipo de Asistencia', objeto.tipoAsistenciaNombre),
            _buildInfoRow('País', objeto.pais),
          ],
        ),
        const SizedBox(height: 5),

        // Información del Consulado
        _buildSection(
          title: 'Información del Consulado',
          icon: Icons.business,
          children: [
            _buildInfoRow('Unidad Organizacional', objeto.uniOrganizacional),
          ],
        ),
        const SizedBox(height: 5),

        // Footer informativo
        Container(
          padding: const EdgeInsets.all(12),
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
                  'Para más información contacte con su consulado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSection({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF14357D).withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF14357D), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14357D),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value, {bool highlight = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? const Color(0xFF14357D) : Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}

IconData _getEstadoIcon(String estado) {
  final estadoLower = estado.toLowerCase();
  if (estadoLower.contains('registrado') ||
      estadoLower.contains('completado') ||
      estadoLower.contains('aprobado')) {
    return Icons.check_circle;
  } else if (estadoLower.contains('pendiente') ||
      estadoLower.contains('proceso')) {
    return Icons.schedule;
  } else if (estadoLower.contains('rechazado') ||
      estadoLower.contains('cancelado')) {
    return Icons.cancel;
  }
  return Icons.info;
}

String _formatDate(String date) {
  try {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
  } catch (e) {
    return date;
  }
}
