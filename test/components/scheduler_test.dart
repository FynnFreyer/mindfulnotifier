import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:mindfulnotifier/components/scheduler.dart';
import 'package:mindfulnotifier/components/quiethours.dart';

void main() {
  Scheduler scheduler;

  bool initialized = false;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    scheduler = Scheduler();
    if (!initialized) {
      scheduler.init();
      initialized = true;
    }
  });
  tearDown(() {});

  group('Periodic', () {
    test('test schedule 15m', () {
      PeriodicScheduler delegate =
          PeriodicScheduler(scheduler, QuietHours.defaultQuietHours(), 0, 15);
      scheduler.delegate = delegate;
      DateTime dt = DateTime(2020, 1, 1, 0, 5);
      DateTime start = delegate.getInitialStart(now: dt);
      print("start: $start");
      expect(start.minute, 15);

      dt = DateTime(2020, 1, 1, 0, 0);
      start = delegate.getInitialStart(now: dt);
      expect(start.minute, 15);

      dt = DateTime(2020, 1, 1, 0, 14, 59);
      start = delegate.getInitialStart(now: dt);
      expect(start.minute, 15);

      dt = DateTime(2020, 1, 1, 0, 15);
      start = delegate.getInitialStart(now: dt);
      expect(start.minute, 30);
    });
    test('test schedule 30m', () {
      PeriodicScheduler delegate =
          PeriodicScheduler(scheduler, QuietHours.defaultQuietHours(), 0, 30);
      scheduler.delegate = delegate;
      // scheduler.durationMinutes = 30;
      DateTime dt = DateTime(2020, 1, 1, 0, 5);
      DateTime start = delegate.getInitialStart(now: dt);
      print("start: $start");
      expect(start.minute, 30);

      dt = DateTime(2020, 1, 1, 0, 0);
      start = delegate.getInitialStart(now: dt);
      expect(start.minute, 30);

      dt = DateTime(2020, 1, 1, 0, 14, 59);
      start = delegate.getInitialStart(now: dt);
      expect(start.minute, 30);

      dt = DateTime(2020, 1, 1, 0, 15);
      start = delegate.getInitialStart(now: dt);
      expect(start.minute, 30);
    });
  });

  group('Random', () {
    test('test schedule 15m', () {});
  });

  group('Quiet Hours', () {
    test('quiet hours - before quiet', () {
      var quiet9pm9am = QuietHours(
          TimeOfDay(hour: 21, minute: 0), TimeOfDay(hour: 9, minute: 0), false);
      DateTime dt = DateTime.parse("2020-01-01 14:00:00");
      expect(quiet9pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0));
      expect(quiet9pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0).add(Duration(days: 1)));
      expect(false, quiet9pm9am.isInQuietHours(dt));
    });
    test('quiet hours - in quiet', () {
      var quiet9pm9am = QuietHours(
          TimeOfDay(hour: 21, minute: 0), TimeOfDay(hour: 9, minute: 0), false);
      DateTime dt = DateTime.parse("2020-01-01 22:00:00");
      expect(quiet9pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0).add(Duration(days: 1)));
      expect(quiet9pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0).add(Duration(days: 1)));
      expect(true, quiet9pm9am.isInQuietHours(dt));

      dt = DateTime.parse("2020-01-01 08:00:00");
      expect(quiet9pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0));
      expect(quiet9pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0));
      expect(true, quiet9pm9am.isInQuietHours(dt));

      // edge case
      dt = DateTime.parse("2020-01-01 21:00:00");
      expect(quiet9pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0));
      expect(quiet9pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0).add(Duration(days: 1)));
      expect(true, quiet9pm9am.isInQuietHours(dt));

      dt = DateTime.parse("2020-01-01 08:59:00");
      expect(quiet9pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0));
      expect(quiet9pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0));
      expect(true, quiet9pm9am.isInQuietHours(dt));
      dt = DateTime.parse("2020-01-01 09:00:00");
      expect(quiet9pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0));
      expect(quiet9pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0));
      expect(false, quiet9pm9am.isInQuietHours(dt));
    });
    test('quiet hours - midnight', () {
      // start @11:55pm
      var quiet1155pm9am = QuietHours(TimeOfDay(hour: 23, minute: 55),
          TimeOfDay(hour: 9, minute: 0), false);
      // before quiet:
      DateTime dt = DateTime.parse("2020-01-01 23:00:00");
      expect(quiet1155pm9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 23, 55));
      expect(quiet1155pm9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0).add(Duration(days: 1)));
      expect(false, quiet1155pm9am.isInQuietHours(dt));
      for (dt in [
        DateTime.parse("2020-01-01 23:57:00"),
        DateTime.parse("2020-01-02 01:57:00"),
        DateTime.parse("2020-01-02 01:58:00")
      ]) {
        expect(true, quiet1155pm9am.isInQuietHours(dt));
      }
      for (dt in [
        DateTime.parse("2020-01-01 11:00:00"),
        DateTime.parse("2020-01-02 11:00:00"),
        DateTime.parse("2020-01-03 11:00:00"),
        DateTime.parse("2020-01-01 23:00:00"),
        DateTime.parse("2020-01-02 23:00:00"),
      ]) {
        expect(false, quiet1155pm9am.isInQuietHours(dt));
      }
      for (dt in [
        DateTime.parse("2020-01-01 00:00:00"),
        DateTime.parse("2020-01-02 00:00:00"),
        DateTime.parse("2020-01-01 23:57:00"),
        DateTime.parse("2020-01-02 01:00:00"),
        DateTime.parse("2020-01-02 01:57:00"),
      ]) {
        expect(true, quiet1155pm9am.isInQuietHours(dt));
      }
    });
    test('quiet hours - late start', () {
      // start @1am
      var quiet1am9am = QuietHours(
          TimeOfDay(hour: 1, minute: 0), TimeOfDay(hour: 9, minute: 0), false);
      // before quiet:
      DateTime dt = DateTime.parse("2020-01-01 22:00:00");
      expect(quiet1am9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 1, 0).add(Duration(days: 1)));
      expect(quiet1am9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0).add(Duration(days: 1)));
      for (dt in [
        DateTime.parse("2020-01-01 01:00:00"),
        DateTime.parse("2020-01-02 01:00:00"),
        DateTime.parse("2020-01-01 01:57:00"),
        DateTime.parse("2020-01-02 01:57:00"),
        DateTime.parse("2020-01-01 03:30:00"),
      ]) {
        expect(true, quiet1am9am.isInQuietHours(dt));
      }
      for (dt in [
        DateTime.parse("2020-01-01 09:01:00"),
        DateTime.parse("2020-01-01 00:00:00"),
        DateTime.parse("2020-01-02 00:00:00"),
        DateTime.parse("2020-01-01 23:57:00"),
        DateTime.parse("2020-01-02 14:00:00"),
      ]) {
        expect(false, quiet1am9am.isInQuietHours(dt));
      }

      // in quiet:
      dt = DateTime.parse("2020-01-02 02:00:00");
      expect(quiet1am9am.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 1, 0).add(Duration(days: 1)));
      expect(quiet1am9am.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0));
    });

    test('quiet hours - after quiet', () {
      var quietHours = QuietHours(
          TimeOfDay(hour: 21, minute: 0), TimeOfDay(hour: 9, minute: 0), false);
      DateTime dt = DateTime.parse("2020-01-01 10:00:00");
      expect(quietHours.getNextQuietStart(current: dt),
          DateTime(dt.year, dt.month, dt.day, 21, 0));
      expect(quietHours.getNextQuietEnd(current: dt),
          DateTime(dt.year, dt.month, dt.day, 9, 0).add(Duration(days: 1)));
    });
  });
}
