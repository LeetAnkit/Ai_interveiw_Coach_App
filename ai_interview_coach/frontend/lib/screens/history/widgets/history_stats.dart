import 'package:flutter/material.dart';
import '../../../models/session_model.dart';
import '../../../utils/theme.dart';

class HistoryStats extends StatelessWidget {
  final List<SessionModel> sessions;

  const HistoryStats({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) return const SizedBox.shrink();

    final totalSessions = sessions.length;
    final averageScore = sessions
        .map((s) => s.feedback.score)
        .reduce((a, b) => a + b) / totalSessions;
    
    final lastWeekSessions = sessions.where((s) {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      return s.createdAt.isAfter(weekAgo);
    }).length;

    final bestScore = sessions
        .map((s) => s.feedback.score)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Statistics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Total',
                  totalSessions.toString(),
                  'Sessions',
                  AppTheme.primaryColor,
                  Icons.quiz,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Average',
                  averageScore.toStringAsFixed(1),
                  'Score',
                  AppTheme.successColor,
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'This Week',
                  lastWeekSessions.toString(),
                  'Sessions',
                  AppTheme.secondaryColor,
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Best Score',
                  bestScore.toString(),
                  'Points',
                  AppTheme.accentColor,
                  Icons.star,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        
        const SizedBox(height: 2),
        
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        
        Text(
          unit,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}