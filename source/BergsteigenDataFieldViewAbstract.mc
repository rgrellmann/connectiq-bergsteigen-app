using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.System;
using Toybox.Lang;
using Toybox.UserProfile;
using Toybox.ActivityRecording;
using Toybox.Timer;

/*
 * Abstract class for the DataFields
 */
class BergsteigenDataFieldViewAbstract extends WatchUi.DataField {

    /* @var System.ClockTime clockTime */
    protected var clockTime;
    /* @var Float battery */
    protected var battery = 0.0;
    /* @var Timer.Timer timer */
    protected var timer;
    /* @var Number */
    public var GPSAccuracy = 0;

    public function initialize() {
        println("BergsteigenDataFieldViewAbstract.initialize");
        DataField.initialize();
        clockTime = System.getClockTime();
        battery = System.getSystemStats().battery;
        timer = new Timer.Timer();
    }

    // DataField background color
    public function getBackgroundColor() {
        var backgroundColor = Application.getApp().Properties.getValue("backgroundColor");
        println("BergsteigenDataFieldViewAbstract.getBackgroundColor " + backgroundColor);
        return backgroundColor;
    }

    // is called when this View is brought to the foreground
    public function onShow() {
        println("BergsteigenDataFieldViewAbstract.onShow");
        timer.start(method(:onTimer), 1000, true);
    }

    // is called before the View is removed from the foreground
    public function onHide() {
        println("BergsteigenDataFieldViewAbstract.onHide");
        timer.stop();
    }

    // timer callback
    public function onTimer() {
        //println("BergsteigenDataFieldViewAbstract.onTimer");
        WatchUi.requestUpdate();
    }

    /*
     * Draws a text how to start a session
     * @param Graphics.dc dc
     */
    protected function buttonHintOverlay(dc) {
        // println("BergsteigenDataFieldViewAbstract.buttonHintOverlay");
        var session = Application.getApp().session;
        var text = null;
        if (session == null) {
            if (GPSAccuracy < Position.QUALITY_USABLE) {
                text = WatchUi.loadResource(Rez.Strings.GPSwait);
            } else {
                text = WatchUi.loadResource(Rez.Strings.pressButton);
            }
        } else if (session.isRecording() == false) {
            text = WatchUi.loadResource(Rez.Strings.pause);
        }
        if (text) {
            var color = Graphics.COLOR_BLUE;
            var backgroundColor = Graphics.COLOR_BLACK;
            if (getBackgroundColor() == Graphics.COLOR_BLACK) {
                color = Graphics.COLOR_BLUE;
                backgroundColor = Graphics.COLOR_WHITE;
            }
            dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(0, dc.getHeight() / 2 - 13, dc.getWidth(), 30);
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() / 2, dc.getHeight() / 2 - 1, Graphics.FONT_SMALL,
                text,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
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
    protected function drawBattery(battery, dc, xStart, yStart, width, height) {
        // println("BergsteigenDataFieldViewAbstract.drawBattery");
        var color = Graphics.COLOR_WHITE;
        var green = Graphics.COLOR_GREEN;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            color = Graphics.COLOR_BLACK;
            green = Graphics.COLOR_DK_GREEN;
        }
        dc.setColor(color, Graphics.COLOR_WHITE);
        dc.fillRectangle(xStart, yStart, width, height);
        if (battery < 10) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(xStart + 3 + width / 2, yStart + 6, Graphics.FONT_XTINY, format("$1$%", [battery.format("%d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else if (battery < 20) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(green, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(xStart + 1, yStart + 1, (width-2) * battery / 100, height - 2);

        dc.setColor(color, Graphics.COLOR_WHITE);
        dc.fillRectangle(xStart + width - 1, yStart + 3, 4, height - 6);
    }

    /*
     * Draws bars indicating GPS accuracy
     * @param Number accuracy
     * @param Graphics.Dc dc
     * @param Number xStart
     * @param Number yStart
     * @param Number barWidth
     * @param Number height
     */
    protected function drawGPSIndicator(dc, xStart, yStart, barWidth, height) {
        var session = Application.getApp().session;
        if (session) {
            return;
        }
        println("BergsteigenDataFieldViewAbstract.drawGPSIndicator");
        var color1 = Graphics.COLOR_TRANSPARENT;
        var color2 = Graphics.COLOR_TRANSPARENT;
        var color3 = Graphics.COLOR_TRANSPARENT;
        var outlineColor = Graphics.COLOR_WHITE;
        var bgColor = Graphics.COLOR_BLACK;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            bgColor = Graphics.COLOR_WHITE;
            outlineColor = Graphics.COLOR_BLACK;
        }

        switch (GPSAccuracy) {
          case Position.QUALITY_NOT_AVAILABLE:
          case Position.QUALITY_LAST_KNOWN:
            outlineColor = Graphics.COLOR_RED;
            break;
          case Position.QUALITY_POOR:
            color1 = Graphics.COLOR_RED;
            break;
          case Position.QUALITY_USABLE:
            color1 = Graphics.COLOR_YELLOW;
            color2 = Graphics.COLOR_YELLOW;
            break;
          case Position.QUALITY_GOOD:
            color1 = Graphics.COLOR_GREEN;
            color2 = Graphics.COLOR_GREEN;
            color3 = Graphics.COLOR_GREEN;
            break;
        }

        dc.setColor(bgColor, bgColor);
        if (xStart < dc.getWidth() / 2) {
            dc.fillRectangle(0, yStart, xStart + barWidth * 3 + 25, height + 36);
        } else {
            dc.fillRectangle(xStart, yStart, dc.getWidth() / 2, height + 35);
        }

        dc.setColor(outlineColor, bgColor);
        dc.drawText(
            xStart + barWidth + 8, yStart, Graphics.FONT_SMALL, "GPS", Graphics.TEXT_JUSTIFY_CENTER
        );
        xStart = xStart + 15;
        yStart = yStart + 25;

        dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(xStart - 1, yStart + (height / 3) * 2 - 1, barWidth + 2, height / 3 + 2);
        dc.drawRectangle(xStart + barWidth, yStart + (height / 3) - 1, barWidth + 2, (height / 3) * 2 + 2);
        dc.drawRectangle(xStart + (barWidth * 2) + 1, yStart - 1, barWidth + 2, height + 2);

        dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(xStart, yStart + (height / 3) * 2, barWidth, height / 3);
        dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(xStart + barWidth + 1, yStart + height / 3, barWidth, (height / 3) * 2);
        dc.setColor(color3, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(xStart + barWidth * 2 + 2, yStart, barWidth, height);
    }

}
