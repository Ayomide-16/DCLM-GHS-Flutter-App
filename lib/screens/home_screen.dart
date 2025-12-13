import 'package:flutter/material.dart';
import '../main.dart';
import 'hymn_list_screen.dart';
import 'categories_screen.dart';
import 'doctrine_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Theme toggle at top right
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => GHSApp.of(context)?.toggleTheme(),
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                    ),
                    tooltip: isDark ? 'Light Theme' : 'Dark Theme',
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.music_note_rounded,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'GHS',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gospel Hymns and Songs',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Language Selection Section
                _SectionHeader(title: 'Hymn Languages'),
                const SizedBox(height: 12),
                _MenuButton(
                  label: 'English',
                  icon: Icons.library_music,
                  onTap: () => _openHymns(context, 'English'),
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  label: 'French',
                  icon: Icons.library_music_outlined,
                  onTap: () => _openHymns(context, 'French'),
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  label: 'Yoruba',
                  icon: Icons.library_music_outlined,
                  onTap: () => _openHymns(context, 'Yoruba'),
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  label: 'Hausa',
                  icon: Icons.library_music_outlined,
                  onTap: () => _openHymns(context, 'Hausa'),
                ),
                
                const SizedBox(height: 32),
                
                // More Section
                _SectionHeader(title: 'More'),
                const SizedBox(height: 12),
                _MenuButton(
                  label: 'Hymn Categories',
                  icon: Icons.category_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                  ),
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  label: 'Bible Doctrine',
                  icon: Icons.menu_book_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DoctrineScreen()),
                  ),
                ),
                
                const SizedBox(height: 24),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuButton({
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
