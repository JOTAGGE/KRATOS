import 'package:flutter/material.dart';
import '../models/workout_log_model.dart';
import '../services/history_fatigue_service.dart';

class HistoryFatigueScreen extends StatefulWidget {
  const HistoryFatigueScreen({super.key});

  @override
  State<HistoryFatigueScreen> createState() => _HistoryFatigueScreenState();
}

class _HistoryFatigueScreenState extends State<HistoryFatigueScreen> with SingleTickerProviderStateMixin {
  final HistoryFatigueService _service = HistoryFatigueService();
  late TabController _tabController;
  
  List<WorkoutLog> _logs = [];
  Map<String, double> _fatigue = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() async {
    final logs = await _service.getHistory();
    final fatigue = _service.calculateMuscleFatigue(logs);
    setState(() {
      _logs = logs;
      _fatigue = fatigue;
      _isLoading = false;
    });
  }

  Color _getFatigueColor(double level) {
    if (level > 0.7) return Colors.redAccent;
    if (level > 0.3) return Colors.orangeAccent;
    return Colors.green;
  }

  String _getFatigueStatusText(double level) {
    if (level > 0.7) return 'Fadiga Alta (Recomenda-se Descanso)';
    if (level > 0.3) return 'Recuperação Parcial';
    return 'Totalmente Recuperado';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico & Fadiga Muscular'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center), text: 'Fadiga Muscular'),
            Tab(icon: Icon(Icons.history), text: 'Histórico de Treinos'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // ABA 1: Painel de Fadiga Muscular
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status de Recuperação Corporal',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estimativa biológica baseada na intensidade e tempo dos seus últimos treinos.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),

                      ..._fatigue.entries.map((entry) {
                        final muscle = entry.key;
                        final level = entry.value;
                        final percentage = (level * 100).toInt();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      muscle,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Chip(
                                      backgroundColor: _getFatigueColor(level).withAlpha(40),
                                      side: BorderSide(color: _getFatigueColor(level)),
                                      label: Text(
                                        '$percentage%',
                                        style: TextStyle(
                                          color: _getFatigueColor(level),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: level,
                                  color: _getFatigueColor(level),
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getFatigueStatusText(level),
                                  style: theme.textTheme.bodySmall?.copyWith(color: _getFatigueColor(level)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // ABA 2: Lista do Histórico de Treinos
                _logs.isEmpty
                    ? const Center(child: Text('Nenhum treino registrado ainda.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          final dateStr = '${log.completedAt.day}/${log.completedAt.month}/${log.completedAt.year} às ${log.completedAt.hour}:${log.completedAt.minute.toString().padLeft(2, '0')}';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.check_circle_outline),
                              ),
                              title: Text(log.routineName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Data: $dateStr\nDuração: ${log.durationMinutes} min'),
                              trailing: Text('${log.targetedMuscles.length} Músculos'),
                            ),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}