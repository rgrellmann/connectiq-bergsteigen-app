using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.System;
using Toybox.ActivityRecording;
using Toybox.Activity;
using Toybox.Attention;
using Toybox.Position;

var debug = true;

function println(message) {
    if (debug) {
        System.println(message);
    }
}

class BergsteigenApp extends Application.AppBase {

    /* @var ActivityRecording.Session */
    var session;

    /* @var WatchUi.DataField[] */
    var views;

    /* @var Number */
    var currentViewNumber;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        println("BergsteigenApp.onStart");
        startSensor();
        startGPS();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        println("BergsteigenApp.onStop");
        stopSensor();
        stopGPS();
    }

    // Return the initial view of your application here
    function getInitialView() {
        println("BergsteigenApp.getInitialView");
        views = [
            new BergsteigenDataField1View(),
            new BergsteigenDataField2View(),
        ];
        currentViewNumber = 0;
        var delegate = new BergsteigenDataFieldDelegate();
        return [views[0], delegate];
    }

    // Return the next view (or the first, if the current view is the last) and set the currentViewNumber
    function getNextView() {
        println("BergsteigenApp.getNextView");
        if (views != null) {
            if (currentViewNumber >= (views.size() - 1) || currentViewNumber < 0 || currentViewNumber == null) {
                currentViewNumber = 0;
            } else {
                currentViewNumber++;
            }
            return views[currentViewNumber];
        }
        return null;
    }

    // Return the previous view (or the last, if the current view is the first) and set the currentViewNumber
    function getPreviousView() {
        println("BergsteigenApp.getPreviousView");
        if (views != null) {
            if (currentViewNumber <= 0 || currentViewNumber > (views.size() - 1) || currentViewNumber == null) {
                currentViewNumber = views.size() - 1;
            } else {
                currentViewNumber--;
            }
            return views[currentViewNumber];
        }
        return null;
    }

    // enable GPS
    function startGPS() {
        println("BergsteigenApp.startGPS");
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    // disable GPS
    function stopGPS() {
        println("BergsteigenApp.stopGPS");
        Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
    }

    // enable sensor events
    function startSensor() {
        println("BergsteigenApp.startSensor");
        Sensor.enableSensorEvents(method(:onSensor));
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE]);
    }

    // disable sensor events
    function stopSensor() {
        println("BergsteigenApp.stopSensor");
        Sensor.setEnabledSensors([]);
        Sensor.enableSensorEvents(null);
    }

    /*
     * callback for a location event
     * @param Position.Info positionInfo
     */
    function onPosition(positionInfo) {
        println("BergsteigenApp.onPosition");
        if (session == null) {
            if (views[currentViewNumber].GPSAccuracy < Position.QUALITY_USABLE && positionInfo.accuracy >= Position.QUALITY_USABLE) {
                Attention.backlight(true);
            }
            views[currentViewNumber].GPSAccuracy = positionInfo.accuracy;
            // the UI update is triggered by a timer
        } else {
            // location data is provided by Activity.Info, callback no longer needed
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, null);
        }
    }

    /*
     * callback for a sensor event (typically once per second)
     * @var Sensor.Info sensorInfo
     */
    function onSensor(sensorInfo) {
        //println("BergsteigenApp.onSensor");
        println("sensorInfo temperature: " + sensorInfo.temperature + " pressure: " + sensorInfo.pressure);
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo) {
            println("activityInfo meanSeaLevelPressure: " + activityInfo.meanSeaLevelPressure);
        }
        if (views != null && currentViewNumber != null
            && views[currentViewNumber] != null && views[currentViewNumber] has :compute
        ) {
            views[currentViewNumber].compute(activityInfo);
            // the UI update is triggered by a timer
        }
    }

    // start/stop activity recording session
    function startStopSession() {
        println("BergsteigenApp.startStopSession");
        if (session == null) {
            println("session is null");
            session = ActivityRecording.createSession({
                :name => WatchUi.loadResource(Rez.Strings.activityName),
                :sport => ActivityRecording.SPORT_MOUNTAINEERING  // SPORT_HIKING
            });
            session.start();
            vibrate();
            println("session created and started");
            // WatchUi.requestUpdate();
        } else if (session.isRecording() == false) {
            println("session status: is not recording");
            session.start();
            vibrate();
            println("session continued");
            // WatchUi.requestUpdate();
        } else if (session.isRecording()) {
            println("session status: is recording");
            session.stop();
            vibrate();
            println("session stopped");
            saveDiscardMenu();
        }
    }

    // save the ActivityRecording session
    function saveSession() {
        println("BergsteigenApp.saveSession");
        session.save();
        session = null;
        System.exit();
    }

    // discard the ActivityRecording session
    function discardSession() {
        println("BergsteigenApp.discardSession");
        session.discard();
        session = null;
        System.exit();
    }

    // show menu for saving or discarding the ActivityRecording session
    function saveDiscardMenu() {
        println("BergsteigenApp.saveDiscardMenu");
        /*
        var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.pause)});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.optionContinue), null, :resume, null));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.save), null, :save, null));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.discard), null, :discard, null));
        var delegate = new BergsteigenSaveMenuDelegate2();
        */
        var menu = new WatchUi.Menu();
        menu.setTitle(WatchUi.loadResource(Rez.Strings.pause));
        menu.addItem(WatchUi.loadResource(Rez.Strings.optionContinue), :resume);
        menu.addItem(WatchUi.loadResource(Rez.Strings.save), :save);
        menu.addItem(WatchUi.loadResource(Rez.Strings.discard), :discard);
        var delegate = new BergsteigenSaveMenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    // engage the vibration motor
    function vibrate() {
        println("BergsteigenApp.vibrate");
        if (Attention has :vibrate) {
            var vibeData = [new Attention.VibeProfile(50, 100)];
            Attention.vibrate(vibeData);
        }
    }

}
