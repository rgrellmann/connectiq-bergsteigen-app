using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.System;
using Toybox.Lang;
using Toybox.UserProfile;
using Toybox.ActivityRecording;

/*
 * A DataField which displays values of interest during a mountain tour
 * It is designed to be easily readable when having a quick look at the watch
 * while walking or climbing.
 * Have a look at BergsteigenDataField2 for additional values.
 */
class BergsteigenDataField1View extends BergsteigenDataFieldViewAbstract {

    protected var altitude = 0;
    protected var elapsedTime = 0;
    protected var timerTime = 0;
    protected var currentHeartRate = 0;
    protected var currentHeartRateZone = 0;
    protected var totalAscent = 0;
    protected var totalDescent = 0;
    protected var hrZoneInfo = [];

    function initialize() {
        println("BergsteigenDataField1View.initialize");
        BergsteigenDataFieldViewAbstract.initialize();
        hrZoneInfo = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
    }

    /*
     * Set the layout. Anytime the size of obscurity of
     * the draw context is changed this will be called.
     * @param Graphics.DC dc
     */
    function onLayout(dc) {
        println("BergsteigenDataField1View.onLayout");
        DataField.onLayout(dc);
        View.setLayout(Rez.Layouts.MainLayout1(dc));
        View.findDrawableById("unitAltitude").setText("m");
        View.findDrawableById("labelAltitude").setText(Rez.Strings.labelAltitude);
        View.findDrawableById("labelCurrentHeartRate").setText(Rez.Strings.labelHeartRate);
        View.findDrawableById("labelElapsedTime").setText(Rez.Strings.labelElapsedTime);
        return true;
    }

    /*
     * The given info object contains all the current workout information.
     * Calculate a value and save it locally in this method.
     * Note that compute() and onUpdate() are asynchronous, and there is no
     * guarantee that compute() will be called before onUpdate().
     * @param Activity.Info info
     */
    function compute(info) {
        //println("BergsteigenDataField1View.compute");
        clockTime = System.getClockTime();
        battery = System.getSystemStats().battery;
        // initialize all numeric properties which should be part of info
        var numberProperties = [:altitude, :currentHeartRate, :totalAscent, :totalDescent, :elapsedTime, :timerTime];
        for (var i = 0; i < numberProperties.size(); i++) {
            if (info has numberProperties[i]) {
                if (info[numberProperties[i]] != null) {
                    self[numberProperties[i]] = info[numberProperties[i]];
                } else {
                    self[numberProperties[i]] = 0;
                }
            }
        }
        // check if the heart rate should be highlighted
        // (in or above zone 5)
        if (currentHeartRate > hrZoneInfo[5]) {
            currentHeartRateZone = 6;
        } else if (currentHeartRate > hrZoneInfo[4]) {
            currentHeartRateZone = 5;
        } else {
            currentHeartRateZone = 0;
        }
    }

    /*
     * Display the computed values.
     * Called once a second when the data field is visible.
     * @param Graphics.Dc dc
     */
    function onUpdate(dc) {
        //println("BergsteigenDataField1View.onUpdate");
        // Set the background color
        View.findDrawableById("Background1").setColor(getBackgroundColor());

        // clock time (opposite color)
        var drawable = View.findDrawableById("clockTime");
        drawable.setColor(getBackgroundColor());
        drawable.setText(Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]));

        // Set the foreground color and value
        var foregroundColor = Graphics.COLOR_BLACK;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            foregroundColor = Graphics.COLOR_WHITE;
        }
        var drawables = ["altitude", "currentHeartRate", "totalDescent", "totalAscent", "elapsedTime"];
        for (var i = 0; i < drawables.size(); i++) {
            drawable = View.findDrawableById(drawables[i]);
            drawable.setColor(foregroundColor);
        }

        // altitude
        drawable = View.findDrawableById("altitude");
        drawable.setText(altitude.format("%d"));

        // elapsed time
        drawable = View.findDrawableById("elapsedTime");
        var elapsedSeconds = timerTime / 1000;
        var hours = elapsedSeconds / 3600;
        var minutes = (elapsedSeconds) / 60 % 60;
        var seconds = elapsedSeconds % 60;
        if (hours > 0) {
            drawable.setText(Lang.format("$1$:$2$", [hours, minutes.format("%02d")]));
        } else {
            drawable.setText(Lang.format("$1$:$2$", [minutes, seconds.format("%02d")]));
        }

        // current heart rate
        drawable = View.findDrawableById("currentHeartRate");
        if (currentHeartRateZone == 6) {
            drawable.setColor(Graphics.COLOR_RED);
        } else if (currentHeartRateZone == 5) {
            drawable.setColor(Graphics.COLOR_YELLOW);
        } else {
            drawable.setColor(foregroundColor);
        }
        drawable.setText(currentHeartRate.format("%d"));

        // total ascent and descent
        drawable = View.findDrawableById("totalAscent");
        drawable.setText(totalAscent.format("%d") + 'm');
        drawable = View.findDrawableById("totalDescent");
        drawable.setText(totalDescent.format("%d") + 'm');

        // Call parent's onUpdate(dc) to redraw the layout
        DataField.onUpdate(dc);

        // all direct draw operations must be performed after View.onUpdate()

        // battery symbol at the lower edge of the screen
        drawBattery(battery, dc, 100, 220, 40, 15);

        // hint to press button
        buttonHintOverlay(dc);
        // GPS indicator, when session was not started yet
        drawGPSIndicator(dc, 125, 30, 21, 42);
    }

}
