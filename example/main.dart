import 'package:scheduled_timer/scheduled_timer.dart';



void main() async {

  /// Example 1
  /// One-off execution after 10 minutes (or more).
  ///
  /// If the app is stopped, and restarted again within 10 minutes, the scheduled time will be
  /// automatically retrieved and the function executed as scheduled.
  ///
  /// If the app is stopped, and restarted again after more than 10 minutes, `onMissedSchedule` will
  /// be executed immediately - which will in turn execute `onExecute`.
  late ScheduledTimer example1;
  example1 = ScheduledTimer(
    id: 'example1',
    onExecute: (){
      print('Executing example1');
    },
    defaultScheduledTime: DateTime.now().add(Duration(minutes: 10)),
    onMissedSchedule: (){
      example1.execute();
    }
  );



  /// Example 2
  /// Periodic execution every 10 minutes (or more).
  ///
  /// We're scheduling a new execution after 10 minutes every time the timer executes, which will
  /// create a "periodic" timer.
  ///
  /// If the app is stopped, and restarted again within 10 minutes, the scheduled time will be
  /// automatically retrieved and the function executed as scheduled.
  ///
  /// If the app is stopped, and restarted again after more than 10 minutes, `onMissedSchedule` will
  /// be executed immediately - which will in turn execute `onExecute`.
  late ScheduledTimer example2;
  example2 = ScheduledTimer(
    id: 'example2',
    onExecute: (){
      print('Executing example2');

      // Schedule the next execution 10 minutes from now. This will create a "periodic" timer,
      // which will self-execute every 10 minutes.
      example2.schedule(DateTime.now().add(Duration(minutes: 10)));
    },
    defaultScheduledTime: DateTime.now(),
    onMissedSchedule: (){
      example2.execute();
    }
  );

}