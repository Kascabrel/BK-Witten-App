import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

/// Displays the list of school announcements (Mitteilungen) fetched from
/// the Flask backend. Authenticated users can create new announcements.
///
/// The author of an announcement may also delete it.
class MitteilungenScreen extends StatefulWidget {
  const MitteilungenScreen({super.key});

  @override
  State<MitteilungenScreen> createState() => _MitteilungenScreenState();
}

class _MitteilungenScreenState extends State<MitteilungenScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMitteilungen();
  }

  Future<void> _loadMitteilungen() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final api = context.read<AuthProvider>().api;
    try {
      final items = await api.getMitteilungen();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Backend nicht erreichbar.';
        _loading = false;
      });
    }
  }

  Future<void> _delete(int id) async {
    final api = context.read<AuthProvider>().api;
    try {
      await api.deleteMitteilung(id);
      _loadMitteilungen();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F1923) : const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Mitteilungen'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F1923) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMitteilungen,
            tooltip: 'Aktualisieren',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateMitteilungScreen(),
            ),
          );
          if (created == true) _loadMitteilungen();
        },
        icon: const Icon(Icons.add),
        label: const Text('Neue Mitteilung'),
      ),
      body: _buildBody(isDark, auth),
    );
  }

  Widget _buildBody(bool isDark, AuthProvider auth) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: isDark ? Colors.white38 : Colors.black38),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadMitteilungen,
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 64, color: isDark ? Colors.white24 : Colors.black12),
            const SizedBox(height: 16),
            Text(
              'Noch keine Mitteilungen',
              style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white38 : Colors.black38),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMitteilungen,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _items.length,
        itemBuilder: (ctx, i) {
          final item = _items[i];
          final isAuthor = item['author'] == auth.username;
          return _MitteilungCard(
            item: item,
            isDark: isDark,
            isAuthor: isAuthor,
            onDelete: isAuthor ? () => _delete(item['id'] as int) : null,
            onEdit: isAuthor
                ? () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateMitteilungScreen(
                          editItem: item,
                        ),
                      ),
                    );
                    if (updated == true) _loadMitteilungen();
                  }
                : null,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mitteilung card
// ─────────────────────────────────────────────────────────────────────────────

class _MitteilungCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isDark;
  final bool isAuthor;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _MitteilungCard({
    required this.item,
    required this.isDark,
    required this.isAuthor,
    this.onDelete,
    this.onEdit,
  });

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF1A2535)
        : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['title'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (isAuthor) ...[
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      onPressed: onEdit,
                      tooltip: 'Bearbeiten',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  const SizedBox(width: 8),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red.shade400,
                      ),
                      onPressed: () => _confirmDelete(context),
                      tooltip: 'Löschen',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            // Content
            Text(
              item['content'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Footer
            Row(
              children: [
                Icon(Icons.person_outline,
                    size: 13,
                    color: isDark ? Colors.white38 : Colors.black38),
                const SizedBox(width: 4),
                Text(
                  item['author'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
                const Spacer(),
                Icon(Icons.access_time,
                    size: 13,
                    color: isDark ? Colors.white38 : Colors.black38),
                const SizedBox(width: 4),
                Text(
                  _formatDate(item['created_at'] as String?),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mitteilung löschen'),
        content:
            const Text('Möchtest du diese Mitteilung wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              onDelete?.call();
            },
            child: const Text('Löschen',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Create / Edit form
// ─────────────────────────────────────────────────────────────────────────────

/// Screen for creating or editing a Mitteilung.
///
/// Pass [editItem] to pre-fill the form for an edit operation.
class CreateMitteilungScreen extends StatefulWidget {
  final Map<String, dynamic>? editItem;

  const CreateMitteilungScreen({super.key, this.editItem});

  @override
  State<CreateMitteilungScreen> createState() => _CreateMitteilungScreenState();
}

class _CreateMitteilungScreenState extends State<CreateMitteilungScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _loading = false;

  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.editItem?['title'] as String? ?? '',
    );
    _contentController = TextEditingController(
      text: widget.editItem?['content'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final api = context.read<AuthProvider>().api;
    try {
      if (_isEditing) {
        await api.updateMitteilung(
          id: widget.editItem!['id'] as int,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
      } else {
        await api.createMitteilung(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fehler beim Speichern')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Mitteilung bearbeiten' : 'Neue Mitteilung'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Titel erforderlich' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: 'Inhalt',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Inhalt erforderlich' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _isEditing ? 'Speichern' : 'Veröffentlichen',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
