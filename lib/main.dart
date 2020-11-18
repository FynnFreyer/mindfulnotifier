import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  runApp(RemindfulApp());
}

class RemindfulApp extends StatelessWidget {
  static const String _title = 'ReMindful';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: RemindfulHomePage(title: _title),
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class RemindfulHomePage extends StatefulWidget {
  RemindfulHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RemindfulHomePageState createState() => _RemindfulHomePageState();
}

class _RemindfulHomePageState extends State<RemindfulHomePage> {
  String _message = 'Not Running';
  bool _enabled = false;
  bool _mute = false;
  Scheduler scheduler = PeriodicScheduler(0, 1);

  void _setEnabled(bool enabled) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _enabled = enabled;
      if (_enabled) {
        scheduler.enable();
      } else {
        scheduler.disable();
      }
    });
  }

  void _setMute(bool mute) {
    setState(() {
      _mute = mute;
    });
  }

  void _setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              '$_message',
              style: Theme.of(context).textTheme.headline4,
            ),
            // Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Enabled'),
                    Switch(
                      value: _enabled,
                      onChanged: _setEnabled,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Mute'),
                    Switch(
                      value: _mute,
                      onChanged: _setMute,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              //leading: Icon(Icons.message),
              leading: Icon(Icons.schedule),
              title: Text('Schedule'),
              onTap: null,
            ),
            ListTile(
              // leading: Icon(Icons.alarm),
              leading: Icon(Icons.list),
              title: Text('Reminders'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Bell'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Advanced'),
              onTap: null,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _setEnabled(true),
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

enum ScheduleType { PERIODIC, RANDOM }

abstract class Scheduler {
  final ScheduleType scheduleType;
  final int alarmID = 0;
  bool running = false;

  // a basic singleton:
  static Scheduler onlyInstance;

  Scheduler(this.scheduleType) {
    onlyInstance = this;
  }

  void init() async {
    await AndroidAlarmManager.initialize();
  }

  void cancel() async {
    await AndroidAlarmManager.cancel(alarmID);
  }

  void enable() {
    running = true;
  }

  void disable() {
    cancel();
    running = false;
  }

  void triggerNotification() {
    // TODO: tie in the code to:
    // 1) lookup a random reminder
    // 2) trigger a notification based on
    //    https://pub.dev/packages/flutter_local_notifications
  }

  void schedule();

  static void alarmCallback() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=$isolateId function='$alarmCallback'");
    onlyInstance.triggerNotification();
    if (onlyInstance.scheduleType == ScheduleType.RANDOM) {
      onlyInstance.schedule();
    }
  }
}

class PeriodicScheduler extends Scheduler {
  final int durationHours;
  final int durationMinutes;
  PeriodicScheduler(this.durationHours, this.durationMinutes)
      : super(ScheduleType.PERIODIC);

  void cancel() async {
    super.cancel();
  }

  void schedule() async {
    await AndroidAlarmManager.periodic(
        Duration(hours: durationHours, minutes: durationMinutes),
        alarmID,
        alarmCallback);
  }
}

class RandomScheduler extends Scheduler {
  //DateTimeRange range;
  final int minMinutes;
  final int maxMinutes;
  RandomScheduler(this.minMinutes, this.maxMinutes)
      : super(ScheduleType.RANDOM);

  void cancel() async {
    super.cancel();
  }

  void schedule() async {
    Random random = new Random();
    int nextMinutes = minMinutes + random.nextInt(maxMinutes - minMinutes);
    DateTime nextDate = DateTime.now().add(Duration(microseconds: nextMinutes));
    await AndroidAlarmManager.oneShotAt(nextDate, alarmID, alarmCallback);
  }
}
