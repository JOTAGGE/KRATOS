import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  int _currentImageIndex = 0;
  Timer? _animationTimer;

  final _weightCtrl = TextEditingController(text: '40.0');
  final _repsCtrl = TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _startImageAnimation();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startImageAnimation() {
    if (widget.exercise.images.length > 1) {
      _animationTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
        if (mounted) {
          setState(() {
            _currentImageIndex = (_currentImageIndex + 1) % widget.exercise.images.length;
          });
        }
      });
    }
  }

  void _loadHistory() async {
    final logs = await _service.getExerciseHistory(widget.exercise.id);
    setState(() {
      _history = logs;
      _isLoading = false;
    });
  }

  void _addNewSetLog() async {
    final weight = double.tryParse(_weightCtrl.text.trim()) ?? 0.0;
    final reps = int.tryParse(_repsCtrl.text.trim()) ?? 0;

    if (weight > 0 && reps > 0) {
      await _service.addExerciseLog(widget.exercise.id, weight, reps, 45);
      _loadHistory();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Série registrada no histórico!')),
        );
      }
    }
  }

  void _showAddLogModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20, left: 20, right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Registrar Nova Série Real', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Carga (kg)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _repsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Repetições', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _addNewSetLog,
              child: const Text('Salvar Série no Banco'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEquipmentFontAwesomeIcon(String eq) {
    final e = eq.toLowerCase();
    if (e.contains('halter')) return FontAwesomeIcons.dumbbell;
    if (e.contains('polia')) return FontAwesomeIcons.disease;
    if (e.contains('barra')) return FontAwesomeIcons.weightHanging;
    if (e.contains('máquina') || e.contains('maquina')) return FontAwesomeIcons.gears;
    return FontAwesomeIcons.personRunning;
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
              Tab(icon: FaIcon(FontAwesomeIcons.play, size: 18), text: 'Execução'),
              Tab(icon: FaIcon(FontAwesomeIcons.bookOpen, size: 18), text: 'Instruções'),
              Tab(icon: FaIcon(FontAwesomeIcons.chartLine, size: 18), text: 'Histórico & Stats'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
          label: const Text('Registrar Carga'),
          onPressed: _showAddLogModal,
        ),
        body: TabBarView(
          children: [
            // Aba 1: Execução e Ícones de Equipamentos
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ex.images.isNotEmpty
                          ? Image.network(
                              ex.images[_currentImageIndex],
                              key: ValueKey<int>(_currentImageIndex),
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 280,
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Center(
                                  child: FaIcon(FontAwesomeIcons.dumbbell, size: 48),
                                ),
                              ),
                            )
                          : Container(
                              height: 280,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: FaIcon(FontAwesomeIcons.dumbbell, size: 48),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Animação de Execução (Fase ${_currentImageIndex + 1}/${ex.images.length})',
                      style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                _getEquipmentFontAwesomeIcon(ex.equipment),
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Equipamento Requerido', style: theme.textTheme.labelMedium),
                                    Text(ex.equipment, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.bullseye, color: Colors.redAccent, size: 20),
                              const SizedBox(width: 8),
                              Text('Músculo Alvo:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(ex.targetMuscle),
                                backgroundColor: theme.colorScheme.primaryContainer,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Músculos Secundários / Sinergistas:', style: theme.textTheme.labelMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ex.secondaryMuscles.map((m) => Chip(label: Text(m))).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Aba 2: Instruções
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.orange, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tip, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Aba 3: Histórico Real
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_history.isNotEmpty) ...[
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
                                      const Text('RECORDE PESSOAL (1RM)', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(
                                        '${_history.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b)} kg',
                                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const FaIcon(FontAwesomeIcons.trophy, size: 40, color: Colors.amber),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        Text('Séries Registradas no Banco', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),

                        _history.isEmpty
                            ? Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.clockRotateLeft, size: 40, color: Colors.grey),
                                      const SizedBox(height: 12),
                                      const Text('Nenhum registro no banco de dados.'),
                                      const SizedBox(height: 4),
                                      const Text('Toque no botão abaixo para adicionar sua primeira carga.'),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _history.length,
                                itemBuilder: (context, index) {
                                  final item = _history[index];
                                  final dateStr = '${item.date.day}/${item.date.month}/${item.date.year}';

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.dumbbell, size: 16)),
                                      title: Text('${item.weightKg} kg × ${item.reps} reps'),
                                      subtitle: Text('Data: $dateStr'),
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