class Hymn {
  final int id;
  final String title;
  final List<String> stanzas;
  final String? chorus;
  final String? audioFile;

  Hymn({
    required this.id,
    required this.title,
    required this.stanzas,
    this.chorus,
    this.audioFile,
  });

  String get displayNumber => id.toString().padLeft(3, '0');
}
