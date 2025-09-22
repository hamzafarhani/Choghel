import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Note Document Model
class NoteDocument {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime modifiedAt;

  NoteDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
  });
}

void main() => runApp(const _buildNotePage());

class _buildNotePage extends StatelessWidget {
  const _buildNotePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting Notes & Calendar',
      debugShowCheckedModeBanner: false,
      home: const NotePage(),
    );
  }
}

// Enhanced Notes Page with Word-like interface
class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<NoteDocument> _documents = [];
  NoteDocument? _currentDocument;
  
  // Text formatting states
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  TextAlign _textAlign = TextAlign.left;
  double _fontSize = 16.0;
  Color _textColor = Colors.black;
  Color _highlightColor = Colors.transparent;
  String _fontFamily = 'Arial';
  
  // Document management
  bool _isNewDocument = true;
  bool _hasUnsavedChanges = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _createNewDocument();
    _noteController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_currentDocument != null) {
      setState(() {
        _currentDocument!.content = _noteController.text;
        _hasUnsavedChanges = true;
      });
    }
  }

  void _createNewDocument() {
    final newDoc = NoteDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Document sans titre',
      content: '',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    );
    
    setState(() {
      _currentDocument = newDoc;
      _documents.add(newDoc);
      _noteController.text = '';
      _isNewDocument = true;
      _hasUnsavedChanges = false;
    });
  }

  void _saveDocument() {
    if (_currentDocument != null) {
      setState(() {
        _currentDocument!.content = _noteController.text;
        _currentDocument!.modifiedAt = DateTime.now();
        _hasUnsavedChanges = false;
      });
      _showSnackBar('Document sauvegardé');
    }
  }

  void _loadDocument(NoteDocument document) {
    setState(() {
      _currentDocument = document;
      _noteController.text = document.content;
      _isNewDocument = false;
      _hasUnsavedChanges = false;
    });
  }

  void _deleteDocument(NoteDocument document) {
    setState(() {
      _documents.remove(document);
      if (_currentDocument == document) {
        if (_documents.isNotEmpty) {
          _loadDocument(_documents.first);
        } else {
          _createNewDocument();
        }
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildToolbar(),
          _buildDocumentArea(),
          _buildStatusBar(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF00A9E0),
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _showDocumentsMenu,
          ),
          Expanded(
            child: Text(
              _currentDocument?.title ?? 'Document sans titre',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          if (_hasUnsavedChanges)
            const Icon(Icons.circle, color: Colors.orange, size: 12),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.save, color: Colors.white),
          onPressed: _saveDocument,
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarPage()),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'new',
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Nouveau document'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 8),
                  Text('Exporter'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('Paramètres'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 60,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Document actions
            _buildToolbarGroup([
              _buildToolbarButton(Icons.add, 'Nouveau', () => _createNewDocument()),
              _buildToolbarButton(Icons.folder_open, 'Ouvrir', () => _showDocumentsMenu()),
              _buildToolbarButton(Icons.save, 'Sauvegarder', () => _saveDocument()),
            ]),
            
            const VerticalDivider(),
            
            // Text formatting
            _buildToolbarGroup([
              _buildToolbarButton(
                Icons.format_bold,
                'Gras',
                () => setState(() => _isBold = !_isBold),
                isActive: _isBold,
              ),
              _buildToolbarButton(
                Icons.format_italic,
                'Italique',
                () => setState(() => _isItalic = !_isItalic),
                isActive: _isItalic,
              ),
              _buildToolbarButton(
                Icons.format_underline,
                'Souligné',
                () => setState(() => _isUnderline = !_isUnderline),
                isActive: _isUnderline,
              ),
              _buildToolbarButton(
                Icons.format_strikethrough,
                'Barré',
                () => setState(() => _isStrikethrough = !_isStrikethrough),
                isActive: _isStrikethrough,
              ),
            ]),
            
            const VerticalDivider(),
            
            // Alignment
            _buildToolbarGroup([
              _buildToolbarButton(
                Icons.format_align_left,
                'Aligner à gauche',
                () => setState(() => _textAlign = TextAlign.left),
                isActive: _textAlign == TextAlign.left,
              ),
              _buildToolbarButton(
                Icons.format_align_center,
                'Centrer',
                () => setState(() => _textAlign = TextAlign.center),
                isActive: _textAlign == TextAlign.center,
              ),
              _buildToolbarButton(
                Icons.format_align_right,
                'Aligner à droite',
                () => setState(() => _textAlign = TextAlign.right),
                isActive: _textAlign == TextAlign.right,
              ),
              _buildToolbarButton(
                Icons.format_align_justify,
                'Justifier',
                () => setState(() => _textAlign = TextAlign.justify),
                isActive: _textAlign == TextAlign.justify,
              ),
            ]),
            
            const VerticalDivider(),
            
            // Font controls
            _buildToolbarGroup([
              _buildFontSizeSelector(),
              _buildColorSelector(),
              _buildFontFamilySelector(),
            ]),
            
            const VerticalDivider(),
            
            // Insert options
            _buildToolbarGroup([
              _buildToolbarButton(Icons.format_list_bulleted, 'Liste à puces', () => _insertBulletList()),
              _buildToolbarButton(Icons.format_list_numbered, 'Liste numérotée', () => _insertNumberedList()),
              _buildToolbarButton(Icons.image, 'Image', () => _insertImage()),
              _buildToolbarButton(Icons.table_chart, 'Tableau', () => _insertTable()),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarGroup(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String tooltip, VoidCallback onPressed, {bool isActive = false}) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.all(2),
        child: IconButton(
          icon: Icon(icon, size: 20),
          color: isActive ? Colors.blue : Colors.black87,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: isActive ? Colors.blue.withOpacity(0.1) : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButton<double>(
        value: _fontSize,
        isDense: true,
        underline: const SizedBox(),
        items: [12, 14, 16, 18, 20, 24, 28, 32, 36, 48]
            .map((size) => DropdownMenuItem(
                  value: size.toDouble(),
                  child: Text('$size'),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _fontSize = value);
          }
        },
      ),
    );
  }

  Widget _buildColorSelector() {
    return PopupMenuButton<Color>(
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _textColor,
          border: Border.all(color: Colors.grey),
        ),
      ),
      tooltip: 'Couleur du texte',
      onSelected: (color) => setState(() => _textColor = color),
      itemBuilder: (context) => [
        Colors.black,
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.purple,
        Colors.brown,
        Colors.grey,
      ].map((color) => PopupMenuItem(
            value: color,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: color),
            ),
          )).toList(),
    );
  }

  Widget _buildFontFamilySelector() {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButton<String>(
        value: _fontFamily,
        isDense: true,
        underline: const SizedBox(),
        items: ['Arial', 'Times New Roman', 'Courier New', 'Georgia', 'Verdana']
            .map((font) => DropdownMenuItem(
                  value: font,
                  child: Text(font, style: const TextStyle(fontSize: 12)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _fontFamily = value);
          }
        },
      ),
    );
  }

  Widget _buildDocumentArea() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _noteController,
          focusNode: _focusNode,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: _textColor,
            fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: _isUnderline
                ? TextDecoration.underline
                : _isStrikethrough
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
            backgroundColor: _highlightColor,
          ),
          textAlign: _textAlign,
          decoration: const InputDecoration(
            hintText: 'Commencez à écrire votre document...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 30,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Mots: ${_noteController.text.split(' ').where((word) => word.isNotEmpty).length}',
            style: const TextStyle(fontSize: 12),
          ),
          const Spacer(),
          Text(
            'Caractères: ${_noteController.text.length}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 16),
          if (_hasUnsavedChanges)
            const Text(
              'Modifications non sauvegardées',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          mini: true,
          heroTag: "mic",
          onPressed: () {
            setState(() {
              _isRecording = !_isRecording;
            });
          },
          backgroundColor: _isRecording ? Colors.red : const Color(0xFF00A9E0),
          child: Icon(
            _isRecording ? Icons.stop : Icons.mic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          mini: true,
          heroTag: "keyboard",
          onPressed: () {
            _focusNode.requestFocus();
          },
          backgroundColor: const Color(0xFF00A9E0),
          child: const Icon(Icons.keyboard, color: Colors.white),
        ),
      ],
    );
  }

  // Helper methods for toolbar actions
  void _showDocumentsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mes Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _createNewDocument();
                  },
                  child: const Text('Nouveau'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: _documents.isEmpty
                  ? const Center(
                      child: Text('Aucun document trouvé'),
                    )
                  : ListView.builder(
                      itemCount: _documents.length,
                      itemBuilder: (context, index) {
                        final doc = _documents[index];
                        return ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(doc.title),
                          subtitle: Text(
                            'Modifié: ${doc.modifiedAt.day}/${doc.modifiedAt.month}/${doc.modifiedAt.year}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _loadDocument(doc);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteDocument(doc);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _loadDocument(doc);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'new':
        _createNewDocument();
        break;
      case 'export':
        _exportDocument();
        break;
      case 'settings':
        _showSettings();
        break;
    }
  }

  void _exportDocument() {
    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: _noteController.text));
    _showSnackBar('Document copié dans le presse-papiers');
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paramètres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.font_download),
              title: const Text('Police par défaut'),
              subtitle: Text(_fontFamily),
              onTap: () {
                // Show font selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Taille par défaut'),
              subtitle: Text('${_fontSize.toInt()}'),
              onTap: () {
                // Show size selection
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _insertBulletList() {
    final text = _noteController.text;
    final selection = _noteController.selection;
    final newText = text.substring(0, selection.start) + '• ' + text.substring(selection.start);
    _noteController.text = newText;
    _noteController.selection = TextSelection.collapsed(offset: selection.start + 2);
  }

  void _insertNumberedList() {
    final text = _noteController.text;
    final selection = _noteController.selection;
    final newText = text.substring(0, selection.start) + '1. ' + text.substring(selection.start);
    _noteController.text = newText;
    _noteController.selection = TextSelection.collapsed(offset: selection.start + 3);
  }

  void _insertImage() {
    _showSnackBar('Fonctionnalité d\'insertion d\'image à venir');
  }

  void _insertTable() {
    final text = _noteController.text;
    final selection = _noteController.selection;
    final table = '\n| Colonne 1 | Colonne 2 | Colonne 3 |\n|-----------|-----------|----------|\n| Cellule 1 | Cellule 2 | Cellule 3 |\n';
    final newText = text.substring(0, selection.start) + table + text.substring(selection.start);
    _noteController.text = newText;
    _noteController.selection = TextSelection.collapsed(offset: selection.start + table.length);
  }
}

// Page 2: Calendar Page
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00A9E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A9E0),
        elevation: 0,
        title: const Text('Calendrier des affaires', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Date Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Avril 2023", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: const [
                    Icon(Icons.filter_list),
                    SizedBox(width: 10),
                    Icon(Icons.more_vert),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            // Week Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final days = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
                final dates = ['23', '24', '25', '26', '27', '28', '29'];
                return Column(
                  children: [
                    Text(days[index], style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      backgroundColor: dates[index] == '25' ? Colors.teal : Colors.transparent,
                      child: Text(dates[index], style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),

            // Schedule Items
            scheduleTile('8:00 – 9:30', 'Yoga', Colors.purple.shade100),
            scheduleTile('10:00 – 11:30', 'Envoyer le contrat\nPound It, LLC', Colors.orange.shade200),
            scheduleTile('12:00 – 13:30', 'Déjeuner d\'affaires', Colors.purple.shade200),
          ],
        ),
      ),
    );
  }

  Widget scheduleTile(String time, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }
}
