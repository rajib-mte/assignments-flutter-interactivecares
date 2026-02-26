import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TasbihScreen(),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int counter = 0;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  int selectedTheme = 0;

  final List<String> themes = [
    "https://images.unsplash.com/photo-1609599006353-e629aaabfeae",
    "https://images.unsplash.com/photo-1587613751220-4b0c3b2b87f4"
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ================= LOAD FROM STORAGE =================
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt("counter") ?? 0;
      selectedTheme = prefs.getInt("theme") ?? 0;
    });
  }

  // ================= SAVE TO STORAGE =================
  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("counter", counter);
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", selectedTheme);
  }

  // ================= TIMER =================
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
    isRunning = true;
  }

  void stopTimer() {
    timer?.cancel();
    isRunning = false;
  }

  void resetAll() {
    stopTimer();
    setState(() {
      counter = 0;
      seconds = 0;
    });
    saveCounter();
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Tasbih Counter"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// MAIN CARD
            GestureDetector(
              onTap: () {
                setState(() {
                  counter++;
                });
                saveCounter();
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.deepPurple,
                ),
                child: Stack(
                  children: [

                    /// Background Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.network(
                          themes[selectedTheme],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                    /// Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text(
                            "الله أكبر",
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.white),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              formatTime(seconds),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Tasbih Counter",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            counter.toString().padLeft(3, '0'),
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white),
                          ),

                          const SizedBox(height: 20),

                          /// CONTROL BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              IconButton(
                                icon: const Icon(Icons.refresh),
                                color: Colors.white,
                                onPressed: resetAll,
                              ),

                              const SizedBox(width: 20),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.deepPurple,
                                ),
                                onPressed: () {
                                  if (isRunning) {
                                    stopTimer();
                                  } else {
                                    startTimer();
                                  }
                                  setState(() {});
                                },
                                child: Text(isRunning ? "Stop" : "Start"),
                              ),

                              const SizedBox(width: 20),

                              IconButton(
                                icon: const Icon(Icons.pause),
                                color: Colors.white,
                                onPressed: stopTimer,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// THEME SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Theme",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(themes.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTheme = index;
                        });
                        saveTheme();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(themes[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}