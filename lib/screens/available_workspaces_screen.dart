import 'package:flutter/material.dart';
import 'workspace_booking_screen.dart';

class AvailableWorkspacesScreen extends StatelessWidget {
  final String city;
  final String workspaceType;

  const AvailableWorkspacesScreen({
    Key? key,
    required this.city,
    required this.workspaceType,
  }) : super(key: key);

  // Sample data for available workspaces
  static const List<Map<String, dynamic>> availableWorkspaces = [
    {
      'name': 'Espace Co-working Premium',
      'location': 'Centre-ville',
      'price': '50 DT/jour',
      'capacity': '10 personnes',
      'amenities': const ['WiFi', 'Café', 'Imprimante', 'Salle de réunion'],
      'color': Colors.blue,
    },
    {
      'name': 'Bureau Privé Pro',
      'location': 'Zone d\'affaires',
      'price': '800 DT/mois',
      'capacity': '4 personnes',
      'amenities': const ['WiFi', 'Parking', 'Salle de réunion privée', 'Service de conciergerie'],
      'color': Colors.green,
    },
    {
      'name': 'Espace Flexible',
      'location': 'Quartier des affaires',
      'price': '30 DT/jour',
      'capacity': '6 personnes',
      'amenities': const ['WiFi', 'Café', 'Espace détente', 'Imprimante'],
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espaces disponibles à $city'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(Icons.filter_list),
                SizedBox(width: 8),
                Text(
                  'Type sélectionné: $workspaceType',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Workspaces List
          Expanded(
            child: ListView.builder(
              itemCount: availableWorkspaces.length,
              itemBuilder: (context, index) {
                final workspace = availableWorkspaces[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Workspace Image Placeholder
                      Container(
                        height: 200,
                        color: workspace['color'],
                        child: Center(
                          child: Icon(
                            Icons.work_outline,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              workspace['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Location
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(workspace['location']),
                              ],
                            ),
                            SizedBox(height: 8),
                            
                            // Capacity
                            Row(
                              children: [
                                Icon(Icons.people, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(workspace['capacity']),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Amenities
                            Wrap(
                              spacing: 8,
                              children: (workspace['amenities'] as List<String>).map<Widget>((amenity) {
                                return Chip(
                                  label: Text(amenity),
                                  backgroundColor: Colors.blue[50],
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                            
                            // Book Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkspaceBookingScreen(
                                        workspace: workspace,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text('Réserver cet espace'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 