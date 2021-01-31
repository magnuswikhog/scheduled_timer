import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


///
/// A simple timer that can be scheduled to run at a specific time.
///
class ScheduledTimer{

  String _id;
  VoidCallback _onExecute;
  VoidCallback _onMissedSchedule;
  DateTime _nextRun;
  Timer _timer;



  /// Creates a new  ScheduledTimer.
  ///
  /// [id] A string identifying the timer. This is used for storing and retrieving the scheduled time across app restarts.
  ///
  /// [onExecute] The method that will be executed at the scheduled time.
  ///
  /// [defaultScheduledTime] An (optional) default scheduled time, at wich the timer will be executed if there is no previously
  /// stored schedule.
  ///
  /// [onMissedSchedule] An (optional) method to execute if the previously stored scheduled time was missed. This will happen if
  /// the app was not running at the scheduled time. Here, you can for example schedule a new time, or execute the timer function
  /// immediately. If not specified, no action will take place. The missed time will not be cleared automatically, so you'll need
  /// to supply `clearSchedule` if you want to clear the scheduled time.
  ///
  ScheduledTimer({@required String id, @required VoidCallback onExecute, DateTime defaultScheduledTime, VoidCallback onMissedSchedule}){
    _id = id;
    _onExecute = onExecute;
    _onMissedSchedule = onMissedSchedule;

    _loadStoredNextRun().then((_){
      if( _nextRun == null ){
        if( defaultScheduledTime != null ){
          schedule(defaultScheduledTime);
        }
      }
      else{
        start();
      }
    });
  }


  /// The scheduled time of execution. Will return `null` if no time is scheduled.
  DateTime get scheduledTime => _nextRun;

  /// A string identifying this timer. Used to store and retrieve the scheduled time across app restarts.
  String get id => _id;




  /// Stop the timer if it's running.
  void stop(){
    _timer?.cancel();
  }


  // Schedule the next execution. The scheduled time will be stored and automatically retrieved if the app is restarted.
  void schedule(DateTime scheduledTime) async {
    stop();
    await _setNextRun(scheduledTime);
    start();
  }


  /// Stop the timer and clear any scheduled execution time.
  void clearSchedule() async {
    stop();
    await _clearNextRun();
  }


  /// Start the timer if it was stopped. It's not necessary to call `start()` manually if you didn't previously stop the timer -
  /// the timer will be started automatically after it is created.
  void start() async {
    _timer?.cancel();

    if( _nextRun != null ){
      Duration diff = _nextRun.difference(DateTime.now());

      if( !diff.isNegative ){
        _timer = Timer(diff, () async {
          await _clearNextRun();
          _onExecute();
        });
      }
      else{
        if( _onMissedSchedule != null ){
          _onMissedSchedule();
        }
      }
    }
  }


  /// Manually execute the timer function.
  void execute(){
    _onExecute();
  }



  Future<void> _setNextRun(DateTime nextRun) async {
      _nextRun = nextRun;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('_scheduledtimer_nextrun_$_id', _nextRun.millisecondsSinceEpoch);
  }

  Future<void> _clearNextRun() async {
      _nextRun = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('_scheduledtimer_nextrun_$_id');
  }

  Future<void> _loadStoredNextRun() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int ts = prefs.getInt('_scheduledtimer_nextrun_$_id');
      if( ts != null ) _nextRun = DateTime.fromMillisecondsSinceEpoch(ts);
  }


}
