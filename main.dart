import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const SwiftPlannerApp());
}

class SwiftPlannerApp extends StatelessWidget {
  const SwiftPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Swift Planner',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class Assignment {
  String title;
  DateTime dueDate;
  String difficulty; // 'Lover', 'Red', 'Reputation'

  Assignment(this.title, this.dueDate, this.difficulty);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dummy Data for your assignments
  List<Assignment> assignments = [
    Assignment("History Essay", DateTime.now().add(const Duration(hours: 10)), "Red"),
    Assignment("Math Worksheet", DateTime.now().add(const Duration(days: 2)), "Lover"),
    Assignment("Final Thesis", DateTime.now().add(const Duration(days: 8)), "Reputation"),
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Updates the countdown every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showPanicQuote() {
    List<String> quotes = [
      "Breathe in, breathe through, breathe deep, breathe out.",
      "You're on your own, kid. You always have been. And you can face this.",
      "Long story short, you will survive.",
      "Just keep dancing like we're 22! (After you finish studying)"
    ];
    String randomQuote = quotes[Random().nextInt(quotes.length)];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(randomQuote, style: const TextStyle(fontStyle: FontStyle.italic)),
        backgroundColor: Colors.deepPurpleAccent,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _getLyricsMood(Duration timeRemaining) {
    if (timeRemaining.inDays > 7) {
      return "Take your time... 'I can see the end as it begins...'";
    } else if (timeRemaining.inHours < 12) {
      return "Deadline incoming! 'Are we out of the woods yet?!'";
    } else {
      return "Keep going... 'This is me trying...'";
    }
  }

  Color _getEraColor(String difficulty) {
    switch (difficulty) {
      case 'Lover':
        return Colors.pink[200]!;
      case 'Red':
        return Colors.red[700]!;
      case 'Reputation':
        return Colors.black87; // Dark with silver accents handled in UI
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deadlines (Taylor's Version)"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Week (Load Graph)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Fake simple load graph
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("📊 Heavy week! You have 3 tasks.")),
            ),
            const SizedBox(height: 20),
            const Text(
              "Assignments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final task = assignments[index];
                  final timeRemaining = task.dueDate.difference(DateTime.now());
                  final lyricsMood = _getLyricsMood(timeRemaining);

                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: task.difficulty == 'Reputation' ? Colors.grey[400]! : Colors.transparent,
                        width: task.difficulty == 'Reputation' ? 2 : 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mood: $lyricsMood"),
                          const SizedBox(height: 5),
                          Text(
                            timeRemaining.inHours > 0
                                ? "Time left: ${timeRemaining.inHours}h ${timeRemaining.inMinutes.remainder(60)}m"
                                : "DEADLINE PASSED",
                            style: TextStyle(
                              color: timeRemaining.inHours < 24 ? Colors.redAccent : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: 1.0, // Represents the Era difficulty block
                            color: _getEraColor(task.difficulty),
                            backgroundColor: Colors.grey[800],
                          )
                        ],
                      ),
                      trailing: Icon(
                        Icons.music_note,
                        color: _getEraColor(task.difficulty),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPanicQuote,
        label: const Text("Panic Button"),
        icon: const Icon(Icons.warning_amber_rounded),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}