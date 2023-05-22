import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);


    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream
        .listen(onStepCount)
        .onError(onStepCountError); 

    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status; 
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(255, 218, 208, 208),
          appBarTheme: const AppBarTheme(
              elevation: 20,
              titleTextStyle:
                  TextStyle(fontSize: 25, color: Color.fromARGB(198, 0, 0, 0)),
              backgroundColor: Color.fromARGB(255, 23, 209, 104))),
      home: UI(status: _status, steps: _steps),
    );
  }
}

class UI extends StatelessWidget {
  final String steps;
  final String status;

  const UI({required this.steps, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Steps taken:',
              style:
                  TextStyle(fontSize: 35, color: Color.fromARGB(198, 0, 0, 0)),
            ),
            Text(
              steps,
              style:
                  const TextStyle(fontSize: 66, color: Color.fromARGB(198, 0, 0, 0)),
            ),
            const Divider(
              height: 100,
              thickness: 4,
              color: Colors.greenAccent,
            ),
            const Text(
              'Your status:',
              style: TextStyle(fontSize: 30),
            ),
            Icon(
              status == 'walking'
                  ? Icons.directions_walk
                  : status == 'stopped'
                      ? Icons.accessibility_outlined
                      : Icons.do_not_step_sharp,
              size: 100,
            ),
            Center(
              child: Text(
                status == "?" ? "Let's start walking" : status,
                style: status == 'walking' || status == 'stopped'
                    ? const TextStyle(
                        fontSize: 30, color: Color.fromARGB(198, 0, 0, 0))
                    : const TextStyle(fontSize: 20, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
