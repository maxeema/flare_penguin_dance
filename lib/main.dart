import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flare Penguin Dance',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with FlareController {
  double _rockAmount = 0.5;
  double _speed = 1.0;
  double _rockTime = 0.0;
  bool _isPaused = false;

  ActorAnimation _rock;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _rock = artboard.getAnimation("music_walk");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _rockTime += elapsed * _speed;
    _rock.apply(_rockTime % _rock.duration, artboard, _rockAmount);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _isPaused = !_isPaused);
        },
        tooltip: !_isPaused ? 'Pause' : 'Play',
        child: Icon(
          !_isPaused ? Icons.pause : Icons.play_arrow,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: FlareActor("assets/Penguin.flr",
                  alignment: Alignment.center,
                  isPaused: _isPaused,
                  fit: BoxFit.cover,
                  animation: "walk",
                  controller: this)),
          Positioned(
              top: 48,
              left: 0, right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: new Text("Mix Amount",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        child: new Slider(
                          value: _rockAmount,
                          min: 0.0,
                          max: 1.0,
                          divisions: null,
                          onChanged: (double value) {
                            setState(() {
                              _rockAmount = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: new Text("Speed",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        child: new Slider(
                          value: _speed,
                          min: 0.2,
                          max: 3.0,
                          divisions: null,
                          onChanged: (double value) {
                            setState(() {
                              _speed = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
