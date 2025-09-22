import 'package:flutter/material.dart';

class AdvancedSearchScreen extends StatefulWidget {
  @override
  _AdvancedSearchScreenState createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  String _selectedLocation = 'Tunis';
  String _selectedDate = 'Aujourd\'hui';
  String _selectedType = 'Tous';

  final List<String> categories = [
    'Tous',
    'Espaces de travail',
    'Événements',
    'Personnes',
    'Communautés',
    'Services'
  ];

  final List<String> locations = [
    'Tunis',
    'Ariana',
    'Sousse',
    'Sfax',
    'Benzart',
    'Zaghouan'
  ];

  final List<String> dates = [
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Cette année',
    'Tout le temps'
  ];

  final List<String> types = [
    'Tous',
    'Public',
    'Privé',
    'Gratuit',
    'Payant'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche avancée'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Show filter options
                  },
                ),
              ],
            ),
          ),
          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection('Catégorie', categories, _selectedCategory, (value) {
                    setState(() => _selectedCategory = value);
                  }),
                  SizedBox(height: 16),
                  _buildFilterSection('Localisation', locations, _selectedLocation, (value) {
                    setState(() => _selectedLocation = value);
                  }),
                  SizedBox(height: 16),
                  _buildFilterSection('Date', dates, _selectedDate, (value) {
                    setState(() => _selectedDate = value);
                  }),
                  SizedBox(height: 16),
                  _buildFilterSection('Type', types, _selectedType, (value) {
                    setState(() => _selectedType = value);
                  }),
                  SizedBox(height: 24),
                  // Search Results
                  Text(
                    'Résultats de recherche',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Placeholder for search results
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Aucun résultat trouvé',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String selected, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) onChanged(option);
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[900],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[900] : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
} 