import 'package:flutter/material.dart';
import '../models/hymn.dart';
import '../services/hymn_service.dart';
import 'hymn_detail_screen.dart';

enum SortMode { numerical, alphabetical }

class HymnListScreen extends StatefulWidget {
  final String language;
  final String? categoryName;
  final List<int>? filterHymnIds;

  const HymnListScreen({
    super.key, 
    required this.language,
    this.categoryName,
    this.filterHymnIds,
  });

  @override
  State<HymnListScreen> createState() => _HymnListScreenState();
}

class _HymnListScreenState extends State<HymnListScreen> {
  List<Hymn> _allHymns = [];
  List<Hymn> _filteredHymns = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  SortMode _sortMode = SortMode.numerical;

  @override
  void initState() {
    super.initState();
    _loadHymns();
  }

  Future<void> _loadHymns() async {
    final hymns = await HymnService.loadHymns(widget.language);
    
    // Apply category filter if provided
    List<Hymn> filteredList = List<Hymn>.from(hymns);
    if (widget.filterHymnIds != null) {
      filteredList = hymns
          .where((h) => widget.filterHymnIds!.contains(h.id))
          .toList();
    }
    
    setState(() {
      _allHymns = filteredList;
      _filteredHymns = _sortHymns(filteredList);
      _isLoading = false;
    });
  }

  List<Hymn> _sortHymns(List<Hymn> hymns) {
    final sorted = List<Hymn>.from(hymns);
    
    // Separate hymn 0 (always at end)
    final hymnZero = sorted.where((h) => h.id == 0).toList();
    final others = sorted.where((h) => h.id != 0).toList();
    
    if (_sortMode == SortMode.numerical) {
      others.sort((a, b) => a.id.compareTo(b.id));
    } else {
      others.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    
    // Hymn 0 always at end
    return [...others, ...hymnZero];
  }

  void _toggleSortMode() {
    setState(() {
      _sortMode = _sortMode == SortMode.numerical 
          ? SortMode.alphabetical 
          : SortMode.numerical;
      _filteredHymns = _sortHymns(
        _searchController.text.isEmpty 
            ? _allHymns 
            : HymnService.searchHymns(_allHymns, _searchController.text)
      );
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredHymns = _sortHymns(HymnService.searchHymns(_allHymns, query));
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
    final title = widget.categoryName ?? '${widget.language} Hymns';

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
            : Text(title),
        actions: [
          // Sort toggle button
          IconButton(
            icon: Icon(
              _sortMode == SortMode.numerical 
                  ? Icons.sort_by_alpha 
                  : Icons.format_list_numbered,
            ),
            tooltip: _sortMode == SortMode.numerical 
                ? 'Sort alphabetically' 
                : 'Sort by number',
            onPressed: _toggleSortMode,
          ),
          // Search button
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredHymns = _sortHymns(_allHymns);
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
