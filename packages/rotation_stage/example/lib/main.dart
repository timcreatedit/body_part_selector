import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotation Stage Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Rotation Stage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: RotationStage(
          contentBuilder: (
            int index,
            RotationStageSide side,
            double currentPage,
          ) =>
              Padding(
            padding: const EdgeInsets.all(64),
            child: SizedBox.expand(
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.inverseSurface,
                child: Center(
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        side.map(
                          front: "Front",
                          left: "Left",
                          back: "Back",
                          right: "Right",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
