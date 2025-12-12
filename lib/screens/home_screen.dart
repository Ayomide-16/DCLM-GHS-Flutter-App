import 'package:flutter/material.dart';
import 'hymn_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.music_note_rounded,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Gospel Hymn',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a language',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Language Buttons
                _LanguageButton(
                  label: 'English',
                  icon: Icons.library_music,
                  onTap: () => _openHymns(context, 'English'),
                ),
                const SizedBox(height: 12),
                _LanguageButton(
                  label: 'French',
                  icon: Icons.library_music_outlined,
                  onTap: () => _openHymns(context, 'French'),
                ),
                const SizedBox(height: 12),
                _LanguageButton(
                  label: 'Yoruba',
                  icon: Icons.library_music_outlined,
                  onTap: () => _openHymns(context, 'Yoruba'),
                ),
                const SizedBox(height: 12),
                _LanguageButton(
                  label: 'Hausa',
                  icon: Icons.library_music_outlined,
                  onTap: () => _openHymns(context, 'Hausa'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openHymns(BuildContext context, String language) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HymnListScreen(language: language),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
