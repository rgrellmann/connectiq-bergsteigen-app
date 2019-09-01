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
class BergsteigenDataFieldAbstract extends WatchUi.DataField {

    protected var clockTime;
    protected var battery = 0;

    function initialize() {
        println("BergsteigenDataFieldAbstract.initialize");
        DataField.initialize();
        clockTime = System.getClockTime();
        battery = System.getSystemStats().battery;
    }

    /*
     * Draws a battery icon with a coloured level indicator
     * @param Number battery
     * @param Graphics.Dc dc
     * @param Number xStart
     * @param Number yStart
     * @param Number width
     * @param Number height
     */
    function drawBattery(battery, dc, xStart, yStart, width, height) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(xStart, yStart, width, height);
        if (battery < 10) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(xStart + 3 + width / 2, yStart + 6, Graphics.FONT_XTINY, format("$1$%", [battery.format("%d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else if (battery < 25) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(xStart + 1, yStart + 1, (width-2) * battery / 100, height - 2);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(xStart + width - 1, yStart + 3, 4, height - 6);
    }

}
