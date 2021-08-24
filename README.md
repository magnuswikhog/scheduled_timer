# ScheduledTimer

A simple timer that can be scheduled to run at a specific time. 

**Please note:** This timer only runs when the app is running - it does not schedule anything to be 
run in the background using OS-specific scheduling mechanisms, nor does it attempt to wake the device or app.  
 
 
## Installation

Add 

`scheduled_timer ^2.0.0` 

to `pubspec.yaml` and import `scheduled_timer.dart` in your `.dart` file.

For a non null-safe version, use `scheduled_timer ^1.0.0`. 


## How it works

A `ScheduledTimer` can be scheduled to run at a specific time, rather than after a certain amount of time (which is the case with the normal Flutter `Timer`).

The scheduled time is automatically stored (using `SharedPreferences`) and retrieved after an app restart. 

If a scheduled time was missed (i.e. the app was not running at the time), `ScheduledTimer` can optionally call a user defined callback function. This makes it possible to reschedule or execute the timer immediately.   
 



## Usage

```
ScheduledTimer myTimer;

myTimer = ScheduledTimer(
  id: 'myTimer', 
  onExecute: (){
    print('Executing myTimer');
  },
  defaultScheduledTime: DateTime.now().add(Duration(minutes: 10)),
  onMissedSchedule: (){
    print('myTimer missed the scheduled time');
    myTimer.execute(); // Execute onExecute() immediately
  }
);
```