import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../services/exercise_service.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final ExerciseService _service = ExerciseService();
  List<ExerciseSetLog> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final logs = await _service.getExerciseHistory(widget.exercise.id);
    setState(() {
      _history = logs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = widget.exercise;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ex.name),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.play_circle_outline), text: 'Execução'),
              Tab(icon: Icon(Icons.menu_book), text: 'Instruções'),
              Tab(icon: Icon(Icons.insights), text: 'Histórico & Stats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba 1: Animação e Diagrama
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animação / GIF
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      ex.gifUrl,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 240,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center, size: 64),
                            SizedBox(height: 8),
                            Text('Animação Técnica em Vídeo'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Músculo Alvo e Secundários
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.gps_fixed, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Text('Músculo Alvo:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Chip(label: Text(ex.targetMuscle)),
                            ],
                          ),
                          const Divider(height: 20),
                          Text('Músculos Secundários:', style: theme.textTheme.labelMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ex.secondaryMuscles.map((m) => Chip(label: Text(m))).toList(),
                          ),
                          const SizedBox(height: 8),
                          Text('Equipamento: ${ex.equipment}', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Aba 2: Instruções Completas
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Preparação', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(ex.preparation, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 20),

                  Text('2. Execução Técnica', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(ex.execution, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 20),

                  Text('3. Dicas de Segurança', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 8),
                  ...ex.safetyTips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tip, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Aba 3: Estatísticas e Histórico
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card do Record Pessoal
                        Card(
                          color: theme.colorScheme.primaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('CARGA MÁXIMA (1RM)', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      '${_history.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b)} kg',
                                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text('Histórico de Execução', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final item = _history[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(Icons.history),
                                title: Text('${item.weightKg} kg x ${item.reps} reps'),
                                subtitle: Text('Tempo sob tensão: ${item.durationSeconds}s'),
                                trailing: Text('${item.date.day}/${item.date.month}'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}