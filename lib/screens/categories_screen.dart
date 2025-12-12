import 'package:flutter/material.dart';
import 'hymn_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Hymn categories with their hymn number ranges
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Admonition', 'hymns': [1, 2, 3, 4, 5, 6]},
    {'name': 'Adoration & Praise', 'hymns': [8, 9, 10, 11, 12, 13, 14, 15, 16]},
    {'name': 'Assurance & Trust', 'hymns': [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]},
    {'name': 'Blood of Jesus', 'hymns': [17, 31, 32, 33, 34, 35]},
    {'name': 'Christian Living', 'hymns': [36, 37, 38, 39, 40, 41, 42, 43, 44, 45]},
    {'name': 'Consecration', 'hymns': [46, 47, 48, 49, 50, 51, 52, 53, 54, 55]},
    {'name': 'Cross of Christ', 'hymns': [56, 57, 58, 59, 60]},
    {'name': 'Faith', 'hymns': [61, 62, 63, 64, 65]},
    {'name': 'Fellowship', 'hymns': [66, 67, 68, 69, 70]},
    {'name': 'Heaven', 'hymns': [71, 72, 73, 74, 75, 76, 77, 78, 79, 80]},
    {'name': 'Holiness', 'hymns': [81, 82, 83, 84, 85, 86, 87, 88, 89, 90]},
    {'name': 'Holy Spirit', 'hymns': [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]},
    {'name': 'Invitation', 'hymns': [101, 102, 103, 104, 105, 106, 107, 108, 109, 110]},
    {'name': 'Love of God', 'hymns': [111, 112, 113, 114, 115]},
    {'name': 'Prayer', 'hymns': [116, 117, 118, 119, 120, 121, 122, 123, 124, 125]},
    {'name': 'Revival', 'hymns': [126, 127, 128, 129, 130]},
    {'name': 'Salvation', 'hymns': [131, 132, 133, 134, 135, 136, 137, 138, 139, 140]},
    {'name': 'Second Coming', 'hymns': [141, 142, 143, 144, 145, 146, 147, 148, 149, 150]},
    {'name': 'Service', 'hymns': [151, 152, 153, 154, 155, 156, 157, 158, 159, 160]},
    {'name': 'Testimony', 'hymns': [161, 162, 163, 164, 165, 166, 167, 168, 169, 170]},
    {'name': 'Warfare & Victory', 'hymns': [171, 172, 173, 174, 175, 176, 177, 178, 179, 180]},
    {'name': 'Word of God', 'hymns': [181, 182, 183, 184, 185]},
    {'name': 'Worship', 'hymns': [186, 187, 188, 189, 190, 191, 192, 193, 194, 195]},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hymn Categories'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Card(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder_outlined,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  category['name'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${(category['hymns'] as List).length} hymns',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HymnListScreen(
                        language: 'English',
                        categoryName: category['name'] as String,
                        filterHymnIds: List<int>.from(category['hymns'] as List),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
