import 'package:flutter/material.dart';
import '../../../models/feedback_model.dart';
import '../../../utils/theme.dart';

class AnalysisCards extends StatelessWidget {
  final FeedbackModel feedback;

  const AnalysisCards({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAnalysisCard(
                context,
                'Filler Words',
                feedback.fillerWords.isEmpty
                    ? 'None detected!'
                    : feedback.fillerWords.join(', '),
                feedback.fillerWords.isEmpty
                    ? AppTheme.successColor
                    : AppTheme.warningColor,
                feedback.fillerWords.isEmpty
                    ? Icons.check_circle
                    : Icons.warning,
                feedback.fillerWords.isEmpty
                    ? 'Great job avoiding filler words'
                    : 'Try to minimize these words',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnalysisCard(
                context,
                'Grammar',
                feedback.grammarIssues.isEmpty
                    ? 'No issues found!'
                    : '${feedback.grammarIssues.length} issue(s)',
                feedback.grammarIssues.isEmpty
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
                feedback.grammarIssues.isEmpty
                    ? Icons.check_circle
                    : Icons.error,
                feedback.grammarIssues.isEmpty
                    ? 'Excellent grammar usage'
                    : 'Review grammar basics',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRelevanceCard(context),
      ],
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    String title,
    String content,
    Color color,
    IconData icon,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelevanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.track_changes,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Response Relevance',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback.relevance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
