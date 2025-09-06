class FeedbackModel {
  final String tone;
  final List<String> fillerWords;
  final List<String> grammarIssues;
  final String relevance;
  final int score;
  final String suggestions;
  final String followUp;

  FeedbackModel({
    required this.tone,
    required this.fillerWords,
    required this.grammarIssues,
    required this.relevance,
    required this.score,
    required this.suggestions,
    required this.followUp,
  });

  // this is convert the feedback model tot eh JSOMN map
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      tone: json['tone'] ?? 'neutral',
      fillerWords: List<String>.from(json['fillerWords'] ?? []),
      grammarIssues: List<String>.from(json['grammarIssues'] ?? []),
      relevance: json['relevance'] ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      suggestions: json['suggestions'] ?? '',
      followUp: json['followUp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tone': tone,
      'fillerWords': fillerWords,
      'grammarIssues': grammarIssues,
      'relevance': relevance,
      'score': score,
      'suggestions': suggestions,
      'followUp': followUp,
    };
  }

  FeedbackModel copyWith({
    String? tone,
    List<String>? fillerWords,
    List<String>? grammarIssues,
    String? relevance,
    int? score,
    String? suggestions,
    String? followUp,
  }) {
    return FeedbackModel(
      tone: tone ?? this.tone,
      fillerWords: fillerWords ?? this.fillerWords,
      grammarIssues: grammarIssues ?? this.grammarIssues,
      relevance: relevance ?? this.relevance,
      score: score ?? this.score,
      suggestions: suggestions ?? this.suggestions,
      followUp: followUp ?? this.followUp,
    );
  }

  // switch casse is used here we also can use if else but is more appelitids
  String get toneEmoji {
    switch (tone.toLowerCase()) {
      case 'confident':
        return '😎';
      case 'nervous':
        return '😥';
      case 'unsure':
        return '🤔';
      default:
        return '😐';
    }
  }

  String get scoreDescription {
    if (score >= 9) return 'Excellent';
    if (score >= 7) return 'Good';
    if (score >= 5) return 'Average';
    if (score >= 3) return 'Needs Improvement';
    return 'Poor';
  }

  double get scorePercentage => score / 10.0;
}
