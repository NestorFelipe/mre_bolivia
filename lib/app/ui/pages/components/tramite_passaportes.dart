import 'package:flutter/material.dart';
import 'package:mi_cancilleria/app/ui/pages/components/procces_tracker.dart';
import 'package:mi_cancilleria/controllers/consulado/seguimiento_tramite_controller.dart';

Widget pasaportes(
    BuildContext context, SeguimientoTramiteController controller) {
  final tramite = controller.tramitePassaportes.value;
  if (tramite == null) {
    return renderEmpty(context);
  }

  final objeto = tramite.objeto;

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
                'Trámite de Pasaporte',
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
                    _getEstadoIcon(objeto.estado),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      objeto.estado,
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

        // Información del Solicitante
        _buildSection(
          title: 'Información del Solicitante',
          icon: Icons.person,
          children: [
            _buildInfoRow('Nombre Completo',
                '${objeto.nombre} ${objeto.paterno} ${objeto.materno}'),
            _buildInfoRow('Correo Electrónico', objeto.email),
            _buildInfoRow('ID Solicitante', objeto.idSolicitante.toString()),
          ],
        ),
        const SizedBox(height: 5),

        // Información del Trámite
        _buildSection(
          title: 'Información del Trámite',
          icon: Icons.description,
          children: [
            _buildInfoRow('Código de Solicitud', objeto.codSolicitud),
            _buildInfoRow('Fecha de Registro', _formatDate(objeto.fechaReg)),
            _buildInfoRow('Gestión', objeto.gestion.toString()),
            _buildInfoRow('Mes', objeto.mes.toString()),
          ],
        ),
        const SizedBox(height: 5),

        // Historial de Seguimiento
        if (objeto.listaSeguimiento.isNotEmpty)
          _buildSection(
            title: 'Historial de Seguimiento',
            icon: Icons.timeline,
            children: [
              ...objeto.listaSeguimiento.asMap().entries.map((entry) {
                final index = entry.key;
                final seguimiento = objeto.listaSeguimiento[index];
                final isLast = index == objeto.listaSeguimiento.length - 1;

                return _buildTimelineItem(
                  seguimiento: seguimiento,
                  isLast: isLast,
                  isFirst: index == 0,
                );
              }),
            ],
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
  if (estadoLower.contains('aprobado') || estadoLower.contains('completado')) {
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

Widget _buildTimelineItem({
  required seguimiento,
  required bool isLast,
  required bool isFirst,
}) {
  Color stateColor = _getStateColor(seguimiento.estado);

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isFirst ? stateColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: stateColor, width: 2),
                ),
                child: isFirst
                    ? const Icon(Icons.circle, size: 12, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: stateColor.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: stateColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: stateColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          seguimiento.estado,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: stateColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14357D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${seguimiento.diasTranscurridos} días',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF14357D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(seguimiento.fechareg),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (seguimiento.observacion.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      seguimiento.observacion,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Color _getStateColor(String estado) {
  final estadoLower = estado.toLowerCase();
  if (estadoLower.contains('aprobado') ||
      estadoLower.contains('finalizado') ||
      estadoLower.contains('completado')) {
    return Colors.green;
  } else if (estadoLower.contains('proceso') ||
      estadoLower.contains('pendiente') ||
      estadoLower.contains('revisión')) {
    return Colors.orange;
  } else if (estadoLower.contains('rechazado') ||
      estadoLower.contains('cancelado')) {
    return Colors.red;
  }
  return const Color(0xFF14357D);
}

String _formatDate(String date) {
  try {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
  } catch (e) {
    return date;
  }
}
