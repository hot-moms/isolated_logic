import 'dart:async';

import 'package:example/app_dependencies.dart';
import 'package:example/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:isolated_logic/isolated_logic.dart';

void main() async {
  await logicalHandler.init(
    observer: IsolatedControllerObserver.dartLog(),
    dependencies: AppDependencies(
      dependency: TransitiveDependency(httpClient: Client()),
    ),
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
  late final PrimesBLoC _counterMain = PrimesBLoC(TransitiveDependency(httpClient: Client()))
    ..stream.listen(_streamController.add);
  // final _deps = TransitiveDependency(httpClient: Client());
  late final JsonBlocIsolated _counterIsolated =
      JsonBlocIsolated(createController: (deps) => PrimesBLoC(deps.dependency))..stream.listen(_streamController.add);

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
      floatingActionButton: GestureDetector(
          onTap: () => _counterMain.add(const JsonEvent.increment()),
          onLongPress: _counterIsolated.increment,
          child: const DecoratedBox(
            decoration: BoxDecoration(color: Colors.greenAccent),
            child: Padding(padding: EdgeInsets.all(24), child: Icon(Icons.plus_one)),
          )),
    );
  }
}
