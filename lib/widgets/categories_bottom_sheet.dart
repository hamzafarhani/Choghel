import 'package:flutter/material.dart';
import '../screens/mainscreen.dart';

class CategoriesBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Restaurants',
      'icon': Icons.restaurant,
      'items': ['Restaurant Le Chef', 'Pasta House', 'Sushi Bar', 'Mediterranean Cuisine']
    },
    {
      'title': 'Cafés',
      'icon': Icons.coffee,
      'items': ['Café Express', 'Coffee Lab', 'Star Coffee', 'Art Café']
    },
    {
      'title': 'Salons de thé',
      'icon': Icons.local_cafe,
      'items': ['Tea House', 'Oriental Tea Room', 'Modern Tea', 'Classic Tea Shop']
    },
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Non',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WeworkHomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.category_outlined, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'Catégories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Categories List
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              padding: EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(category['icon'], color: Colors.blue[900]),
                    ),
                    title: Text(
                      category['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    children: (category['items'] as List<String>).map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            item,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sélectionné: $item'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),

          // Buttons Container
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                // Logout Button
                ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    'Déconnexion',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 