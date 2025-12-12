import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import '../models/hymn.dart';

class HymnService {
  static final Map<String, List<Hymn>> _cache = {};

  static const Map<String, String> languageFiles = {
    'English': 'assets/data/english.xml',
    'French': 'assets/data/french.xml',
    'Yoruba': 'assets/data/yoruba.xml',
    'Hausa': 'assets/data/hausa.xml',
  };

  static Future<List<Hymn>> loadHymns(String language) async {
    if (_cache.containsKey(language)) {
      return _cache[language]!;
    }

    final filePath = languageFiles[language];
    if (filePath == null) return [];

    try {
      final xmlString = await rootBundle.loadString(filePath);
      final document = XmlDocument.parse(xmlString);
      final hymns = <Hymn>[];

      for (final hymnElement in document.findAllElements('Hymn')) {
        final id = int.tryParse(
          hymnElement.findElements('id').firstOrNull?.innerText ?? '0',
        ) ?? 0;

        final title = hymnElement.findElements('title').firstOrNull?.innerText.trim() ?? 'Untitled';

        final stanzas = hymnElement
            .findElements('stanza')
            .map((e) => e.innerText.trim())
            .toList();

        final chorusElements = hymnElement.findElements('chorus');
        final chorus = chorusElements.isNotEmpty 
            ? chorusElements.first.innerText.trim() 
            : null;

        // Determine audio file name
        String? audioFile;
        if (language == 'English') {
          audioFile = 'assets/audio/hymn_$id.ogg';
        }

        hymns.add(Hymn(
          id: id,
          title: title,
          stanzas: stanzas,
          chorus: chorus,
          audioFile: audioFile,
        ));
      }

      hymns.sort((a, b) => a.id.compareTo(b.id));
      _cache[language] = hymns;
      return hymns;
    } catch (e) {
      print('Error loading hymns: $e');
      return [];
    }
  }

  static List<Hymn> searchHymns(List<Hymn> hymns, String query) {
    if (query.isEmpty) return hymns;
    
    final lowerQuery = query.toLowerCase();
    
    // Check if query is a number
    final number = int.tryParse(query);
    if (number != null) {
      return hymns.where((h) => h.id == number).toList();
    }
    
    return hymns.where((h) {
      return h.title.toLowerCase().contains(lowerQuery) ||
          h.stanzas.any((s) => s.toLowerCase().contains(lowerQuery)) ||
          (h.chorus?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
