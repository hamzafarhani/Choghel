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
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Reservation'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Your Table',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // Number of tables per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: tableStatus.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => selectTable(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tableStatus[index] == 0
                          ? Colors.green
                          : tableStatus[index] == 1
                              ? Colors.red
                              : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'T${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LegendItem(color: Colors.green, label: 'Free Table'),
                LegendItem(color: Colors.red, label: 'Reserved Table'),
                LegendItem(color: Colors.blue, label: 'Your Table'),
              ],
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
