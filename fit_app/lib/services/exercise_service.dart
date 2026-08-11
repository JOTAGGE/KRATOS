import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';

class ExerciseService {
  static const String _imgBase = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/';

  static final List<Exercise> _exerciseDatabase = [
    // --- PEITORAL (CHEST) ---
    Exercise(
      id: 'barbell_bench_press',
      name: 'Supino Reto com Barra',
      targetMuscle: 'Peitoral Maior',
      muscleCategory: 'chest',
      secondaryMuscles: ['Deltoide Anterior', 'Tríceps Braquial'],
      equipment: 'Barra',
      images: ['${_imgBase}Barbell_Bench_Press/0.jpg', '${_imgBase}Barbell_Bench_Press/1.jpg'],
      preparation: 'Deite-se no banco plano com os pés firmes no chão. Mantenha as escápulas retraídas contra o banco.',
      execution: 'Desça a barra até a linha média do peitoral de forma controlada. Empurre estendendo os braços.',
      safetyTips: ['Não descole os glúteos do banco', 'Mantenha os cotovelos em ângulo de ~45°'],
    ),
    Exercise(
      id: 'incline_dumbbell_press',
      name: 'Supino Inclinado com Halteres',
      targetMuscle: 'Peitoral Superior',
      muscleCategory: 'chest',
      secondaryMuscles: ['Deltoide Anterior', 'Tríceps'],
      equipment: 'Halteres',
      images: ['${_imgBase}Incline_Dumbbell_Press/0.jpg', '${_imgBase}Incline_Dumbbell_Press/1.jpg'],
      preparation: 'Ajuste o banco entre 30° e 45°. Apoie os halteres na coxa antes de deitar.',
      execution: 'Empurre os halteres para cima até quase se tocarem no topo. Desça até a linha do peito.',
      safetyTips: ['Evite abrir os cotovelos excessivamente'],
    ),
    Exercise(
      id: 'decline_barbell_bench_press',
      name: 'Supino Declinado com Barra',
      targetMuscle: 'Peitoral Inferior',
      muscleCategory: 'chest',
      secondaryMuscles: ['Tríceps Braquial', 'Deltoide Anterior'],
      equipment: 'Barra',
      images: ['${_imgBase}Decline_Barbell_Bench_Press/0.jpg', '${_imgBase}Decline_Barbell_Bench_Press/1.jpg'],
      preparation: 'Trave os pés no suporte do banco declinado e segure a barra na largura dos ombros.',
      execution: 'Desça a barra até a parte inferior do peito e empurre verticalmente.',
      safetyTips: ['Tenha a ajuda de um parceiro para tirar a barra do suporte'],
    ),
    Exercise(
      id: 'cable_crossover',
      name: 'Crucifixo / Crossover na Polia',
      targetMuscle: 'Peitoral (Isolamento)',
      muscleCategory: 'chest',
      secondaryMuscles: ['Deltoide Anterior'],
      equipment: 'Polia',
      images: ['${_imgBase}Cable_Crossover/0.jpg', '${_imgBase}Cable_Crossover/1.jpg'],
      preparation: 'Ajuste as polias no ponto desejado. Dê um passo à frente para manter a tensão.',
      execution: 'Com cotovelos levemente flexionados, traga os puxadores até se cruzarem à frente.',
      safetyTips: ['Mantenha o tronco estável sem balançar'],
    ),
    Exercise(
      id: 'dumbbell_flyes',
      name: 'Crucifixo Reto com Halteres',
      targetMuscle: 'Peitoral Maior',
      muscleCategory: 'chest',
      secondaryMuscles: ['Deltoide Anterior'],
      equipment: 'Halteres',
      images: ['${_imgBase}Dumbbell_Flyes/0.jpg', '${_imgBase}Dumbbell_Flyes/1.jpg'],
      preparation: 'Deite-se no banco plano com os halteres estendidos sobre o peitoral.',
      execution: 'Abra os braços em arco levemente dobrando os cotovelos até sentir o alongamento.',
      safetyTips: ['Não hiper-estenda os ombros na descida'],
    ),
    Exercise(
      id: 'pushups',
      name: 'Flexão de Braço',
      targetMuscle: 'Peitoral Maior',
      muscleCategory: 'chest',
      secondaryMuscles: ['Tríceps', 'Core'],
      equipment: 'Peso Corporal',
      images: ['${_imgBase}Pushups/0.jpg', '${_imgBase}Pushups/1.jpg'],
      preparation: 'Mãos alinhadas na largura dos ombros, corpo em linha reta.',
      execution: 'Flexione os cotovelos até quase tocar o peito no chão e empurre de volta.',
      safetyTips: ['Não deixe o quadril selar'],
    ),
    Exercise(
      id: 'chest_dips',
      name: 'Paralelas para Peito (Dips)',
      targetMuscle: 'Peitoral Inferior & Tríceps',
      muscleCategory: 'chest',
      secondaryMuscles: ['Deltoide Anterior'],
      equipment: 'Peso Corporal',
      images: ['${_imgBase}Chest_Dips/0.jpg', '${_imgBase}Chest_Dips/1.jpg'],
      preparation: 'Segure as barras paralelas, incline o tronco ligeiramente para a frente.',
      execution: 'Desça flexionando os cotovelos até 90° e suba empurrando a barra.',
      safetyTips: ['Mantenha os cotovelos alinhados'],
    ),

    // --- COSTAS (BACK) ---
    Exercise(
      id: 'barbell_bent_over_row',
      name: 'Remada Curvada com Barra',
      targetMuscle: 'Dorsal e Romboide',
      muscleCategory: 'back',
      secondaryMuscles: ['Trapezius', 'Bíceps'],
      equipment: 'Barra',
      images: ['${_imgBase}Barbell_Bent_Over_Row/0.jpg', '${_imgBase}Barbell_Bent_Over_Row/1.jpg'],
      preparation: 'Incline o tronco a 45° mantendo a coluna neutra e joelhos levemente flexionados.',
      execution: 'Puxe a barra em direção ao umbigo contraindo a musculatura dorsal.',
      safetyTips: ['Mantenha o abdômen contraído para proteger a lombar'],
    ),
    Exercise(
      id: 'wide_grip_lat_pulldown',
      name: 'Puxada Aberta no Pulley',
      targetMuscle: 'Latíssimo do Dorso',
      muscleCategory: 'back',
      secondaryMuscles: ['Bíceps', 'Braquial'],
      equipment: 'Polia',
      images: ['${_imgBase}Wide-Grip_Lat_Pulldown/0.jpg', '${_imgBase}Wide-Grip_Lat_Pulldown/1.jpg'],
      preparation: 'Sente-se no aparelho com as pernas presas abaixo dos rolos.',
      execution: 'Puxe a barra em direção ao peitoral superior projetando o tórax.',
      safetyTips: ['Não puxe atrás da cabeça'],
    ),
    Exercise(
      id: 'one_arm_dumbbell_row',
      name: 'Remada Unilateral (Serrote)',
      targetMuscle: 'Dorsal Medial',
      muscleCategory: 'back',
      secondaryMuscles: ['Bíceps'],
      equipment: 'Halteres',
      images: ['${_imgBase}One-Arm_Dumbbell_Row/0.jpg', '${_imgBase}One-Arm_Dumbbell_Row/1.jpg'],
      preparation: 'Apoie o joelho e a mão do mesmo lado em um banco plano.',
      execution: 'Puxe o halter com o braço livre levando o cotovelo em direção ao quadril.',
      safetyTips: ['Não rode o tronco durante o movimento'],
    ),
    Exercise(
      id: 'pullups',
      name: 'Barra Fixa (Pull-ups)',
      targetMuscle: 'Dorsal Completo',
      muscleCategory: 'back',
      secondaryMuscles: ['Bíceps', 'Antebraço'],
      equipment: 'Peso Corporal',
      images: ['${_imgBase}Pullups/0.jpg', '${_imgBase}Pullups/1.jpg'],
      preparation: 'Segure a barra fixa com pegada pronada.',
      execution: 'Puxe o corpo para cima até que o queixo supere a barra.',
      safetyTips: ['Evite usar o balanço do corpo'],
    ),
    Exercise(
      id: 'seated_cable_rows',
      name: 'Remada Baixa no Cabo',
      targetMuscle: 'Romboide & Dorsal',
      muscleCategory: 'back',
      secondaryMuscles: ['Bíceps', 'Trapezius'],
      equipment: 'Polia',
      images: ['${_imgBase}Seated_Cable_Rows/0.jpg', '${_imgBase}Seated_Cable_Rows/1.jpg'],
      preparation: 'Sente-se de frente para a polia baixa com joelhos levemente flexionados.',
      execution: 'Puxe o triângulo até a cintura aproximando as escápulas.',
      safetyTips: ['Mantenha a coluna ereta'],
    ),
    Exercise(
      id: 'hyperextensions',
      name: 'Extensão de Lombar (Hyperextensions)',
      targetMuscle: 'Eretores da Espinha',
      muscleCategory: 'back',
      secondaryMuscles: ['Glúteos', 'Isquiotibiais'],
      equipment: 'Máquina',
      images: ['${_imgBase}Hyperextensions/0.jpg', '${_imgBase}Hyperextensions/1.jpg'],
      preparation: 'Ajuste o suporte do banco romano logo abaixo do quadril.',
      execution: 'Flexione o tronco para baixo e suba até alinhar o corpo com as pernas.',
      safetyTips: ['Não hiper-estenda a coluna no topo'],
    ),

    // --- LEGS / PERNAS ---
    Exercise(
      id: 'barbell_full_squat',
      name: 'Agachamento Livre com Barra',
      targetMuscle: 'Quadríceps & Glúteos',
      muscleCategory: 'legs',
      secondaryMuscles: ['Isquiotibiais', 'Lombar'],
      equipment: 'Barra',
      images: ['${_imgBase}Barbell_Full_Squat/0.jpg', '${_imgBase}Barbell_Full_Squat/1.jpg'],
      preparation: 'Apoie a barra sobre os trapézios com pés na largura dos ombros.',
      execution: 'Agache flexionando quadril e joelhos até as coxas ficarem paralelas ao chão.',
      safetyTips: ['Mantenha os joelhos alinhados às pontas dos pés'],
    ),
    Exercise(
      id: 'leg_press',
      name: 'Leg Press 45°',
      targetMuscle: 'Quadríceps',
      muscleCategory: 'legs',
      secondaryMuscles: ['Glúteos', 'Isquiotibiais'],
      equipment: 'Máquina',
      images: ['${_imgBase}Leg_Press/0.jpg', '${_imgBase}Leg_Press/1.jpg'],
      preparation: 'Posicione os pés no centro da plataforma.',
      execution: 'Desça até formar ângulo de 90° e empurre de volta.',
      safetyTips: ['Não estenda totalmente os joelhos no topo'],
    ),
    Exercise(
      id: 'leg_extensions',
      name: 'Cadeira Extensora',
      targetMuscle: 'Quadríceps (Isolado)',
      muscleCategory: 'legs',
      secondaryMuscles: ['Reto Femoral'],
      equipment: 'Máquina',
      images: ['${_imgBase}Leg_Extensions/0.jpg', '${_imgBase}Leg_Extensions/1.jpg'],
      preparation: 'Ajuste o encosto para manter os joelhos alinhados ao eixo da máquina.',
      execution: 'Estenda os joelhos até a contração máxima e desça devagar.',
      safetyTips: ['Evite usar arrancadas bruscas'],
    ),
    Exercise(
      id: 'lying_leg_curls',
      name: 'Mesa Flexora',
      targetMuscle: 'Isquiotibiais (Posterior de Coxa)',
      muscleCategory: 'legs',
      secondaryMuscles: ['Panturrilhas'],
      equipment: 'Máquina',
      images: ['${_imgBase}Lying_Leg_Curls/0.jpg', '${_imgBase}Lying_Leg_Curls/1.jpg'],
      preparation: 'Deite de bruços apoiando os calcanhares no rolo inferior.',
      execution: 'Flexione os joelhos trazendo o rolo na direção dos glúteos.',
      safetyTips: ['Não descole o quadril do estofado'],
    ),
    Exercise(
      id: 'romanian_deadlift',
      name: 'Stiff / Stiff-Legged Deadlift',
      targetMuscle: 'Isquiotibiais & Glúteo Máximo',
      muscleCategory: 'legs',
      secondaryMuscles: ['Lombar'],
      equipment: 'Barra',
      images: ['${_imgBase}Romanian_Deadlift/0.jpg', '${_imgBase}Romanian_Deadlift/1.jpg'],
      preparation: 'Em pé, segure a barra na largura dos quadris.',
      execution: 'Desça a barra rente às pernas projetando o quadril para trás até sentir o alongamento.',
      safetyTips: ['Mantenha a coluna completamente reta'],
    ),
    Exercise(
      id: 'standing_calf_raises',
      name: 'Gêmeos em Pé (Panturrilhas)',
      targetMuscle: 'Gastrocnêmio & Sóleo',
      muscleCategory: 'legs',
      secondaryMuscles: ['Tíbial'],
      equipment: 'Máquina',
      images: ['${_imgBase}Standing_Calf_Raises/0.jpg', '${_imgBase}Standing_Calf_Raises/1.jpg'],
      preparation: 'Apoie a ponta dos pés no degrau do aparelho.',
      execution: 'Eleve o calcanhar ao máximo e desça bem abaixo da linha do degrau.',
      safetyTips: ['Faça o movimento completo sem dar trancos'],
    ),

    // --- OMBROS (SHOULDERS) ---
    Exercise(
      id: 'dumbbell_shoulder_press',
      name: 'Desenvolvimento com Halteres',
      targetMuscle: 'Deltoide Anterior e Lateral',
      muscleCategory: 'shoulders',
      secondaryMuscles: ['Tríceps', 'Trapezius'],
      equipment: 'Halteres',
      images: ['${_imgBase}Dumbbell_Shoulder_Press/0.jpg', '${_imgBase}Dumbbell_Shoulder_Press/1.jpg'],
      preparation: 'Sente-se ereto segurando os halteres na altura das orelhas.',
      execution: 'Empurre os halteres para cima até estender quase totalmente os braços.',
      safetyTips: ['Mantenha a lombar apoiada'],
    ),
    Exercise(
      id: 'side_lateral_raise',
      name: 'Elevação Lateral',
      targetMuscle: 'Deltoide Lateral',
      muscleCategory: 'shoulders',
      secondaryMuscles: ['Trapezius'],
      equipment: 'Halteres',
      images: ['${_imgBase}Side_Lateral_Raise/0.jpg', '${_imgBase}Side_Lateral_Raise/1.jpg'],
      preparation: 'Fique em pé segurando um halter em cada mão ao lado do corpo.',
      execution: 'Eleve os braços lateralmente até a altura dos ombros.',
      safetyTips: ['Não eleve acima da linha dos ombros'],
    ),
    Exercise(
      id: 'front_dumbbell_raise',
      name: 'Elevação Frontal com Halteres',
      targetMuscle: 'Deltoide Anterior',
      muscleCategory: 'shoulders',
      secondaryMuscles: ['Peitoral Superior'],
      equipment: 'Halteres',
      images: ['${_imgBase}Front_Dumbbell_Raise/0.jpg', '${_imgBase}Front_Dumbbell_Raise/1.jpg'],
      preparation: 'Segure os halteres à frente das coxas.',
      execution: 'Eleve um braço de cada vez à frente do corpo até a linha dos olhos.',
      safetyTips: ['Não balance o quadril'],
    ),

    // --- BRAÇOS (ARMS) ---
    Exercise(
      id: 'barbell_curl',
      name: 'Rosca Direta com Barra',
      targetMuscle: 'Bíceps Braquial',
      muscleCategory: 'arms',
      secondaryMuscles: ['Antebraço'],
      equipment: 'Barra',
      images: ['${_imgBase}Barbell_Curl/0.jpg', '${_imgBase}Barbell_Curl/1.jpg'],
      preparation: 'Em pé, segure a barra na largura dos ombros.',
      execution: 'Flexione os cotovelos trazendo a barra até o peitoral.',
      safetyTips: ['Mantenha os cotovelos fixos ao lado do tronco'],
    ),
    Exercise(
      id: 'hammer_curls',
      name: 'Rosca Martelo',
      targetMuscle: 'Braquiorradial & Bíceps',
      muscleCategory: 'arms',
      secondaryMuscles: ['Antebraço'],
      equipment: 'Halteres',
      images: ['${_imgBase}Hammer_Curls/0.jpg', '${_imgBase}Hammer_Curls/1.jpg'],
      preparation: 'Segure os halteres na pegada neutra (palmas voltadas para dentro).',
      execution: 'Flexione os cotovelos mantendo a pegada neutra durante todo o trajeto.',
      safetyTips: ['Evite usar impulso do corpo'],
    ),
    Exercise(
      id: 'triceps_pushdown',
      name: 'Tríceps Pulley na Polia',
      targetMuscle: 'Tríceps Braquial',
      muscleCategory: 'arms',
      secondaryMuscles: ['Ancôneo'],
      equipment: 'Polia',
      images: ['${_imgBase}Triceps_Pushdown/0.jpg', '${_imgBase}Triceps_Pushdown/1.jpg'],
      preparation: 'Mantenha os cotovelos colados ao corpo.',
      execution: 'Empurre a barra para baixo até estender totalmente os braços.',
      safetyTips: ['Não incline o peso do corpo sobre a barra'],
    ),
    Exercise(
      id: 'ez_bar_skullcrusher',
      name: 'Tríceps Testa com Barra W',
      targetMuscle: 'Tríceps (Cabeça Longa)',
      muscleCategory: 'arms',
      secondaryMuscles: ['Ancôneo'],
      equipment: 'Barra',
      images: ['${_imgBase}EZ-Bar_Skullcrusher/0.jpg', '${_imgBase}EZ-Bar_Skullcrusher/1.jpg'],
      preparation: 'Deite-se no banco com a barra W estendida sobre os ombros.',
      execution: 'Flexione apenas os cotovelos levando a barra na direção da testa.',
      safetyTips: ['Mantenha os cotovelos apontados para cima'],
    ),

    // --- ABDÔMEN & CARDIO ---
    Exercise(
      id: 'air_bike',
      name: 'Abdominal Bicicleta',
      targetMuscle: 'Reto Abdominal e Oblíquos',
      muscleCategory: 'abs',
      secondaryMuscles: ['Flexores do Quadril'],
      equipment: 'Peso Corporal',
      images: ['${_imgBase}Air_Bike/0.jpg', '${_imgBase}Air_Bike/1.jpg'],
      preparation: 'Deite de costas no chão com as mãos atrás da cabeça.',
      execution: 'Alterne cotovelos e joelhos opostos em movimento contínuo.',
      safetyTips: ['Não puxe o pescoço com as mãos'],
    ),
    Exercise(
      id: 'treadmill_running',
      name: 'Corrida na Esteira',
      targetMuscle: 'Cardiorrespiratório',
      muscleCategory: 'cardio',
      secondaryMuscles: ['Quadríceps', 'Panturrilhas'],
      equipment: 'Máquina',
      images: ['${_imgBase}Treadmill_Running/0.jpg', '${_imgBase}Treadmill_Running/1.jpg'],
      preparation: 'Ajuste a velocidade desejada.',
      execution: 'Corra mantendo a postura vertical.',
      safetyTips: ['Use calçado com amortecimento adequado'],
    ),
  ];

  static final List<Exercise> _customUserExercises = [];

  /// Permite ao usuário cadastrar exercícios próprios customizados no Firestore
  Future<void> createCustomExercise(Exercise newExercise) async {
    _customUserExercises.add(newExercise);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !kIsWeb) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('custom_exercises')
            .doc(newExercise.id)
            .set(newExercise.toJson());
      } catch (e) {
        debugPrint('Erro ao salvar exercício customizado no Firestore: $e');
      }
    }
  }

  Future<List<Exercise>> getExercises({String? category, String? equipment, String? query}) async {
    final combinedList = [..._exerciseDatabase, ..._customUserExercises];

    return combinedList.where((item) {
      bool matchesCategory = true;
      if (category != null && category.isNotEmpty && category != 'all') {
        final cat = category.toLowerCase();
        if (cat == 'back' || cat == 'costas') matchesCategory = item.muscleCategory == 'back';
        else if (cat == 'chest' || cat == 'peito') matchesCategory = item.muscleCategory == 'chest';
        else if (cat == 'legs' || cat == 'pernas') matchesCategory = item.muscleCategory == 'legs';
        else if (cat == 'shoulders' || cat == 'ombros') matchesCategory = item.muscleCategory == 'shoulders';
        else if (cat == 'arms' || cat == 'bracos') matchesCategory = item.muscleCategory == 'arms';
        else if (cat == 'abs' || cat == 'abdomen') matchesCategory = item.muscleCategory == 'abs';
        else if (cat == 'cardio') matchesCategory = item.muscleCategory == 'cardio';
        else matchesCategory = item.muscleCategory == cat;
      }

      bool matchesEquipment = true;
      if (equipment != null && equipment.isNotEmpty && equipment != 'all') {
        final eq = equipment.toLowerCase();
        if (eq == 'barbell' || eq == 'barra') matchesEquipment = item.equipment.toLowerCase().contains('barra');
        else if (eq == 'dumbbell' || eq == 'halteres') matchesEquipment = item.equipment.toLowerCase().contains('halter');
        else if (eq == 'cable' || eq == 'polia') matchesEquipment = item.equipment.toLowerCase().contains('polia');
        else if (eq == 'machine' || eq == 'maquina') matchesEquipment = item.equipment.toLowerCase().contains('máquina') || item.equipment.toLowerCase().contains('maquina');
        else if (eq == 'bodyweight' || eq == 'peso corporal') matchesEquipment = item.equipment.toLowerCase().contains('corporal');
        else matchesEquipment = item.equipment.toLowerCase().contains(eq);
      }

      bool matchesQuery = true;
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        matchesQuery = item.name.toLowerCase().contains(q) ||
            item.targetMuscle.toLowerCase().contains(q) ||
            item.equipment.toLowerCase().contains(q);
      }

      return matchesCategory && matchesEquipment && matchesQuery;
    }).toList();
  }

  Future<List<ExerciseSetLog>> getExerciseHistory(String exerciseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !kIsWeb) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('exercise_logs')
            .doc(exerciseId)
            .collection('sets')
            .orderBy('date', descending: true)
            .get();

        return snapshot.docs
            .map((doc) => ExerciseSetLog.fromJson(doc.data(), doc.id))
            .toList();
      } catch (e) {
        debugPrint('Erro no Firestore: $e');
      }
    }
    return [];
  }

  Future<void> addExerciseLog(String exerciseId, double weightKg, int reps, int durationSeconds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !kIsWeb) {
      try {
        final log = ExerciseSetLog(
          id: '',
          date: DateTime.now(),
          weightKg: weightKg,
          reps: reps,
          durationSeconds: durationSeconds,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('exercise_logs')
            .doc(exerciseId)
            .collection('sets')
            .add(log.toJson());
      } catch (e) {
        debugPrint('Erro ao salvar no Firestore: $e');
      }
    }
  }
}