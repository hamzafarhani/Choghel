import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TableReservationScreen(),
    );
  }
}

class TableReservationScreen extends StatefulWidget {
  @override
  _TableReservationScreenState createState() => _TableReservationScreenState();
}

class _TableReservationScreenState extends State<TableReservationScreen> {
  // Example table data: 0 = free, 1 = reserved, 2 = your table
  final List<int> tableStatus = List.generate(30, (index) => 0);

  void selectTable(int index) {
    setState(() {
      if (tableStatus[index] == 0) {
        tableStatus[index] = 2; // Mark as "Your Table"
      } else if (tableStatus[index] == 2) {
        tableStatus[index] = 0; // Deselect
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = tableStatus.where((s) => s == 2).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation de tables'),
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tables sélectionnées', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text('$selectedCount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedCount == 0
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tables confirmées: $selectedCount'), backgroundColor: Colors.green),
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
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sélectionnez votre table', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: const [
                    _LegendDot(color: Colors.green),
                    SizedBox(width: 6),
                    Text('Libre'),
                    SizedBox(width: 16),
                    _LegendDot(color: Colors.red),
                    SizedBox(width: 6),
                    Text('Réservée'),
                    SizedBox(width: 16),
                    _LegendDot(color: Colors.blue),
                    SizedBox(width: 6),
                    Text('Votre table'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: tableStatus.length,
              itemBuilder: (context, index) {
                final status = tableStatus[index];
                final color = status == 0
                    ? Colors.green
                    : status == 1
                        ? Colors.red
                        : Colors.blueAccent;
                return GestureDetector(
                  onTap: () => selectTable(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: Center(
                      child: Text(
                        'T${index + 1}',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
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

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
