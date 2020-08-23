import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StopWatch(title: 'StopWatch'),
    );
  }
}

class StopWatch extends StatefulWidget {
  StopWatch({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int _time = 0;
  Timer _timer;
  bool _isPlayingTimer = false;
  List<String> _lapTimes = List<String>();

  void _handleTimer() {
    if(_isPlayingTimer) {
      _cancelTimer();
    } else {
      _startTimer();
    }
  }

  void _resetTimer() {
    if(_isPlayingTimer) {
      _cancelTimer();
    }
    _lapTimes.clear();
    setState(() {
      _time = 0;
    });
  }

  void _startTimer() {
    _isPlayingTimer = true;
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _cancelTimer() {
    _isPlayingTimer = false;
    _timer.cancel();
  }

  void _addLapTime() {
    String sec = (_time / 100).toInt().toString();
    String millSec = (_time % 100).toString();

    String lapTime = '${_lapTimes.length + 1}등 $sec.$millSec';
    setState(() {
      _lapTimes.add(lapTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Text((_time / 100).toInt().toString(),
                          style: TextStyle(fontSize: 20),),
                        Text((_time % 100).toString(), style: TextStyle(fontSize: 10),)
                      ]
                  ),
                  Container(
                    width: 100,
                    height: 200,
                    child: ListView(
                      children: _lapTimes.map((i) =>
                          ListTile(
                            title: Text(i)
                          )
                      ).toList(),
                      reverse: true,
                    )
                  )
                ]
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: _resetTimer,
                  tooltip: 'reset',
                  child: Icon(Icons.refresh),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child:Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    child: Text('랩타임'),
                    onPressed: _addLapTime,
                  )
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleTimer,
        tooltip: 'start',
        child: _isPlayingTimer ? Icon(Icons.stop) : Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 52,
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
