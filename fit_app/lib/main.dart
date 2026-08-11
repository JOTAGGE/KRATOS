import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Telas
import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'services/profile_service.dart';
import 'services/auth_service.dart';

import 'screens/exercise_list_screen.dart';
import 'screens/random_workout_screen.dart';
import 'screens/timers_screen.dart';
import 'screens/history_fatigue_screen.dart';
import 'screens/body_metrics_screen.dart';
import 'screens/health_sync_screen.dart';
import 'services/routine_service.dart';
import 'models/routine_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Erro na inicialização do Firebase: $e');
  }

  runApp(const FitApp());
}

class FitApp extends StatefulWidget {
  const FitApp({super.key});

  @override
  State<FitApp> createState() => _FitAppState();
}

class _FitAppState extends State<FitApp> {
  bool _showOnboarding = true;

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService();

    return AnimatedBuilder(
      animation: profileService,
      builder: (context, _) {
        final profile = profileService.profile;

        return MaterialApp(
          title: 'Kratos Fit',
          debugShowCheckedModeBanner: false,
          theme: profileService.getThemeData(false),
          darkTheme: profileService.getThemeData(true),
          themeMode: profile.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: _showOnboarding
              ? OnboardingScreen(
                  onFinish: () => setState(() => _showOnboarding = false),
                )
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      return const HomeScreen();
                    }

                    return const AuthScreen();
                  },
                ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoutineService _routineService = RoutineService();
  WorkoutRoutine? _todayWorkout;

  @override
  void initState() {
    super.initState();
    // Carrega os dados reais do perfil e o treino do dia de forma segura e uma única vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileService().loadProfile();
      _loadTodayWorkout();
    });
  }

  void _loadTodayWorkout() async {
    final routines = await _routineService.getRoutines();
    if (mounted) {
      setState(() {
        _todayWorkout = _routineService.getTodayWorkout(routines);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final profile = ProfileService().profile;
    final theme = Theme.of(context);

    final displayName = profile.name.isNotEmpty && profile.name != 'Carregando...'
        ? profile.name
        : (user?.displayName ?? "Atleta");
    final displayNickname = profile.nickname.isNotEmpty
        ? profile.nickname
        : (user?.email ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kratos Fit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair da Conta',
            onPressed: () async {
              ProfileService().clearProfile();
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, $displayName!',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              displayNickname,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 16),

            // Card do Treino do Dia
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.today, color: theme.colorScheme.onPrimaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          'SUGESTÃO PARA HOJE',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _todayWorkout != null ? _todayWorkout!.name : 'Nenhum treino agendado para hoje',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: Text(_todayWorkout != null ? 'Iniciar Treino do Dia' : 'Gerar Treino Express'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RandomWorkoutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Recursos & Ferramentas', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline, size: 32),
                title: const Text('Meu Perfil & Configurações'),
                subtitle: const Text('Personalizar temas, idioma e dados da conta'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shuffle, size: 32),
                title: const Text('Gerador de Treino Express'),
                subtitle: const Text('Gere fichas instantâneas por tempo e músculo'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RandomWorkoutScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.timer, size: 32),
                title: const Text('Cronômetros Atletas'),
                subtitle: const Text('AMRAP, EMOM, TABATA e FOR TIME'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TimersScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.fitness_center, size: 32),
                title: const Text('Biblioteca de Exercícios'),
                subtitle: const Text('GIFs, demonstrações e grupos musculares'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExerciseListScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart, size: 32),
                title: const Text('Histórico & Fadiga Muscular'),
                subtitle: const Text('Mapa visual de recuperação biológica'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryFatigueScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.monitor_weight, size: 32),
                title: const Text('Medidas Corporais & Progresso'),
                subtitle: const Text('Peso, IMC, Bioimpedância e Circunferências'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BodyMetricsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite, size: 32, color: Colors.redAccent),
                title: const Text('Conectividade de Saúde'),
                subtitle: const Text('Health Connect & Google Fit'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HealthSyncScreen()),
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