import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Theme Setting
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: const Text('Theme'),
                  subtitle: Text(themeProvider.themeLabel),
                  trailing: PopupMenuButton<ThemeMode>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: themeProvider.setThemeMode,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: ThemeMode.light,
                        child: Row(
                          children: [
                            Icon(
                              Icons.light_mode,
                              color: themeProvider.isLightMode
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text('Light'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeMode.dark,
                        child: Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              color: themeProvider.isDarkMode
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text('Dark'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeMode.system,
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: themeProvider.isSystemMode
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text('System'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const Divider(),
            
            // Notifications Setting
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              ),
              title: const Text('Notifications'),
              subtitle: const Text('Practice reminders'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implement notification settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification settings coming soon!'),
                    ),
                  );
                },
              ),
            ),
            
            const Divider(),
            
            // Data Export Setting
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.download,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
              ),
              title: const Text('Export Data'),
              subtitle: const Text('Download your practice history'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implement data export
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data export feature coming soon!'),
                  ),
                );
              },
            ),
            
            const Divider(),
            
            // Clear Data Setting
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
              ),
              title: Text(
                'Clear All Data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              subtitle: const Text('Delete all practice sessions'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showClearDataDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all your practice sessions? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement clear all data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear data feature coming soon!'),
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
}