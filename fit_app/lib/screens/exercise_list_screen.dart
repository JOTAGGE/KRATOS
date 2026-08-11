import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/exercise_model.dart';
import '../services/exercise_service.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ExerciseService _service = ExerciseService();
  List<Exercise> _exercises = [];
  bool _isLoading = true;
  bool _isGridView = false;

  String _selectedCategory = 'all';
  String _selectedEquipment = 'all';
  final TextEditingController _searchCtrl = TextEditingController();

  // Controllers para criar exercício customizado
  final _newExNameCtrl = TextEditingController();
  final _newExTargetCtrl = TextEditingController();
  String _newExCat = 'chest';
  String _newExEq = 'Halteres';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'Todos os Músculos'},
    {'id': 'chest', 'label': 'Peitoral'},
    {'id': 'back', 'label': 'Costas'},
    {'id': 'legs', 'label': 'Pernas & Glúteos'},
    {'id': 'shoulders', 'label': 'Ombros'},
    {'id': 'arms', 'label': 'Braços'},
    {'id': 'abs', 'label': 'Abdômen'},
    {'id': 'cardio', 'label': 'Cardio'},
  ];

  final List<Map<String, String>> _equipments = [
    {'id': 'all', 'label': 'Todos Equipamentos'},
    {'id': 'barbell', 'label': 'Barra'},
    {'id': 'dumbbell', 'label': 'Halteres'},
    {'id': 'cable', 'label': 'Polia'},
    {'id': 'machine', 'label': 'Máquina'},
    {'id': 'bodyweight', 'label': 'Peso Corporal'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  void _fetchExercises() async {
    setState(() => _isLoading = true);
    final list = await _service.getExercises(
      category: _selectedCategory,
      equipment: _selectedEquipment,
      query: _searchCtrl.text.trim(),
    );
    setState(() {
      _exercises = list;
      _isLoading = false;
    });
  }

  void _showCreateExerciseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20, left: 20, right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Criar Novo Exercício Customizado', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _newExNameCtrl,
                decoration: const InputDecoration(labelText: 'Nome do Exercício (ex: Elevação Y na Polia)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newExTargetCtrl,
                decoration: const InputDecoration(labelText: 'Músculo Alvo (ex: Trapézio Inferior)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _newExCat,
                      decoration: const InputDecoration(labelText: 'Grupo', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'chest', child: Text('Peitoral')),
                        DropdownMenuItem(value: 'back', child: Text('Costas')),
                        DropdownMenuItem(value: 'legs', child: Text('Pernas')),
                        DropdownMenuItem(value: 'shoulders', child: Text('Ombros')),
                        DropdownMenuItem(value: 'arms', child: Text('Braços')),
                        DropdownMenuItem(value: 'abs', child: Text('Abdômen')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _newExCat = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _newExEq,
                      decoration: const InputDecoration(labelText: 'Aparelho', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Barra', child: Text('Barra')),
                        DropdownMenuItem(value: 'Halteres', child: Text('Halteres')),
                        DropdownMenuItem(value: 'Polia', child: Text('Polia')),
                        DropdownMenuItem(value: 'Máquina', child: Text('Máquina')),
                        DropdownMenuItem(value: 'Peso Corporal', child: Text('Peso Corporal')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _newExEq = v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  if (_newExNameCtrl.text.isNotEmpty) {
                    final newEx = Exercise(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      name: _newExNameCtrl.text.trim(),
                      targetMuscle: _newExTargetCtrl.text.trim().isEmpty ? 'Geral' : _newExTargetCtrl.text.trim(),
                      muscleCategory: _newExCat,
                      secondaryMuscles: ['Outros'],
                      equipment: _newExEq,
                      images: [],
                      preparation: 'Posicione-se confortavelmente no aparelho.',
                      execution: 'Execute o movimento concentrado.',
                      safetyTips: ['Mantenha a postura estabilizada'],
                    );

                    await _service.createCustomExercise(newEx);
                    _newExNameCtrl.clear();
                    _newExTargetCtrl.clear();

                    if (mounted) {
                      Navigator.pop(ctx);
                      _fetchExercises();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exercício customizado criado com sucesso!')),
                      );
                    }
                  }
                },
                child: const Text('Salvar Exercício'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de Exercícios'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'Ver em Lista' : 'Ver em Blocos',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
        label: const Text('Criar Exercício'),
        onPressed: _showCreateExerciseModal,
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar exercício por nome ou músculo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _fetchExercises();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (_) => _fetchExercises(),
            ),
          ),

          // Filtros de Músculo
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['id'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedCategory = cat['id']!);
                      _fetchExercises();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Filtros de Equipamento
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _equipments.length,
              itemBuilder: (context, index) {
                final eq = _equipments[index];
                final isSelected = _selectedEquipment == eq['id'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(eq['label']!),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedEquipment = eq['id']!);
                      _fetchExercises();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Lista de Exercícios com Fallback Resiliente
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.dumbbell, size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text('Nenhum exercício encontrado com esses filtros', style: theme.textTheme.titleMedium),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final ex = _exercises[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ex.images.isNotEmpty
                                    ? Image.network(
                                        ex.images.first,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, stack) => Container(
                                          width: 50,
                                          height: 50,
                                          color: theme.colorScheme.primaryContainer,
                                          child: const Center(child: FaIcon(FontAwesomeIcons.dumbbell, size: 20)),
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        color: theme.colorScheme.primaryContainer,
                                        child: const Center(child: FaIcon(FontAwesomeIcons.dumbbell, size: 20)),
                                      ),
                              ),
                              title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Alvo: ${ex.targetMuscle} • Equip: ${ex.equipment}'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExerciseDetailScreen(exercise: ex),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}