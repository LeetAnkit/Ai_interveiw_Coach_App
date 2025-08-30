import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/session_provider.dart';
import '../../../utils/theme.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {
        final sessions = sessionProvider.sessions;
        final totalSessions = sessions.length;
        final averageScore = totalSessions > 0
            ? sessions
                .map((s) => s.feedback.score)
                .reduce((a, b) => a + b) /
                totalSessions
            : 0.0;
        
        final improvementTrend = _calculateImprovementTrend(sessions);
        final streakDays = _calculateStreak(sessions);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Practice Statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total Sessions',
                        totalSessions.toString(),
                        Icons.quiz,
                        AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Average Score',
                        averageScore.toStringAsFixed(1),
                        Icons.trending_up,
                        AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Improvement',
                        improvementTrend,
                        Icons.analytics,
                        AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Practice Streak',
                        '$streakDays days',
                        Icons.local_fire_department,
                        AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateImprovementTrend(sessions) {
    if (sessions.length < 2) return '+0.0';
    
    final recentSessions = sessions.take(5).toList();
    final olderSessions = sessions.skip(5).take(5).toList();
    
    if (olderSessions.isEmpty) return '+0.0';
    
    final recentAvg = recentSessions
        .map((s) => s.feedback.score)
        .reduce((a, b) => a + b) / recentSessions.length;
    
    final olderAvg = olderSessions
        .map((s) => s.feedback.score)
        .reduce((a, b) => a + b) / olderSessions.length;
    
    final improvement = recentAvg - olderAvg;
    return improvement >= 0 ? '+${improvement.toStringAsFixed(1)}' : improvement.toStringAsFixed(1);
  }

  int _calculateStreak(sessions) {
    if (sessions.isEmpty) return 0;
    
    int streak = 0;
    final now = DateTime.now();
    final sortedSessions = sessions.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    for (int i = 0; i < sortedSessions.length; i++) {
      final sessionDate = sortedSessions[i].createdAt;
      final daysDiff = now.difference(sessionDate).inDays;
      
      if (i == 0 && daysDiff <= 1) {
        streak = 1;
      } else if (i > 0) {
        final prevSessionDate = sortedSessions[i - 1].createdAt;
        final daysBetween = prevSessionDate.difference(sessionDate).inDays;
        
        if (daysBetween <= 1) {
          streak++;
        } else {
          break;
        }
      }
    }
    
    return streak;
  }
}