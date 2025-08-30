import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../models/session_model.dart';
import 'widgets/session_tile.dart';
import 'widgets/empty_history.dart';
import 'widgets/history_stats.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final authProvider = context.read<AuthProvider>();
    final sessionProvider = context.read<SessionProvider>();
    
    if (authProvider.user != null) {
      await sessionProvider.loadSessionHistory(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice History'),
        actions: [
          Consumer<SessionProvider>(
            builder: (context, sessionProvider, child) {
              return sessionProvider.sessions.isNotEmpty
                  ? PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'clear':
                            _showClearHistoryDialog();
                            break;
                          case 'export':
                            _showExportDialog();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'export',
                          child: ListTile(
                            leading: Icon(Icons.download),
                            title: Text('Export PDF'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'clear',
                          child: ListTile(
                            leading: Icon(Icons.clear_all),
                            title: Text('Clear History'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<SessionProvider>(
        builder: (context, sessionProvider, child) {
          if (sessionProvider.isLoadingHistory) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final sessions = sessionProvider.sessions;

          if (sessions.isEmpty) {
            return const EmptyHistory();
          }

          return RefreshIndicator(
            onRefresh: _loadHistory,
            child: Column(
              children: [
                // Stats Overview
                HistoryStats(sessions: sessions),
                
                // Sessions List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return SessionTile(
                        session: session,
                        onTap: () => _navigateToFeedback(session),
                        onDelete: () => _showDeleteDialog(session),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToFeedback(SessionModel session) {
    Navigator.pushNamed(
      context,
      '/feedback',
      arguments: {'session': session},
    );
  }

  void _showDeleteDialog(SessionModel session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: const Text(
          'Are you sure you want to delete this practice session? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = context.read<AuthProvider>();
              final sessionProvider = context.read<SessionProvider>();
              
              if (authProvider.user != null) {
                await sessionProvider.deleteSession(
                  authProvider.user!.uid,
                  session.id,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to clear all your practice history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement clear all functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear all feature coming soon!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export History'),
        content: const Text(
          'Export your practice history as a PDF report.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement PDF export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF export feature coming soon!'),
                ),
              );
            },
            child: const Text('Export PDF'),
          ),
        ],
      ),
    );
  }
}