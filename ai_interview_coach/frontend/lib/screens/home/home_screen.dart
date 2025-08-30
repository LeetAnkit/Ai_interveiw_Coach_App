import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../config/app_config.dart';
import 'widgets/welcome_card.dart';
import 'widgets/practice_mode_card.dart';
import 'widgets/recent_sessions_card.dart';
import 'widgets/stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
        title: Text(AppConfig.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              const WelcomeCard(),
              const SizedBox(height: 20),
              
              // Stats Overview
              const StatsCard(),
              const SizedBox(height: 24),
              
              // Practice Modes
              Text(
                'Start Practicing',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: PracticeModeCard(
                      title: 'Voice Practice',
                      subtitle: 'Speak your answers',
                      icon: Icons.mic,
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/interview',
                          arguments: {'mode': 'voice'},
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PracticeModeCard(
                      title: 'Text Practice',
                      subtitle: 'Type your answers',
                      icon: Icons.edit,
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/interview',
                          arguments: {'mode': 'text'},
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Recent Sessions
              const RecentSessionsCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/interview');
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Practice'),
      ),
    );
  }
}