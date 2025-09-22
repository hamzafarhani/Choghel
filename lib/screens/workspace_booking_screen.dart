import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WorkspaceBookingScreen extends StatefulWidget {
  final Map<String, dynamic> workspace;

  const WorkspaceBookingScreen({
    Key? key,
    required this.workspace,
  }) : super(key: key);

  @override
  _WorkspaceBookingScreenState createState() => _WorkspaceBookingScreenState();
}

class _WorkspaceBookingScreenState extends State<WorkspaceBookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<List<bool>> seats = List.generate(4, (i) => List.generate(6, (j) => false));
  
  // Sample data for seat availability (true = available, false = reserved)
  final List<List<bool>> availableSeats = [
    [true, true, false, true, false, true],
    [true, false, true, true, true, false],
    [false, true, true, false, true, true],
    [true, true, true, true, false, true],
  ];

  // Tunis coordinates
  static const LatLng _tunis = LatLng(36.8065, 10.1815);

  @override
  void initState() {
    super.initState();
    seats = availableSeats;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver ${widget.workspace['name']}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Section
            SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _tunis,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.choghel',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _tunis,
                        width: 80,
                        height: 80,
                        child: Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.red, size: 40),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.workspace['name'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Booking Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails de la réservation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Date Selection
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
                      title: Text('Date'),
                      subtitle: Text(selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Sélectionner une date'),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.access_time, color: Colors.blueAccent),
                            title: Text('Début'),
                            subtitle: Text(startTime != null
                                ? startTime!.format(context)
                                : 'Sélectionner'),
                            onTap: () => _selectTime(context, true),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.access_time, color: Colors.blueAccent),
                            title: Text('Fin'),
                            subtitle: Text(endTime != null
                                ? endTime!.format(context)
                                : 'Sélectionner'),
                            onTap: () => _selectTime(context, false),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Seat Selection
                  Text(
                    'Sélection des places',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Les places en vert sont disponibles, en rouge sont réservées',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Seat Grid
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: seats.asMap().entries.map((row) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: row.value.asMap().entries.map((seat) {
                            return GestureDetector(
                              onTap: () {
                                if (seat.value) {
                                  setState(() {
                                    seats[row.key][seat.key] = !seats[row.key][seat.key];
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(4),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: !seat.value ? Colors.red.withOpacity(0.7) : Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${row.key + 1}${String.fromCharCode(65 + seat.key)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedDate == null || startTime == null || endTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Veuillez remplir tous les champs'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        // TODO: Implement booking confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Réservation confirmée!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        'Confirmer la réservation',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 