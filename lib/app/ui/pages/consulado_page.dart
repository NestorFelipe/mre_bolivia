import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/consulado_controller.dart';

class ConsultadoPage extends GetView<ConsultadoController> {
  const ConsultadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (controller.consultadoData == null) {
          return const Center(
            child: Text('No hay datos disponibles'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Países',
                controller.getPaises().length,
                () => _showPaises(context),
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Entidades',
                controller.getEntidades().length,
                () => _showEntidades(context),
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Tipos de Trámite',
                controller.getTiposTramite().length,
                () => _showTiposTramite(context),
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Definiciones',
                controller.consultadoData!.definiciones.length,
                () => _showDefiniciones(context),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, int count, VoidCallback onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$count elementos'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showPaises(BuildContext context) {
    final paises = controller.getPaises();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Países',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: paises.length,
                itemBuilder: (context, index) {
                  final pais = paises[index];
                  return ListTile(
                    title: Text(pais.name ?? 'Sin nombre'),
                    subtitle: Text('Código: ${pais.alpha2 ?? 'N/A'}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEntidades(BuildContext context) {
    final entidades = controller.getEntidades();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entidades',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: entidades.length,
                itemBuilder: (context, index) {
                  final entidad = entidades[index];
                  return ListTile(
                    title: Text(entidad.nombre ?? 'Sin nombre'),
                    subtitle: Text(entidad.descripcion ?? 'Sin descripción'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTiposTramite(BuildContext context) {
    final tipos = controller.getTiposTramite();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipos de Trámite',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tipos.length,
                itemBuilder: (context, index) {
                  final tipo = tipos[index];
                  return ListTile(
                    title: Text(tipo.nombre ?? 'Sin nombre'),
                    subtitle: Text('Código: ${tipo.codTipoArray ?? 'N/A'}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDefiniciones(BuildContext context) {
    final definiciones = controller.consultadoData!.definiciones;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Definiciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: definiciones.length,
                itemBuilder: (context, index) {
                  final definicion = definiciones[index];
                  return ListTile(
                    title: Text(definicion.titulo ?? 'Sin título'),
                    subtitle: Text(definicion.valor ?? 'Sin valor'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}