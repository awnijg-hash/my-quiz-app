import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسابقة التيك توك الاحترافية',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1D),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
        ),
      ),
      home: const MainQuizController(),
    );
  }
}

class Player {
  String name;
  int score;
  Player({required this.name, this.score = 0});
}

class MainQuizController extends StatefulWidget {
  const MainQuizController({super.key});

  @override
  State<MainQuizController> createState() => _MainQuizControllerState();
}

class _MainQuizControllerState extends State<MainQuizController> {
  bool isGameStarted = false;
  int totalQuestionsInRound = 10;
  int timePerQuestion = 30;
  String player1Name = "المتحدي 1";
  String player2Name = "المتحدي 2";

  void startGame(int questions, int time, String p1, String p2) {
    setState(() {
      totalQuestionsInRound = questions;
      timePerQuestion = time;
      player1Name = p1.trim().isEmpty ? "المتحدي 1" : p1;
      player2Name = p2.trim().isEmpty ? "المتحدي 2" : p2;
      isGameStarted = true;
    });
  }

  void resetToSettings() {
    setState(() {
      isGameStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isGameStarted
        ? QuizScreen(
            totalQuestions: totalQuestionsInRound,
            questionTime: timePerQuestion,
            p1Name: player1Name,
            p2Name: player2Name,
            onReset: resetToSettings,
          )
        : SettingsScreen(onStart: startGame);
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(int, int, String, String) onStart;
  const SettingsScreen({super.key, required this.onStart});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedQuestions = 20;
  int _selectedTime = 30;
  final TextEditingController _p1Controller =
      TextEditingController(text: "المتحدي 1");
  final TextEditingController _p2Controller =
      TextEditingController(text: "المتحدي 2");

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  '🔥 إعدادات البطولة 🔥',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 30),
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('👥 أسماء المتنافسين (1v1)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent)),
                      const SizedBox(height: 15),
                      _buildTextField(
                          _p1Controller, 'اسم المتسابق الأول', Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(_p2Controller, 'اسم المتسابق الثاني',
                          Icons.person_outline),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📊 عدد أسئلة الجولة',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [10, 20, 50, 100].map((count) {
                          bool isSel = _selectedQuestions == count;
                          return InkWell(
                            onTap: () =>
                                setState(() => _selectedQuestions = count),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? Colors.amber
                                    : const Color(0x1AFFFFFF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                    color: isSel ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('⏱️ وقت السؤال الواحد: $_selectedTime ثانية',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent)),
                      Slider(
                        value: _selectedTime.toDouble(),
                        min: 10,
                        max: 60,
                        divisions: 10,
                        activeColor: Colors.amber,
                        inactiveColor: const Color(0x33FFFFFF),
                        onChanged: (val) =>
                            setState(() => _selectedTime = val.toInt()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700]!,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 8,
                    shadowColor: Colors.greenAccent.withAlpha(102),
                  ),
                  onPressed: () {
                    SystemSound.play(SystemSoundType.click);
                    widget.onStart(_selectedQuestions, _selectedTime,
                        _p1Controller.text, _p2Controller.text);
                  },
                  child: const Text('🚀 ابدأ التحدي المباشر الآن',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1FFFFFFF), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.amber),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0x10FFFFFF),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final int totalQuestions;
  final int questionTime;
  final String p1Name;
  final String p2Name;
  final VoidCallback onReset;

  const QuizScreen({
    super.key,
    required this.totalQuestions,
    required this.questionTime,
    required this.p1Name,
    required this.p2Name,
    required this.onReset,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  List<dynamic> allQuestions = [];
  List<dynamic> remainingQuestions = [];
  Map<String, dynamic>? currentQuestion;
  int currentQuestionIndex = 0;
  bool isLoading = true;

  late List<Player> players;
  int? winningPlayerIndex;

  Timer? _timer;
  int _timerSeconds = 30;

  late AnimationController _bgController;
  late Animation<Alignment> _alignmentTop;
  late Animation<Alignment> _alignmentBottom;

  // انيميشن مخصص لوامض الإجابة الصحيحة عند الصفر
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  int? selectedOptionIndex;
  bool hasAnswered = false;
  bool isTimeout = false;

  @override
  void initState() {
    super.initState();
    _timerSeconds = widget.questionTime;
    players = [Player(name: widget.p1Name), Player(name: widget.p2Name)];

    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat(reverse: true);
    _alignmentTop = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween:
              AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_bgController);

    _alignmentBottom = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem(
          tween:
              AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_bgController);

    // إعدادات وميض زر الإجابة الصحيحة
    _blinkController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _blinkAnimation =
        Tween<double>(begin: 1.0, end: 0.2).animate(_blinkController);

    loadQuestionsFromAsset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bgController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  void _playClickSound() => SystemSound.play(SystemSoundType.click);

  void _playTickSound() {
    if (_timerSeconds <= 5) {
      SystemChannels.platform.invokeMethod('HapticFeedback.vibrate');
    }
  }

  void _playSoundFeedback(bool success) {
    if (success) {
      HapticFeedback.vibrate();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void startTimer() {
    _timer?.cancel();
    _blinkController.stop();
    _blinkController.reset();
    setState(() {
      _timerSeconds = widget.questionTime;
      hasAnswered = false;
      isTimeout = false;
      selectedOptionIndex = null;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
        _playTickSound();
      } else {
        _timer?.cancel();
        _revealCorrectAnswerTimeout();
      }
    });
  }

  void _revealCorrectAnswerTimeout() {
    _playSoundFeedback(false);
    setState(() {
      hasAnswered = true;
      isTimeout = true;
      selectedOptionIndex = null;
    });
    _blinkController.repeat(reverse: true); // بدء الوميض المتكرر فوراً
  }

  Future<void> loadQuestionsFromAsset() async {
    try {
      String jsonString = await rootBundle.loadString('assets/questions.json');
      List<dynamic> loadedData = jsonDecode(jsonString);
      setState(() {
        allQuestions = loadedData;
        remainingQuestions = List.from(allQuestions)..shuffle();
        if (remainingQuestions.isNotEmpty) {
          currentQuestion = remainingQuestions.removeAt(0);
          currentQuestionIndex = 1;
          startTimer();
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void checkAnswer(int index) {
    if (hasAnswered) return;
    _playClickSound();
    setState(() {
      selectedOptionIndex = index;
      hasAnswered = true;
      _timer?.cancel();
    });

    bool isCorrect = (index == currentQuestion!['correct']);
    _playSoundFeedback(isCorrect);
  }

  void nextQuestion() {
    _playClickSound();
    if (currentQuestionIndex >= widget.totalQuestions ||
        remainingQuestions.isEmpty) {
      _showRoundEndDialog();
      return;
    }
    setState(() {
      if (remainingQuestions.isNotEmpty) {
        currentQuestion = remainingQuestions.removeAt(0);
        currentQuestionIndex++;
        startTimer();
      }
    });
  }

  // ميزة الـ Shuffle وإعادة الجولة السريعة من فوق
  void _shuffleAndRestartRound() {
    _playClickSound();
    setState(() {
      isLoading = true;
      remainingQuestions = List.from(allQuestions)..shuffle();
      for (var p in players) {
        p.score = 0;
      }
      if (remainingQuestions.isNotEmpty) {
        currentQuestion = remainingQuestions.removeAt(0);
        currentQuestionIndex = 1;
        startTimer();
      }
      isLoading = false;
    });
  }

  // ميزة تعديل اسم المتسابق حياً أثناء اللعب
  void _editPlayerName(int index) {
    TextEditingController nameEditController =
        TextEditingController(text: players[index].name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2C),
        title: const Text('✏️ تعديل اسم المتسابق',
            style: TextStyle(color: Colors.amber)),
        content: TextField(
          controller: nameEditController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              if (nameEditController.text.trim().isNotEmpty) {
                setState(() {
                  players[index].name = nameEditController.text.trim();
                });
              }
              Navigator.pop(context);
            },
            child:
                const Text('حفظ', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  void _handleScoreIncrement(int playerIndex) {
    _playSoundFeedback(true);
    setState(() {
      players[playerIndex].score++;
      winningPlayerIndex = playerIndex;
    });
    Timer(const Duration(seconds: 1), () {
      setState(() {
        winningPlayerIndex = null;
      });
    });
  }

  void _handleScoreDecrement(int playerIndex) {
    if (players[playerIndex].score > 0) {
      _playSoundFeedback(false);
      setState(() {
        players[playerIndex].score--;
      });
    }
  }

  void _showRoundEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('🏁 جولة ممتعة!',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.amber)),
        content: Text(
          'النتيجة النهائية:\n'
          '${players[0].name}: ${players[0].score} نقطة\n'
          '${players[1].name}: ${players[1].score} نقطة',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onReset();
            },
            child: const Text('العودة للإعدادات',
                style: TextStyle(color: Colors.cyanAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.amber)));
    }

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _alignmentTop.value,
                end: _alignmentBottom.value,
                colors: const [
                  Color(0xFF0A1128),
                  Color(0xFF001F11),
                  Color(0xFF1C0A26),
                ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // كابينة التحكم العلوية مع زر إعادة التدوير والـ Shuffle
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 2.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white70, size: 20),
                      onPressed: widget.onReset,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.loop,
                              color: Colors.cyanAccent, size: 24),
                          tooltip: 'إعادة خلط الجولة',
                          onPressed: _shuffleAndRestartRound,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0x33FFC107),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber, width: 1),
                          ),
                          child: Text(
                            'السؤال: $currentQuestionIndex / ${widget.totalQuestions}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // الرفع والضغط للأعلى لحسابات وواجهات الخانات المعدنية الدائرية
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (index) {
                    final p = players[index];
                    bool isGlowing = (winningPlayerIndex == index);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // كليك على اسم اللاعب لتعديله مباشرة حياً
                        InkWell(
                          onTap: () => _editPlayerName(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amberAccent),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 3),
                                const Icon(Icons.edit,
                                    size: 12, color: Colors.white54),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        GestureDetector(
                          onTap: () => _handleScoreIncrement(index),
                          onDoubleTap: () => _handleScoreDecrement(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey[300]!,
                                  Colors.grey[500]!,
                                  Colors.grey[700]!,
                                  Colors.grey[400]!,
                                ],
                                stops: const [0.1, 0.4, 0.6, 0.9],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isGlowing
                                      ? Colors.cyanAccent.withAlpha(229)
                                      : Colors.black.withAlpha(153),
                                  offset: const Offset(3, 3),
                                  blurRadius: isGlowing ? 25 : 6,
                                  spreadRadius: isGlowing ? 5 : 1,
                                ),
                              ],
                              border: Border.all(
                                  color: isGlowing
                                      ? Colors.cyanAccent
                                      : Colors.grey[400]!,
                                  width: isGlowing ? 2.5 : 1),
                            ),
                            child: Center(
                              child: Text(
                                '${p.score}',
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D47A1),
                                  fontFamily: 'monospace',
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          value: _timerSeconds / widget.questionTime,
                          strokeWidth: 4,
                          backgroundColor: const Color(0x22FFFFFF),
                          color: _timerSeconds <= 5
                              ? Colors.red
                              : Colors.greenAccent,
                        ),
                      ),
                      Text(
                        '$_timerSeconds',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                _timerSeconds <= 5 ? Colors.red : Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // سحب خانة السؤال للأعلى لترك مساحة سفلية ضخمة للخيارات
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (currentQuestion != null) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0x25FFFFFF),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.amber.withAlpha(76), width: 1.2),
                          ),
                          child: Text(
                            currentQuestion!['question'] ?? '',
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                (currentQuestion!['options'] as List<dynamic>)
                                    .length,
                            itemBuilder: (context, idx) {
                              String optionText =
                                  currentQuestion!['options'][idx].toString();

                              Color buttonBorderColor = const Color(0x22FFFFFF);
                              Color? buttonBgColor = const Color(0x1AFFFFFF);
                              bool shouldBlink = false;

                              if (hasAnswered) {
                                if (idx == currentQuestion!['correct']) {
                                  buttonBorderColor = Colors.greenAccent;
                                  buttonBgColor =
                                      Colors.green[900]?.withAlpha(150);
                                  if (isTimeout) {
                                    shouldBlink =
                                        true; // تفعيل لقطة الوميض للإجابة الصحيحة عند الصفر
                                  }
                                } else if (idx == selectedOptionIndex) {
                                  buttonBorderColor = Colors.redAccent;
                                  buttonBgColor =
                                      Colors.red[900]?.withAlpha(150);
                                }
                              }

                              Widget buttonChild = ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonBgColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                      color: buttonBorderColor,
                                      width: hasAnswered ? 2.5 : 1.2),
                                  elevation: hasAnswered &&
                                          (idx == currentQuestion!['correct'] ||
                                              idx == selectedOptionIndex)
                                      ? 6
                                      : 0,
                                ),
                                onPressed: () => checkAnswer(idx),
                                child: Text(
                                  optionText,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              );

                              // تطبيق تأثير الانيميشن الخاص بالوميض (Opacity Blinking)
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: shouldBlink
                                    ? AnimatedBuilder(
                                        animation: _blinkAnimation,
                                        builder: (context, child) {
                                          return Opacity(
                                            opacity: _blinkAnimation.value,
                                            child: buttonChild,
                                          );
                                        },
                                      )
                                    : buttonChild,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0, top: 2.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: nextQuestion,
                  icon: const Icon(Icons.skip_next, size: 22),
                  label: const Text('السؤال التالي ➡️',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
