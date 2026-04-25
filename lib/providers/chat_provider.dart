import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
import '../models/question_model.dart';
import '../services/ai_service.dart';

final chatTypingProvider = StateProvider<bool>((ref) => false);

final feedbackSubmittedProvider = StateProvider<bool>((ref) => false);

final chatProvider = StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  return ChatNotifier(ref, AiService());
});

class ChatNotifier extends StateNotifier<List<Message>> {
  ChatNotifier(this._ref, this._aiService) : super(const []) {
    flowState = 'ONBOARDING';
    currentStep = 0;
    setTyping(false);
    _seedInitialMessages();
  }

  final Ref _ref;
  final AiService _aiService;

  int currentStep = 0;
  String flowState = 'ONBOARDING';
  String currentTest = 'RIASEC';
  int currentQuestionIndex = 0;
  String? participantId;
  String experimentGroup = 'B';

  String studentName = '';
  String school = '';
  String department = '';
  String currentGoal = '';

  final List<Map<String, dynamic>> testAnswers = [];

  static const Duration _typingDelay = Duration(milliseconds: 850);
  static const Duration _shortDelay = Duration(milliseconds: 500);
  static const Duration _testIntroDelay = Duration(milliseconds: 900);
  static const Duration _nextQuestionDelay = Duration(milliseconds: 820);
  static const Duration _optionDelay = Duration(milliseconds: 560);
  static const Duration _transitionDelay = Duration(milliseconds: 900);

  Future<void> _seedInitialMessages() async {
    await Future<void>.delayed(_shortDelay);
    addAiMessage(
      'Merhaba! Ben Kariyer Mimarı AI. TÜBİTAK 2209-A kapsamında geliştirilen bu platform, ilgi ve kişilik testlerini yapay zeka ile sentezleyerek sana en uygun bilişim kariyerini çizer. (Teste başlayarak akademik aydınlatma metnini onaylamış sayılırsın).',
    );
    await Future<void>.delayed(_shortDelay);
    addAiMessage('Başlamadan önce seni tanıyalım, adın nedir?');
  }

  List<QuestionModel> get _riasecQuestions => riasecQuestions;
  List<QuestionModel> get _oceanQuestions => oceanQuestions;

  void addUserMessage(String content) {
    state = [...state, Message(role: MessageRole.user, content: content)];
  }

  void addAiMessage(String content, {bool isMarkdown = false}) {
    state = [
      ...state,
      Message(role: MessageRole.ai, content: content, isMarkdown: isMarkdown),
    ];
  }

  Future<void> handleUserInput(String input) async {
    addUserMessage(input);

    if (flowState != 'ONBOARDING') {
      return;
    }

    setTyping(true);
    await Future<void>.delayed(_typingDelay);
    setTyping(false);

    switch (currentStep) {
      case 0:
        studentName = input;
        addAiMessage('Memnun oldum $input. Hangi okulda okuyorsun?');
        currentStep += 1;
        break;
      case 1:
        school = input;
        addAiMessage('Anladım. Peki hangi bölümde okuyorsun?');
        currentStep += 1;
        break;
      case 2:
        department = input;
        addAiMessage(
          'Süper. Son olarak, kariyer hedefin veya en büyük hayalin nedir?',
        );
        currentStep += 1;
        break;
      case 3:
        currentGoal = input;
        addAiMessage('Harika! Bilgilerini kaydediyorum, lütfen bekle...');
        setTyping(true);
        await Future<void>.delayed(_transitionDelay);
        setTyping(false);
        try {
          await _createParticipant();
          addAiMessage('Kaydını başarıyla aldım. Şimdi teste geçiyoruz.');
        } catch (error) {
          addAiMessage(
            'Kayıt sırasında sorun oldu, yine de teste devam ediyoruz.',
          );
        }
        await Future<void>.delayed(_transitionDelay);
        await startTestFlow();
        break;
      default:
        break;
    }
  }

  Future<void> startTestFlow() async {
    flowState = 'TEST_INTRO';
    setTyping(true);
    await Future<void>.delayed(_testIntroDelay);
    setTyping(false);
    addAiMessage(
      'Kısa bir ilgi ve kişilik testi başlatıyorum. Hazırsan sorular geliyor.',
    );

    setTyping(true);
    await Future<void>.delayed(_nextQuestionDelay);
    setTyping(false);

    flowState = 'TESTING';
    currentTest = 'RIASEC';
    currentQuestionIndex = 0;
    _askNextQuestion();
  }

  Future<void> submitAnswer(bool value) async {
    if (flowState != 'TESTING') return;

    final questions = currentTest == 'RIASEC'
        ? _riasecQuestions
        : _oceanQuestions;
    if (currentQuestionIndex >= questions.length) return;

    final currentQuestion = questions[currentQuestionIndex];
    testAnswers.add({
      'test': currentQuestion.test,
      'id': currentQuestion.id,
      'type': currentQuestion.type,
      'answer': value,
    });

    addUserMessage(value ? 'Evet, katılıyorum' : 'Hayır, katılmıyorum');
    currentQuestionIndex += 1;

    setTyping(true);
    await Future<void>.delayed(_optionDelay);
    setTyping(false);

    _askNextQuestion();
  }

  void _askNextQuestion() {
    final questions = currentTest == 'RIASEC'
        ? _riasecQuestions
        : _oceanQuestions;

    if (currentQuestionIndex < questions.length) {
      final total = _riasecQuestions.length + _oceanQuestions.length;
      var stepNo = currentQuestionIndex + 1;
      if (currentTest == 'OCEAN') {
        stepNo += _riasecQuestions.length;
      }

      final question = questions[currentQuestionIndex];
      addAiMessage('Soru $stepNo/$total: ${question.text}');
      return;
    }

    if (currentTest == 'RIASEC') {
      currentTest = 'OCEAN';
      currentQuestionIndex = 0;
      addAiMessage('Harika. Şimdi kişilik envanteri bölümüne geçiyoruz.');
      _transitionToNextSection();
      return;
    }

    flowState = 'ANALYZING';
    addAiMessage('Tüm testi tamamladın. Cevaplarını analiz ediyorum...');
    _completeTestFlow();
  }

  Future<void> _transitionToNextSection() async {
    setTyping(true);
    await Future<void>.delayed(_transitionDelay);
    setTyping(false);
    _askNextQuestion();
  }

  Future<void> _completeTestFlow() async {
    setTyping(true);
    try {
      final result = await _submitTestResults();
      final report = result['report']?.toString() ?? '';
      final isGroupA = result['isGroupA'] == true;

      if (report.isEmpty) {
        throw Exception('Rapor boş döndü.');
      }

      setTyping(false);

      if (isGroupA) {
        addAiMessage('Harika! Sonuçların hazır.');
        addAiMessage(report, isMarkdown: true);
        flowState = 'AI_UNLOCK';
        _askAiUnlock();
        return;
      }

      addAiMessage('Harika! Sonuçların hazır.');
      addAiMessage(report, isMarkdown: true);
      flowState = 'FEEDBACK';
      _askFeedback();
    } catch (error) {
      setTyping(false);
      addAiMessage(
        'Analiz sonucu alınamadı. Lütfen bağlantınızı kontrol edip tekrar deneyin.',
      );
      flowState = 'FEEDBACK';
      _askFeedback();
    }
  }

  Future<void> _generateAiReport() async {
    setTyping(true);
    try {
      if (participantId == null) {
        throw Exception('participantId bulunamadı.');
      }

      final response = await _aiService.unlockAiReport(
        participantId: participantId!,
      );
      final aiResponse = response['report']?.toString() ?? '';

      if (aiResponse.isEmpty) {
        throw Exception('AI raporu boş döndü.');
      }

      setTyping(false);
      addAiMessage('Harika! Sonuçların hazır.');
      addAiMessage(aiResponse, isMarkdown: true);
      flowState = 'FEEDBACK';
      _askFeedback();
    } catch (error) {
      setTyping(false);
      addAiMessage('AI raporu oluşturulamadı. Lütfen tekrar deneyin.');
      flowState = 'FEEDBACK';
      _askFeedback();
    }
  }

  Future<Map<String, dynamic>> _submitTestResults() async {
    if (participantId == null) {
      throw Exception('participantId bulunamadı.');
    }

    return _aiService.submitTestResults(
      participantId: participantId!,
      testAnswers: testAnswers,
    );
  }

  Future<void> _createParticipant() async {
    final response = await _aiService.startExperiment(
      studentName: studentName,
      school: school,
      department: department,
      currentGoal: currentGoal,
    );

    participantId = response['participantId']?.toString();
    experimentGroup = response['group']?.toString() ?? 'B';
  }

  void _askFeedback() {
    addAiMessage(
      'Deneyiminizi puanlayarak profesyonel analiz raporunuzu PDF formatında hemen indirebilirsiniz. Lütfen 1\'den 5\'e kadar bir puan veriniz:',
    );
  }

  Future<void> submitFeedback(int score) async {
    if (flowState == 'FINISHED') return;
    flowState = 'FINISHED';

    addAiMessage(
      'Teşekkürler! $score/5 puanını kaydettim. Deney tamamlandı. Katılımın için çok teşekkür ederiz!',
    );
    await _saveFeedback(score);
    // mark feedback as submitted so UI can enable export actions
    _ref.read(feedbackSubmittedProvider.notifier).state = true;
  }

  void clear() {
    state = const [];
    setTyping(false);
  }

  void clearAndRestart() {
    clear();
    currentStep = 0;
    flowState = 'ONBOARDING';
    currentTest = 'RIASEC';
    currentQuestionIndex = 0;
    studentName = '';
    school = '';
    department = '';
    currentGoal = '';
    testAnswers.clear();
    participantId = null;
    experimentGroup = 'B';
    _ref.read(feedbackSubmittedProvider.notifier).state = false;
    _seedInitialMessages();
  }

  Future<void> handleAiUnlockChoice(bool wantsAiReport) async {
    addUserMessage(
      wantsAiReport ? 'Evet, görmek istiyorum' : 'Hayır, gerek yok',
    );
    flowState = 'AI_DECIDED';

    if (!wantsAiReport) {
      _askFeedback();
      flowState = 'FEEDBACK';
      return;
    }

    await _generateAiReport();
  }

  Future<void> _saveFeedback(int score) async {
    if (participantId == null) return;
    await _aiService.submitFeedback(
      participantId: participantId!,
      score: score,
    );
  }

  // Prompt builder removed: AI generation now handled server-side.

  void setTyping(bool isTyping) {
    _ref.read(chatTypingProvider.notifier).state = isTyping;
  }

  void _askAiUnlock() {
    addAiMessage('Yapay zeka analizini de görmek ister misin? (İsteğe bağlı)');
  }
}
