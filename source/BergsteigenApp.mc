using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.System;
using Toybox.ActivityRecording;
using Toybox.Activity;

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
        return [views[0], new BergsteigenDataFieldDelegate()];
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
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, null); // method(:onPosition)
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

    // callback for a location event
    function onPosition(positionInfo) {
        println("BergsteigenApp.onPosition");
    }

    // callback for a sensor event (typically once per second)
    /* @var Sensor.Info sensorInfo */
    function onSensor(sensorInfo) {
        println("BergsteigenApp.onSensor");
        println("sensorInfo temperature: " + sensorInfo.temperature + " pressure: " + sensorInfo.pressure);
        var activityInfo = Activity.getActivityInfo();
        println("activityInfo ambientPressure: " + activityInfo.ambientPressure + " meanSeaLevelPressure: " + activityInfo.meanSeaLevelPressure + " rawAmbientPressure: " + activityInfo.rawAmbientPressure);
        if (activityInfo != null && views != null && currentViewNumber != null && views[currentViewNumber] != null && views[currentViewNumber] has :compute) {
            views[currentViewNumber].compute(activityInfo);
            WatchUi.requestUpdate();
        }
    }

    // start/stop activity recording session
    function startStopSession() {
        println("BergsteigenApp.startStopSession");
        if (session == null) {
            session = ActivityRecording.createSession({:name => WatchUi.loadResource(Rez.Strings.activityName), :sport => ActivityRecording.SPORT_MOUNTAINEERING}); // SPORT_HIKING
            session.start();
            println("session created and started");
        } else if (session.isRecording() == false) {
            session.start();
            println("session continued");
        } else if (session.isRecording()) {
            session.stop();
            saveDiscardMenu();
            println("session stopped");
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
        var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.pause)});
        var delegate;
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.save), null, "save", null));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.discard), null, "discard", null));
        delegate = new BergsteigenSaveMenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

}
