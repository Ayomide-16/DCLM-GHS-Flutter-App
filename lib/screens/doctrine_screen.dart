import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class DoctrineScreen extends StatefulWidget {
  const DoctrineScreen({super.key});

  @override
  State<DoctrineScreen> createState() => _DoctrineScreenState();
}

class _DoctrineScreenState extends State<DoctrineScreen> {
  List<Map<String, String>> _doctrines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctrines();
  }

  Future<void> _loadDoctrines() async {
    try {
      final xmlString = await rootBundle.loadString('assets/data/doctrine.xml');
      final document = XmlDocument.parse(xmlString);
      final doctrines = <Map<String, String>>[];

      for (final element in document.findAllElements('Doctr')) {
        final id = element.findElements('id').firstOrNull?.innerText ?? '';
        final title = element.findElements('title').firstOrNull?.innerText.trim() ?? '';
        final content = element.findElements('stanza').firstOrNull?.innerText.trim() ?? '';
        
        if (title.isNotEmpty) {
          doctrines.add({
            'id': id,
            'title': title,
            'content': content,
          });
        }
      }
      // Move first doctrine (Acts 2:42, no ID) to end of list
      if (doctrines.isNotEmpty && doctrines.first['id']!.isEmpty) {
        final firstDoctrine = doctrines.removeAt(0);
        doctrines.add(firstDoctrine);
      }

      setState(() {
        _doctrines = doctrines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Doctrine'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _doctrines.isEmpty
              ? Center(
                  child: Text(
                    'No doctrines found',
                    style: theme.textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _doctrines.length,
                  itemBuilder: (context, index) {
                    final doctrine = _doctrines[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Card(
                        child: ExpansionTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                doctrine['id']!.isEmpty ? '•' : doctrine['id']!,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            doctrine['title']!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                doctrine['content']!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
