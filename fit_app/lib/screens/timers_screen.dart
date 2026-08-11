import 'dart:async';
import 'package:flutter/material.dart';

enum TimerMode { amrap, emom, tabata, forTime }

class TimersScreen extends StatefulWidget {
  final TimerMode initialMode;
  const TimersScreen({super.key, this.initialMode = TimerMode.tabata});

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  late TimerMode _currentMode;

  // Configurações do Timer
  int _workTimeSeconds = 20; // Tempo de Exercício (Tabata)
  int _restTimeSeconds = 10; // Tempo de Descanso (Tabata)
  int _totalRounds = 8;       // Rodadas (Tabata / EMOM)
  int _targetMinutes = 10;    // Tempo Limite (AMRAP / For Time)

  // Estado do Cronômetro Ativo
  Timer? _timer;
  int _secondsRemaining = 0;
  int _secondsElapsed = 0;
  int _currentRound = 1;
  bool _isWorkPhase = true; // True = Exercício, False = Descanso
  bool _isRunning = false;
  bool _isPaused = false;
  int _completedRoundsAMRAP = 0;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentRound = 1;
      _isWorkPhase = true;
      _secondsElapsed = 0;
      _completedRoundsAMRAP = 0;

      switch (_currentMode) {
        case TimerMode.tabata:
          _secondsRemaining = _workTimeSeconds;
          break;
        case TimerMode.emom:
          _secondsRemaining = 60;
          break;
        case TimerMode.amrap:
          _secondsRemaining = _targetMinutes * 60;
          break;
        case TimerMode.forTime:
          _secondsRemaining = _targetMinutes * 60;
          break;
      }
    });
  }

  void _startTimer() {
    if (_isRunning && !_isPaused) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _secondsElapsed++;

        switch (_currentMode) {
          case TimerMode.tabata:
            if (_secondsRemaining > 1) {
              _secondsRemaining--;
            } else {
              if (_isWorkPhase) {
                // Fim do tempo de trabalho -> Vai para descanso
                _isWorkPhase = false;
                _secondsRemaining = _restTimeSeconds;
              } else {
                // Fim do descanso -> Próxima rodada
                if (_currentRound < _totalRounds) {
                  _currentRound++;
                  _isWorkPhase = true;
                  _secondsRemaining = _workTimeSeconds;
                } else {
                  _finishWorkout();
                }
              }
            }
            break;

          case TimerMode.emom:
            if (_secondsRemaining > 1) {
              _secondsRemaining--;
            } else {
              if (_currentRound < _totalRounds) {
                _currentRound++;
                _secondsRemaining = 60;
              } else {
                _finishWorkout();
              }
            }
            break;

          case TimerMode.amrap:
            if (_secondsRemaining > 1) {
              _secondsRemaining--;
            } else {
              _finishWorkout();
            }
            break;

          case TimerMode.forTime:
            _secondsElapsed++;
            break;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _finishWorkout() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🔥 Treino Concluído!'),
        content: Text(
          _currentMode == TimerMode.amrap
              ? 'Você completou $_completedRoundsAMRAP rodadas em $_targetMinutes min!'
              : 'Excelente trabalho! Mantenha a constância.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetTimer();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getStatusColor() {
      if (!_isRunning) return theme.colorScheme.primary;
      if (_currentMode == TimerMode.tabata) {
        return _isWorkPhase ? Colors.redAccent : Colors.green;
      }
      return theme.colorScheme.primary;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronômetros de Atletas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Seletor do Modo de Treino
            SegmentedButton<TimerMode>(
              segments: const [
                ButtonSegment(value: TimerMode.tabata, label: Text('TABATA')),
                ButtonSegment(value: TimerMode.emom, label: Text('EMOM')),
                ButtonSegment(value: TimerMode.amrap, label: Text('AMRAP')),
                ButtonSegment(value: TimerMode.forTime, label: Text('FOR TIME')),
              ],
              selected: {_currentMode},
              onSelectionChanged: (Set<TimerMode> selection) {
                setState(() {
                  _currentMode = selection.first;
                  _resetTimer();
                });
              },
            ),
            const SizedBox(height: 32),

            // Visualizador Principal do Cronômetro (Display Estilo Atleta)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: getStatusColor().withAlpha(30),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: getStatusColor(), width: 3),
              ),
              child: Column(
                children: [
                  if (_currentMode == TimerMode.tabata && _isRunning)
                    Text(
                      _isWorkPhase ? '🔥 EXERCÍCIO' : '☕ DESCANSO',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    _currentMode == TimerMode.forTime
                        ? _formatTime(_secondsElapsed)
                        : _formatTime(_secondsRemaining),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (_currentMode == TimerMode.tabata || _currentMode == TimerMode.emom)
                    Text(
                      'Rodada $_currentRound de $_totalRounds',
                      style: theme.textTheme.titleLarge,
                    ),

                  if (_currentMode == TimerMode.amrap) ...[
                    Text(
                      'Rodadas Completas: $_completedRoundsAMRAP',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Contar +1 Rodada'),
                      onPressed: _isRunning
                          ? () => setState(() => _completedRoundsAMRAP++)
                          : null,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botões de Controle do Cronômetro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.large(
                  heroTag: 'btnStart',
                  backgroundColor: _isRunning && !_isPaused ? Colors.amber : Colors.green,
                  onPressed: () {
                    if (_isRunning && !_isPaused) {
                      _pauseTimer();
                    } else {
                      _startTimer();
                    }
                  },
                  child: Icon(
                    _isRunning && !_isPaused ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                ),
                FloatingActionButton.large(
                  heroTag: 'btnReset',
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  onPressed: _resetTimer,
                  child: const Icon(Icons.refresh, size: 36),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Configurações Ajustáveis quando parado
            if (!_isRunning) ...[
              const Divider(),
              const SizedBox(height: 16),
              Text('Ajustar Parâmetros', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),

              if (_currentMode == TimerMode.tabata) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _workTimeSeconds.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Exercício (s)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => _workTimeSeconds = int.tryParse(v) ?? 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: _restTimeSeconds.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Descanso (s)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => _restTimeSeconds = int.tryParse(v) ?? 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              if (_currentMode == TimerMode.tabata || _currentMode == TimerMode.emom)
                TextFormField(
                  initialValue: _totalRounds.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total de Rodadas',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => _totalRounds = int.tryParse(v) ?? 8,
                ),

              if (_currentMode == TimerMode.amrap || _currentMode == TimerMode.forTime)
                TextFormField(
                  initialValue: _targetMinutes.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tempo Cap (Minutos)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => _targetMinutes = int.tryParse(v) ?? 10,
                ),
            ],
          ],
        ),
      ),
    );
  }
}