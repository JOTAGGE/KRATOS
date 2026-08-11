import 'package:flutter/material.dart';
import '../services/health_sync_service.dart';

class HealthSyncScreen extends StatefulWidget {
  const HealthSyncScreen({super.key});

  @override
  State<HealthSyncScreen> createState() => _HealthSyncScreenState();
}

class _HealthSyncScreenState extends State<HealthSyncScreen> {
  final HealthSyncService _healthService = HealthSyncService();

  int _steps = 0;
  double _calories = 0.0;
  bool _isConnected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAndFetchData();
  }

  void _checkAndFetchData() async {
    setState(() => _isLoading = true);
    final authorized = await _healthService.requestPermissions();
    if (authorized) {
      final steps = await _healthService.getTodaySteps();
      final calories = await _healthService.getTodayCalories();
      setState(() {
        _steps = steps;
        _calories = calories;
        _isConnected = true;
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectividade de Saúde'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner do Status da Conexão
            Card(
              color: _isConnected
                  ? Colors.green.withAlpha(40)
                  : theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  _isConnected ? Icons.favorite : Icons.favorite_border,
                  color: _isConnected ? Colors.green[800] : theme.colorScheme.error,
                  size: 36,
                ),
                title: Text(
                  _isConnected ? 'Health Connect Ativo' : 'Desconectado',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _isConnected
                      ? 'Seus treinos e passos estão sincronizados em tempo real.'
                      : 'Toque para permitir acesso ao Google Fit / Health Connect.',
                ),
                trailing: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _checkAndFetchData,
                      ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Métricas de Hoje', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(Icons.directions_walk, size: 40, color: Colors.blue),
                          const SizedBox(height: 12),
                          Text('Passos Diários', style: theme.textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text(
                            '$_steps',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(Icons.local_fire_department, size: 40, color: Colors.orange),
                          const SizedBox(height: 12),
                          Text('Calorias Ativas', style: theme.textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text(
                            '${_calories.toInt()} kcal',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Card Informativo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Todos os treinos finalizados no Kratos Fit são exportados automaticamente para o ecossistema do seu smartphone.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}