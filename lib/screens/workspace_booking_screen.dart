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
    final selectedSeatCodes = _selectedSeatCodes();
    final durationHours = _calculateDurationHours();

    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver ${widget.workspace['name']}'),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final error = _validate();
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error), backgroundColor: Colors.red),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Réservation confirmée!'), backgroundColor: Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Confirmer'),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Card
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 220,
                      child: FlutterMap(
                        options: MapOptions(initialCenter: _tunis, initialZoom: 15),
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
                                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                      ),
                                      child: Text(widget.workspace['name'], style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Step 1: Date & Time
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildStepCard(
                  title: '1. Date et horaires',
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
                        title: Text('Date'),
                        subtitle: Text(selectedDate != null
                            ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                            : 'Sélectionner une date'),
                        onTap: () => _selectDate(context),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _timeCard(
                              label: 'Début',
                              value: startTime?.format(context) ?? 'Sélectionner',
                              onTap: () => _selectTime(context, true),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _timeCard(
                              label: 'Fin',
                              value: endTime?.format(context) ?? 'Sélectionner',
                              onTap: () => _selectTime(context, false),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          durationHours > 0 ? 'Durée ~ ${durationHours.toStringAsFixed(1)} h' : 'Durée inconnue',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Step 2: Seats
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildStepCard(
                  title: '2. Sélection des places',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _legendDot(color: Colors.green),
                          SizedBox(width: 6),
                          Text('Disponible'),
                          SizedBox(width: 16),
                          _legendDot(color: Colors.red.withOpacity(0.7)),
                          SizedBox(width: 6),
                          Text('Réservée'),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: seats.asMap().entries.map((row) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: row.value.asMap().entries.map((seat) {
                                final isAvailable = seat.value;
                                final isSelected = isAvailable && seats[row.key][seat.key] == false ? false : isAvailable && !seats[row.key][seat.key] ? false : isAvailable && seats[row.key][seat.key];
                                // We treat seats[][] as toggled selection only if available
                                final currentlySelected = isAvailable && seats[row.key][seat.key];
                                return GestureDetector(
                                  onTap: () {
                                    if (isAvailable) {
                                      setState(() {
                                        seats[row.key][seat.key] = !seats[row.key][seat.key];
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 150),
                                    margin: EdgeInsets.all(4),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: !isAvailable
                                          ? Colors.red.withOpacity(0.7)
                                          : (currentlySelected ? Colors.blueAccent : Colors.green),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${row.key + 1}${String.fromCharCode(65 + seat.key)}',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (selectedSeatCodes.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedSeatCodes
                              .map((code) => Chip(
                                    label: Text(code),
                                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                    labelStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Helpers UI
  Widget _buildStepCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 20,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(3)),
              ),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _timeCard({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.blueAccent),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[700])),
                Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _legendDot({required Color color}) {
    return Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  List<String> _selectedSeatCodes() {
    final List<String> codes = [];
    for (int r = 0; r < seats.length; r++) {
      for (int c = 0; c < seats[r].length; c++) {
        if (availableSeats[r][c] && seats[r][c]) {
          codes.add('${r + 1}${String.fromCharCode(65 + c)}');
        }
      }
    }
    return codes;
  }

  double _calculateDurationHours() {
    if (selectedDate == null || startTime == null || endTime == null) return 0;
    final start = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, startTime!.hour, startTime!.minute);
    final end = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, endTime!.hour, endTime!.minute);
    final diff = end.difference(start).inMinutes / 60.0;
    return diff > 0 ? diff : 0;
  }

  String? _validate() {
    if (selectedDate == null) return 'Veuillez sélectionner une date';
    if (startTime == null) return 'Veuillez sélectionner l\'heure de début';
    if (endTime == null) return 'Veuillez sélectionner l\'heure de fin';
    if (_calculateDurationHours() <= 0) return 'L\'heure de fin doit être après l\'heure de début';
    if (_selectedSeatCodes().isEmpty) return 'Veuillez sélectionner au moins une place';
    return null;
  }
} 