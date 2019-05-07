import 'package:flutter/material.dart';
import 'package:flutter_app/bezier_painter.dart';

void main() {
//  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
  runApp(new MyApp());
//  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool isMove = false;
  AnimationController _controller;
  double appBarHeight = 10.0;
  double statusBarHeight = 0.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Size end;
  Size begin;
  Offset during1;
  Offset end1;
  GlobalKey<State<StatefulWidget>> anchorKey;
  Animation<Size> movement;

  @override
  void initState() {
    super.initState();
    var appBar = new AppBar(title: new Text("drag"));
    appBarHeight = appBar.preferredSize.height;
    anchorKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Home Page"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              RenderBox renderBox = anchorKey.currentContext.findRenderObject();
                              var icon = renderBox.localToGlobal(Offset.zero);
                              end = Size(icon.dx + 12, icon.dy - appBarHeight - statusBarHeight - 20);
                              end1 = Offset(icon.dx + 12, icon.dy - appBarHeight - statusBarHeight - 20);
                              during1 = Offset(icon.dx + 12, icon.dy - appBarHeight - statusBarHeight - 20);
                            });
                          },
                          child: Text('生成消息')),
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  height: 81,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.android,
                            key: anchorKey,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: null),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(foregroundPainter: BezierPainter(during1, end1)),
          Positioned(
              top: end != null ? end.height : 0,
              left: end != null ? end.width: 0 ,
              child: GestureDetector(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.transparent,
//                    child: Text('12313'),
                  ),
                  onPanUpdate: (d) {
                    setState(() {
                      double dx = d.globalPosition.dx;
                      double dy = d.globalPosition.dy - appBarHeight - statusBarHeight;
                      during1 = Offset(dx, dy);
                    });
                  },
                  onPanEnd: (d) {
                    begin = Size(during1.dx, during1.dy);
                    comeBack();
                    print('onPanEnd : ' + d.toString());
                  })),
        ],
      ),
    );
  }

  comeBack() {
    _controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    _controller.value;
    movement = SizeTween(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // 动画执行时间所占比重
        curve: ElasticOutCurve(0.6),
      ),
    )
      ..addListener(() {
        setState(() {
          during1 = Offset(movement.value.width, movement.value.height);
        });
      })
      ..addStatusListener((AnimationStatus status) {
        print(status);
      });
    _controller.reset();
    _controller.forward();
  }
}
