import 'package:flutter/material.dart';
import '../models/hymn.dart';
import '../services/hymn_service.dart';
import 'hymn_detail_screen.dart';

class HymnListScreen extends StatefulWidget {
  final String language;

  const HymnListScreen({super.key, required this.language});

  @override
  State<HymnListScreen> createState() => _HymnListScreenState();
}

class _HymnListScreenState extends State<HymnListScreen> {
  List<Hymn> _allHymns = [];
  List<Hymn> _filteredHymns = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadHymns();
  }

  Future<void> _loadHymns() async {
    final hymns = await HymnService.loadHymns(widget.language);
    setState(() {
      _allHymns = hymns;
      _filteredHymns = hymns;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredHymns = HymnService.searchHymns(_allHymns, query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search hymns...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : Text('${widget.language} Hymns'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredHymns = _allHymns;
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredHymns.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hymns found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredHymns.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final hymn = _filteredHymns[index];
                    return _HymnTile(
                      hymn: hymn,
                      onTap: () => _openHymnDetail(hymn),
                    );
                  },
                ),
    );
  }

  void _openHymnDetail(Hymn hymn) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HymnDetailScreen(hymn: hymn),
      ),
    );
  }
}

class _HymnTile extends StatelessWidget {
  final Hymn hymn;
  final VoidCallback onTap;

  const _HymnTile({required this.hymn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${hymn.id}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          title: Text(
            hymn.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: hymn.stanzas.isNotEmpty
              ? Text(
                  hymn.stanzas.first.split('\n').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          trailing: hymn.audioFile != null
              ? Icon(
                  Icons.music_note,
                  color: theme.colorScheme.primary,
                  size: 20,
                )
              : null,
        ),
      ),
    );
  }
}
