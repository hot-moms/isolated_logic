import 'dart:async';

import 'package:example/primes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:isolated_logic/isolated_logic.dart';

void main() async {
  await logicalHandler.init(
    observer: IsolatedControllerObserver.dartLog(),
    dependencies: Object(),
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PrimesBLoC _counterMain = PrimesBLoC()..stream.listen(_streamController.add);
  // final _deps = TransitiveDependency(httpClient: Client());
  late final JsonBlocIsolated _counterIsolated = JsonBlocIsolated(createController: (deps) => PrimesBLoC())
    ..stream.listen(_streamController.add);

  final _streamController = StreamController.broadcast();
  late final stream = _streamController.stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: (context, data) => ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text('${data.data}'),
                ),
              )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: _counterIsolated.increment,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.greenAccent),
                child: Padding(padding: EdgeInsets.all(24), child: Icon(Icons.play_arrow)),
              )),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
              onTap: () => _counterMain.add(const SomeCoolEvent.increment()),
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.redAccent),
                child: Padding(padding: EdgeInsets.all(24), child: Icon(Icons.running_with_errors)),
              ))
        ],
      ),
    );
  }
}
