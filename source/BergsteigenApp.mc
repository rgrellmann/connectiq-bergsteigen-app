using Toybox.Application;
using Toybox.WatchUi;

/* @var ActivityRecording.Session session */
var session = null;

class BergsteigenApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new BergsteigenDataField1View(), new BergsteigenDataField1Delegate() ];
    }

    // start/stop activity recording session
    function startStopSession() {
        if (Toybox has :ActivityRecording) {
            if ((session == null) || (session.isRecording() == false)) {
                session = ActivityRecording.createSession({:name => "Bergsteigen", :sport => ActivityRecording.SPORT_MOUNTAINEERING}); // SPORT_HIKING
                session.start();
            } else if ((session != null) && session.isRecording()) {
                session.stop();
                session.save();
                session = null;
            }
        }
    }

}
