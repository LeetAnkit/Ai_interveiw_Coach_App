import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback_model.dart';

class SessionModel {
  final String id;
  final String userId;
  final String question;
  final String answer;
  final FeedbackModel feedback;
  final DateTime createdAt;

  SessionModel({
    required this.id,
    required this.userId,
    required this.question,
    required this.answer,
    required this.feedback,
    required this.createdAt,
  });

  factory SessionModel.fromMap(String id, Map<String, dynamic> map) {
    return SessionModel(
      id: id,
      userId: map['userId'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      feedback: FeedbackModel.fromJson(map['feedback'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'question': question,
      'answer': answer,
      'feedback': feedback.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SessionModel copyWith({
    String? id,
    String? userId,
    String? question,
    String? answer,
    FeedbackModel? feedback,
    DateTime? createdAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  String get shortQuestion {
    if (question.length <= 50) return question;
    return '${question.substring(0, 50)}...';
  }

  String get shortAnswer {
    if (answer.length <= 100) return answer;
    return '${answer.substring(0, 100)}...';
  }
}
