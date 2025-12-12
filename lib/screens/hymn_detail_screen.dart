import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/hymn.dart';

class HymnDetailScreen extends StatefulWidget {
  final Hymn hymn;

  const HymnDetailScreen({super.key, required this.hymn});

  @override
  State<HymnDetailScreen> createState() => _HymnDetailScreenState();
}

class _HymnDetailScreenState extends State<HymnDetailScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasAudio = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    if (widget.hymn.audioFile == null) return;

    _audioPlayer = AudioPlayer();
    
    try {
      await _audioPlayer!.setAsset(widget.hymn.audioFile!);
      setState(() => _hasAudio = true);

      _audioPlayer!.durationStream.listen((duration) {
        if (duration != null) {
          setState(() => _duration = duration);
        }
      });

      _audioPlayer!.positionStream.listen((position) {
        setState(() => _position = position);
      });

      _audioPlayer!.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
        
        if (state.processingState == ProcessingState.completed) {
          _audioPlayer!.seek(Duration.zero);
          _audioPlayer!.pause();
        }
      });
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_audioPlayer == null) return;
    
    if (_isPlaying) {
      _audioPlayer!.pause();
    } else {
      _audioPlayer!.play();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hymn ${widget.hymn.id}'),
      ),
      body: Column(
        children: [
          // Lyrics
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.hymn.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stanzas and Chorus
                  for (int i = 0; i < widget.hymn.stanzas.length; i++) ...[
                    _StanzaCard(
                      content: widget.hymn.stanzas[i],
                      theme: theme,
                    ),
                    if (widget.hymn.chorus != null && i < widget.hymn.stanzas.length - 1) ...[
                      const SizedBox(height: 16),
                      _ChorusCard(
                        content: widget.hymn.chorus!,
                        theme: theme,
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                  
                  // Final chorus
                  if (widget.hymn.chorus != null) ...[
                    _ChorusCard(
                      content: widget.hymn.chorus!,
                      theme: theme,
                    ),
                  ],
                  
                  const SizedBox(height: 100), // Space for audio player
                ],
              ),
            ),
          ),

          // Audio Player
          if (_hasAudio)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                      ),
                      child: Slider(
                        value: _position.inMilliseconds.toDouble(),
                        max: _duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                        onChanged: (value) {
                          _audioPlayer?.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                    ),
                    
                    // Time and controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: theme.textTheme.bodySmall,
                        ),
                        
                        // Play button
                        IconButton.filled(
                          onPressed: _togglePlay,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 32,
                                ),
                          style: IconButton.styleFrom(
                            minimumSize: const Size(56, 56),
                          ),
                        ),
                        
                        Text(
                          _formatDuration(_duration),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StanzaCard extends StatelessWidget {
  final String content;
  final ThemeData theme;

  const _StanzaCard({required this.content, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        content,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
        ),
      ),
    );
  }
}

class _ChorusCard extends StatelessWidget {
  final String content;
  final ThemeData theme;

  const _ChorusCard({required this.content, required this.theme});

  @override
  Widget build(BuildContext context) {
    final containerColor = theme.colorScheme.primaryContainer;
    final borderColor = theme.colorScheme.primary;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(
          (containerColor.a * 0.5).round(),
          containerColor.r.round(),
          containerColor.g.round(),
          containerColor.b.round(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color.fromARGB(
            (borderColor.a * 0.3).round(),
            borderColor.r.round(),
            borderColor.g.round(),
            borderColor.b.round(),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chorus',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
