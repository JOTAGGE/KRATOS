import 'package:flutter/material.dart';
import '../models/body_metrics_model.dart';
import '../services/body_metrics_service.dart';

class BodyMetricsScreen extends StatefulWidget {
  const BodyMetricsScreen({super.key});

  @override
  State<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends State<BodyMetricsScreen> {
  final BodyMetricsService _service = BodyMetricsService();
  List<BodyMetrics> _history = [];
  bool _isLoading = true;

  // Controllers para formulário de nova medida
  final _weightCtrl = TextEditingController(text: '80.0');
  final _heightCtrl = TextEditingController(text: '178');
  final _targetWeightCtrl = TextEditingController(text: '75.0');
  final _fatCtrl = TextEditingController(text: '18.5');
  final _muscleCtrl = TextEditingController(text: '39.0');
  final _chestCtrl = TextEditingController(text: '102');
  final _waistCtrl = TextEditingController(text: '84');
  final _armCtrl = TextEditingController(text: '38');

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final list = await _service.getMetricsHistory();
    setState(() {
      _history = list;
      _isLoading = false;
    });
  }

  void _showAddMetricsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20, left: 20, right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nova Avaliação Corporal',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              Text('Gerais', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Peso (kg)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _heightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Altura (cm)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text('Bioimpedância', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fatCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Gordura (%)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _muscleCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Massa Magra (kg)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text('Perímetros (cm)', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chestCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Peitoral', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _waistCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cintura', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _armCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Braço', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              FilledButton(
                onPressed: () async {
                  final newEntry = BodyMetrics(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    date: DateTime.now(),
                    weight: double.tryParse(_weightCtrl.text) ?? 80.0,
                    height: double.tryParse(_heightCtrl.text) ?? 178.0,
                    targetWeight: double.tryParse(_targetWeightCtrl.text) ?? 75.0,
                    bodyFatPercentage: double.tryParse(_fatCtrl.text) ?? 0.0,
                    muscleMassKg: double.tryParse(_muscleCtrl.text) ?? 0.0,
                    chestCm: double.tryParse(_chestCtrl.text) ?? 0.0,
                    waistCm: double.tryParse(_waistCtrl.text) ?? 0.0,
                    rightArmCm: double.tryParse(_armCtrl.text) ?? 0.0,
                  );

                  final navigator = Navigator.of(context);
                  await _service.saveMetrics(newEntry);
                  navigator.pop();
                  _loadHistory();
                },
                child: const Text('Salvar Medidas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latest = _history.isNotEmpty ? _history.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medidas & Progresso'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Nova Avaliação'),
        onPressed: _showAddMetricsDialog,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (latest != null) ...[
                    // Card do Diagnóstico Atual (IMC + Peso)
                    Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PESO ATUAL', style: theme.textTheme.labelMedium),
                                    Text(
                                      '${latest.weight} kg',
                                      style: theme.textTheme.displayMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('IMC DADOS', style: theme.textTheme.labelMedium),
                                    Text(
                                      latest.bmi.toStringAsFixed(1),
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    Text(
                                      latest.bmiCategory,
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Gordura: ${latest.bodyFatPercentage}%'),
                                Text('Massa Magra: ${latest.muscleMassKg} kg'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  Text('Histórico de Avaliações', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      final dateStr = '${item.date.day}/${item.date.month}/${item.date.year}';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.monitor_weight)),
                          title: Text('Data: $dateStr — ${item.weight} kg'),
                          subtitle: Text(
                            'Gordura: ${item.bodyFatPercentage}% | Peitoral: ${item.chestCm}cm | Cintura: ${item.waistCm}cm | Braço: ${item.rightArmCm}cm',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}