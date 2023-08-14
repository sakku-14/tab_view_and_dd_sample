import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: TabView(),
    );
  }
}

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 3, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                  child: DragTargetCard(
                title: 'A',
              )),
              Tab(
                  child: DragTargetCard(
                title: 'B',
              )),
              Tab(
                  child: DragTargetCard(
                title: 'C',
              )),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Column(
              children: [
                DraggableCard(color: Colors.red),
              ],
            ),
            Column(
              children: [
                DraggableCard(color: Colors.blue),
              ],
            ),
            Column(
              children: [
                DraggableCard(color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ユーザーにドラッグされる側のWidget
class DraggableCard extends StatelessWidget {
  const DraggableCard({super.key, required this.color});

  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: color.toString(),
      child: Container(
        width: 100,
        height: 100,
        color: color,
      ),
      feedback: Container(
        width: 100,
        height: 100,
        color: color.withOpacity(0.5),
      ),
      childWhenDragging: Container(
        width: 100,
        height: 100,
        color: color,
      ),
      // ドラッグ開始時に呼ばれる
      onDragStarted: () {
        print('onDragStarted');
      },
      // ドラッグ終了時に呼ばれる
      onDragEnd: (DraggableDetails details) {
        print('onDragEnd - $details');
      },
      // ドラッグがDragTargetで受け入れられた時に呼ばれる
      onDragCompleted: () {
        print('onDragCompleted');
      },
      // ドラッグがキャンセルされた時に呼ばれる
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        print('onDraggableCanceled - velocity:$velocity , offset:$offset');
      },
    );
  }
}

// ユーザーにドロップされる側のWidget
class DragTargetCard extends StatefulWidget {
  const DragTargetCard({super.key, required this.title});

  final String title;

  @override
  State<DragTargetCard> createState() => _DragTargetCardState();
}

class _DragTargetCardState extends State<DragTargetCard> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, accepted, rejected) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.title),
              Text(message),
            ],
          ),
        );
      },
      // DragTarget の範囲に入った時に呼ばれる
      onWillAccept: (data) {
        print('onWillAccept - $data');
        // ドラッグ操作を受け入れる場合はここでtrueを返す
        setState(() {
          message = '範囲に入ったよ！！！';
        });
        return true;
      },
      // DragTargetにドラッグされた時に呼ばれる
      onAccept: (data) {
        print('onAccept - $data');
        setState(() {
          message = data.toString();
        });
      },
      // DragTarget の範囲から離れた時に呼ばれる
      onLeave: (data) {
        print('onLeave - $data');
        setState(() {
          message = '範囲から離れたよ！！！';
        });
      },
    );
  }
}
