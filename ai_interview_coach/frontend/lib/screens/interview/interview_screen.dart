import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../config/app_config.dart';
import '../../utils/theme.dart';
import 'widgets/question_card.dart';
import 'widgets/answer_input.dart';
import 'widgets/voice_recorder.dart';
import 'widgets/practice_timer.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with TickerProviderStateMixin {
  final TextEditingController _answerController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isVoiceMode = false;
  String _currentQuestion = '';
  int _questionIndex = 0;
  
  final List<String> _sampleQuestions = [
    'Tell me about yourself and your background.',
    'What are your greatest strengths and how do they apply to this role?',
    'Describe a challenging situation you faced at work and how you handled it.',
    'Why are you interested in this position and our company?',
    'Where do you see yourself in five years?',
    'What is your biggest weakness and how are you working to improve it?',
    'Tell me about a time you had to work with a difficult team member.',
    'How do you handle stress and pressure in the workplace?',
    'What motivates you to do your best work?',
    'Do you have any questions for us?',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSpeech();
    _setRandomQuestion();
    _checkArguments();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  void _checkArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['mode'] == 'voice') {
        setState(() {
          _isVoiceMode = true;
        });
      }
    });
  }

  Future<void> _initializeSpeech() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _showPermissionDialog();
        return;
      }
      
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          setState(() {
            _isListening = false;
          });
          _showErrorSnackBar('Speech recognition error: ${error.errorMsg}');
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });
          }
        },
      );
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing speech: $e');
      _showErrorSnackBar('Failed to initialize speech recognition');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission'),
        content: const Text(
          'This app needs microphone permission for voice practice. Please enable it in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _setRandomQuestion() {
    _sampleQuestions.shuffle();
    setState(() {
      _currentQuestion = _sampleQuestions.first;
      _questionIndex = 0;
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex = (_questionIndex + 1) % _sampleQuestions.length;
      _currentQuestion = _sampleQuestions[_questionIndex];
      _answerController.clear();
    });
  }

  void _toggleListening() async {
    if (!_speechEnabled) {
      _showErrorSnackBar('Speech recognition not available');
      return;
    }

    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _isListening = true;
      });
      
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _answerController.text = result.recognizedWords;
          });
        },
        listenFor: AppConfig.speechTimeout,
        pauseFor: AppConfig.pauseTimeout,
        partialResults: true,
        localeId: 'en_US',
        cancelOnError: true,
      );
    }
  }

  Future<void> _submitAnswer() async {
    final answer = _answerController.text.trim();
    
    if (answer.isEmpty) {
      _showErrorSnackBar('Please provide an answer before submitting');
      return;
    }
    
    if (answer.length < AppConfig.minAnswerLength) {
      _showErrorSnackBar('Answer is too short. Please provide more details.');
      return;
    }

    final sessionProvider = context.read<SessionProvider>();
    final authProvider = context.read<AuthProvider>();
    
    // Clear any previous errors
    sessionProvider.clearError();
    
    try {
      // Analyze the response
      final success = await sessionProvider.analyzeResponse(
        _currentQuestion,
        answer,
      );
      
      if (!success) {
        _showErrorSnackBar(
          sessionProvider.errorMessage ?? 'Failed to analyze response'
        );
        return;
      }
      
      // Save session if user is authenticated
      if (authProvider.isAuthenticated && sessionProvider.lastFeedback != null) {
        await sessionProvider.saveSession(
          userId: authProvider.user!.uid,
          question: _currentQuestion,
          answer: answer,
          feedback: sessionProvider.lastFeedback!,
        );
      }
      
      // Navigate to feedback screen
      if (mounted) {
        Navigator.pushNamed(context, '/feedback');
      }
      
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Practice'),
        actions: [
          IconButton(
            icon: Icon(_isVoiceMode ? Icons.mic : Icons.edit),
            onPressed: () {
              setState(() {
                _isVoiceMode = !_isVoiceMode;
                if (!_isVoiceMode && _isListening) {
                  _speechToText.stop();
                  _isListening = false;
                }
              });
            },
            tooltip: _isVoiceMode ? 'Switch to Text Mode' : 'Switch to Voice Mode',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _nextQuestion,
            tooltip: 'Next Question',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Consumer<SessionProvider>(
            builder: (context, sessionProvider, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Practice Timer
                    const PracticeTimer(),
                    const SizedBox(height: 20),
                    
                    // Question Card
                    QuestionCard(
                      question: _currentQuestion,
                      questionNumber: _questionIndex + 1,
                      totalQuestions: _sampleQuestions.length,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Mode Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isVoiceMode
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isVoiceMode
                              ? AppTheme.primaryColor.withOpacity(0.3)
                              : AppTheme.secondaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isVoiceMode ? Icons.mic : Icons.edit,
                            size: 16,
                            color: _isVoiceMode
                                ? AppTheme.primaryColor
                                : AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isVoiceMode ? 'Voice Mode' : 'Text Mode',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: _isVoiceMode
                                  ? AppTheme.primaryColor
                                  : AppTheme.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Voice Recorder (when in voice mode)
                    if (_isVoiceMode) ...[
                      VoiceRecorder(
                        isListening: _isListening,
                        speechEnabled: _speechEnabled,
                        onToggleListening: _toggleListening,
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Answer Input
                    AnswerInput(
                      controller: _answerController,
                      isVoiceMode: _isVoiceMode,
                      isListening: _isListening,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: sessionProvider.isAnalyzing ? null : _submitAnswer,
                        icon: sessionProvider.isAnalyzing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                          sessionProvider.isAnalyzing
                              ? 'Analyzing Answer...'
                              : 'Get Feedback',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Error Message
                    if (sessionProvider.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sessionProvider.errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}