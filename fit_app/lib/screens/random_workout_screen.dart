import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import '../services/routine_service.dart';

class RandomWorkoutScreen extends StatefulWidget {
  const RandomWorkoutScreen({super.key});

  @override
  State<RandomWorkoutScreen> createState() => _RandomWorkoutScreenState();
}

class _RandomWorkoutScreenState extends State<RandomWorkoutScreen> {
  final RoutineService _routineService = RoutineService();

  String _selectedRegion = 'all';
  final TextEditingController _durationCtrl = TextEditingController(text: '45');
  bool _onlyBodyweight = false;

  WorkoutRoutine? _generatedRoutine;
  bool _isGenerating = false;

  final List<Map<String, String>> _regions = [
    {'id': 'all', 'label': 'Corpo Todo (Full Body)'},
    {'id': 'chest', 'label': 'Peitoral'},
    {'id': 'back', 'label': 'Costas (Dorsal)'},
    {'id': 'legs', 'label': 'Membros Inferiores (Pernas)'},
    {'id': 'shoulders', 'label': 'Ombros'},
    {'id': 'arms', 'label': 'Braços (Bíceps e Tríceps)'},
    {'id': 'abs', 'label': 'Abdômen'},
    {'id': 'cardio', 'label': 'Cardio / Queima'},
  ];

  void _generateWorkout() async {
    setState(() => _isGenerating = true);

    final int duration = int.tryParse(_durationCtrl.text.trim()) ?? 45;

    final routine = await _routineService.generateRandomWorkout(
      bodyRegion: _selectedRegion,
      durationMinutes: duration,
      onlyBodyweight: _onlyBodyweight,
    );

    setState(() {
      _generatedRoutine = routine;
      _isGenerating = false;
    });
  }

  void _saveRoutine() async {
    if (_generatedRoutine == null) return;

    await _routineService.saveRoutine(_generatedRoutine!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ficha de treino salva em Minhas Rotinas!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Treino Express'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Região Muscular
            Text('1. Foco Muscular / Região', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items: _regions.map((reg) {
                return DropdownMenuItem(
                  value: reg['id'],
                  child: Text(reg['label']!),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedRegion = val);
              },
            ),
            const SizedBox(height: 20),

            // Tempo Aberto em Minutos (Sem travamento em 90 min)
            Text('2. Duração Estimada do Treino (minutos)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _durationCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tempo livre em minutos (ex: 30, 45, 120)',
                hintText: 'Digite quantos minutos você tem disponíveis',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Modalidade Calistenia / Aparelhos
            SwitchListTile(
              title: const Text('Apenas Peso Corporal (Calistenia)'),
              subtitle: const Text('Gera treinos sem necessidade de halteres ou máquinas'),
              value: _onlyBodyweight,
              onChanged: (val) => setState(() => _onlyBodyweight = val),
            ),
            const SizedBox(height: 20),

            // Botão Gerar
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.bolt),
                label: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(_isGenerating ? 'Gerando Ficha...' : 'Gerar Treino Agora'),
                ),
                onPressed: _isGenerating ? null : _generateWorkout,
              ),
            ),
            const SizedBox(height: 32),

            // Resultado do Treino Gerado (Lista dos Exercícios)
            if (_generatedRoutine != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _generatedRoutine!.name,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add, color: Colors.deepPurple),
                    tooltip: 'Salvar Ficha',
                    onPressed: _saveRoutine,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _generatedRoutine!.exercises.length,
                itemBuilder: (context, index) {
                  final ex = _generatedRoutine!.exercises[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(ex.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${ex.sets} séries x ${ex.reps} repetições | Descanso: ${ex.restSeconds}s'),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}