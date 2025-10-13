import 'package:flutter/material.dart';
import 'package:mi_cancilleria/app/ui/pages/components/procces_tracker.dart';
import 'package:mi_cancilleria/controllers/consulado/seguimiento_tramite_controller.dart';

Widget visas(BuildContext context, SeguimientoTramiteController controller) {
  final tramite = controller.tramiteVisas.value;

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
                'Trámite de Visa',
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
            _buildInfoRow('Nombre', objeto.personaNombre1),
            if (objeto.personaApellido1 != null)
              _buildInfoRow('Primer Apellido', objeto.personaApellido1!),
            if (objeto.personaApellido2 != null)
              _buildInfoRow('Segundo Apellido', objeto.personaApellido2!),
          ],
        ),
        const SizedBox(height: 5),

        // Información del Trámite
        _buildSection(
          title: 'Información del Trámite',
          icon: Icons.description,
          children: [
            _buildInfoRow('Código', objeto.codigo),
            _buildInfoRow('Grupo', objeto.grupo),
            _buildInfoRow('Fecha de Registro', _formatDate(objeto.fecReg)),
            _buildInfoRow('Tipo de Trámite', objeto.aranceDescripcion),
          ],
        ),
        const SizedBox(height: 5),

        // Información de Pago
        _buildSection(
          title: 'Información de Pago',
          icon: Icons.payment,
          children: [
            if (objeto.nroDeposito != null)
              _buildInfoRow('Nro. Depósito', objeto.nroDeposito!),
            _buildInfoRow(
                'Fecha de Depósito', _formatDate(objeto.fechaDeposito)),
            if (objeto.montoDeposito != null)
              _buildInfoRow(
                'Monto',
                '\$${objeto.montoDeposito!.toStringAsFixed(2)}',
                highlight: true,
              ),
          ],
        ),
        const SizedBox(height: 5),

        // Observaciones
        if (objeto.observacion != null && objeto.observacion!.isNotEmpty)
          _buildSection(
            title: 'Observaciones',
            icon: Icons.info_outline,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Text(
                  objeto.observacion!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
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

String _formatDate(String date) {
  try {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
  } catch (e) {
    return date;
  }
}
