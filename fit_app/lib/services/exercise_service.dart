import '../models/exercise_model.dart';

class ExerciseService {
  static final List<Exercise> _exerciseDatabase = [
    Exercise(
      id: 'supino_reto',
      name: 'Supino Reto com Barra',
      targetMuscle: 'Peitoral Maior',
      muscleCategory: 'chest',
      secondaryMuscles: ['Deltoide Anterior', 'Tríceps Braquial'],
      equipment: 'Barra e Banco',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bench_Press/0.jpg',
      preparation: 'Deite-se no banco plano com os pés firmes no chão. Segure a barra com pegada ligeiramente mais larga que os ombros e escápulas retraídas.',
      execution: 'Desça a barra de forma controlada até a linha média do peitoral. Empurre a barra até a extensão quase completa dos cotovelos sem perder o contrapeso das costas.',
      safetyTips: ['Nunca descole o quadril do banco', 'Mantenha os cotovelos a aproximadamente 45 graus do tronco'],
    ),
    Exercise(
      id: 'remada_curvada',
      name: 'Remada Curvada com Barra',
      targetMuscle: 'Dorsal / Latíssimo do Dorso',
      muscleCategory: 'back',
      secondaryMuscles: ['Trapezius', 'Bíceps Braquial', 'Romboide'],
      equipment: 'Barra',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bent_Over_Row/0.jpg',
      preparation: 'Incline o tronco para a frente a cerca de 45 graus, flexionando levemente os joelhos e mantendo a coluna neutra.',
      execution: 'Puxe a barra em direção ao umbigo contraindo a musculatura das costas. Retorne à posição inicial estendendo os braços de forma controlada.',
      safetyTips: ['Mantenha o abdômen contraído para proteger a lombar', 'Evite usar o impulso das pernas'],
    ),
    Exercise(
      id: 'agachamento_livre',
      name: 'Agachamento Livre com Barra',
      targetMuscle: 'Quadríceps',
      muscleCategory: 'legs',
      secondaryMuscles: ['Glúteo Máximo', 'Isquiotibiais', 'Eretores da Espinha'],
      equipment: 'Barra e Rack',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Full_Squat/0.jpg',
      preparation: 'Apoie a barra nos trapézios (low ou high bar). Afaste os pés na largura dos ombros com as pontas levemente voltadas para fora.',
      execution: 'Inicie o movimento flexionando os quadris e joelhos simultaneamente até que as coxas fiquem pelo menos paralelas ao solo. Suba empurrando o chão.',
      safetyTips: ['Mantenha os joelhos alinhados com as pontas dos pés', 'Não deixe a coluna dobrar no fundo do movimento'],
    ),
    Exercise(
      id: 'desenvolvimento_halteres',
      name: 'Desenvolvimento de Ombros com Halteres',
      targetMuscle: 'Deltoide Lateral e Anterior',
      muscleCategory: 'shoulders',
      secondaryMuscles: ['Tríceps', 'Trapezius Superior'],
      equipment: 'Halteres',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Shoulder_Press/0.jpg',
      preparation: 'Sente-se num banco com apoio a 90 graus. Segure os halteres na altura das orelhas com os palmas voltadas para a frente.',
      execution: 'Empurre os halteres para cima até que quase se toquem no topo. Desça lentamente até a altura do queixo/orelhas.',
      safetyTips: ['Evite hiperextender a lombar durante a subida', 'Controle a descida sem soltar o peso'],
    ),
    Exercise(
      id: 'rosca_direta',
      name: 'Rosca Direta com Barra W',
      targetMuscle: 'Bíceps Braquial',
      muscleCategory: 'arms',
      secondaryMuscles: ['Braquial', 'Antebraço'],
      equipment: 'Barra W',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/EZ_Barbell_Curl/0.jpg',
      preparation: 'Fique em pé com os joelhos levemente flexionados. Segure a barra W na pegada anatômica com os cotovelos colados ao tronco.',
      execution: 'Flexione os cotovelos trazendo a barra até a altura do peito, mantendo os braços estáticos. Retorne estendendo totalmente sem balançar.',
      safetyTips: ['Mantenha os cotovelos fixos ao lado do corpo', 'Evite usar o balanço do tronco'],
    ),
    Exercise(
      id: 'triceps_testa',
      name: 'Tríceps Testa com Barra EZ',
      targetMuscle: 'Tríceps (Cabeça Longa)',
      muscleCategory: 'arms',
      secondaryMuscles: ['Ancôneo'],
      equipment: 'Barra W e Banco',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/EZ_Barbell_Lying_Triceps_Extension/0.jpg',
      preparation: 'Deite-se no banco reto com a barra estendida sobre o peitoral.',
      execution: 'Flexione apenas os cotovelos trazendo a barra em direção à testa/topo da cabeça. Estenda o cotovelo focando na contração do tríceps.',
      safetyTips: ['Mantenha os cotovelos apontados para o teto', 'Controle o peso na aproximação da cabeça'],
    ),
    Exercise(
      id: 'abdominal_infra',
      name: 'Abdominal Infra no Banco Paralelo',
      targetMuscle: 'Reto Abdominal (Infra)',
      muscleCategory: 'abs',
      secondaryMuscles: ['Flexores do Quadril'],
      equipment: 'Paralela / Peso Corporal',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Raise/0.jpg',
      preparation: 'Apoie os antebraços no suporte e mantenha o tronco ereto.',
      execution: 'Eleve os joelhos ou pernas estendidas até a linha do quadril contraindo o abdômen. Desça devagar sem balançar o corpo.',
      safetyTips: ['Evite usar o balanço do corpo', 'Foque no movimento da pelve'],
    ),
    Exercise(
      id: 'corrida_esteira',
      name: 'Corrida Contínua / HIITT',
      targetMuscle: 'Sistema Cardiorrespiratório',
      muscleCategory: 'cardio',
      secondaryMuscles: ['Panturrilhas', 'Quadríceps', 'Isquiotibiais'],
      equipment: 'Esteira / Ergométrica',
      gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Treadmill_Running/0.jpg',
      preparation: 'Ajuste a velocidade e inclinação desejadas na máquina.',
      execution: 'Mantenha a postura ereta, pisada no meio do pé e ritmo respiratório ritmado.',
      safetyTips: ['Use calçado adequado para amortecimento', 'Comece com aquecimento leve'],
    ),
  ];

  Future<List<Exercise>> getExercises({String? category, String? query}) async {
    return _exerciseDatabase.where((item) {
      bool matchesCategory = true;
      if (category != null && category.isNotEmpty && category != 'all') {
        matchesCategory = item.muscleCategory.toLowerCase() == category.toLowerCase();
      }

      bool matchesQuery = true;
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        matchesQuery = item.name.toLowerCase().contains(q) ||
            item.targetMuscle.toLowerCase().contains(q) ||
            item.equipment.toLowerCase().contains(q);
      }

      return matchesCategory && matchesQuery;
    }).toList();
  }

  // Histórico de séries do usuário no exercício
  Future<List<ExerciseSetLog>> getExerciseHistory(String exerciseId) async {
    final now = DateTime.now();
    return [
      ExerciseSetLog(date: now.subtract(const Duration(days: 14)), weightKg: 60, reps: 10, durationSeconds: 40),
      ExerciseSetLog(date: now.subtract(const Duration(days: 7)), weightKg: 65, reps: 8, durationSeconds: 45),
      ExerciseSetLog(date: now.subtract(const Duration(days: 2)), weightKg: 70, reps: 8, durationSeconds: 50),
    ];
  }
}