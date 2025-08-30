import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';
import '../models/session_model.dart';
import '../services/api_service.dart';

class SessionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  FirebaseFirestore? _firestore;

  bool _isAnalyzing = false;
  bool _isSaving = false;
  bool _isLoadingHistory = false;
  String? _errorMessage;
  FeedbackModel? _lastFeedback;
  List<SessionModel> _sessions = [];
  bool _isFirestoreAvailable = true;

  bool get isAnalyzing => _isAnalyzing;
  bool get isSaving => _isSaving;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorMessage => _errorMessage;
  FeedbackModel? get lastFeedback => _lastFeedback;
  List<SessionModel> get sessions => _sessions;
  bool get isFirestoreAvailable => _isFirestoreAvailable;

  SessionProvider() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      _isFirestoreAvailable = false;
      if (kDebugMode) {
        print('Firestore not available: $e');
      }
    }
  }

  Future<bool> analyzeResponse(String question, String answer) async {
    try {
      _setAnalyzing(true);
      _clearError();

      final feedback = await _apiService.analyzeResponse(question, answer);
      _lastFeedback = feedback;

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setAnalyzing(false);
    }
  }

  Future<bool> saveSession({
    required String userId,
    required String question,
    required String answer,
    required FeedbackModel feedback,
  }) async {
    if (!_isFirestoreAvailable || _firestore == null) {
      if (kDebugMode) {
        print('Firestore not available - session not saved');
      }
      return false;
    }

    try {
      _setSaving(true);
      _clearError();

      final session = SessionModel(
        id: '',
        userId: userId,
        question: question,
        answer: answer,
        feedback: feedback,
        createdAt: DateTime.now(),
      );

      // Save to Firestore directly (client-side)
      final docRef = await _firestore!
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .add(session.toMap());

      // Update session with generated ID
      final savedSession = session.copyWith(id: docRef.id);
      _sessions.insert(0, savedSession);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save session: ${e.toString()}');
      return false;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> loadSessionHistory(String userId) async {
    if (!_isFirestoreAvailable || _firestore == null) {
      if (kDebugMode) {
        print('Firestore not available - cannot load history');
      }
      return;
    }

    try {
      _setLoadingHistory(true);
      _clearError();

      final querySnapshot = await _firestore!
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      _sessions = querySnapshot.docs
          .map((doc) => SessionModel.fromMap(doc.id, doc.data()))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load session history: ${e.toString()}');
    } finally {
      _setLoadingHistory(false);
    }
  }

  Future<void> deleteSession(String userId, String sessionId) async {
    if (!_isFirestoreAvailable || _firestore == null) {
      _setError('Cannot delete session - database not available');
      return;
    }

    try {
      await _firestore!
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .delete();

      _sessions.removeWhere((session) => session.id == sessionId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete session: ${e.toString()}');
    }
  }

  void clearLastFeedback() {
    _lastFeedback = null;
    notifyListeners();
  }

  void _setAnalyzing(bool analyzing) {
    _isAnalyzing = analyzing;
    notifyListeners();
  }

  void _setSaving(bool saving) {
    _isSaving = saving;
    notifyListeners();
  }

  void _setLoadingHistory(bool loading) {
    _isLoadingHistory = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
