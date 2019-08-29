using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.System;
using Toybox.Lang;
using Toybox.Position;
using Toybox.SensorHistory;
using Toybox.Math;

/*
 * A DataField which displays less frequently used values during a mountain tour
 * It is designed to be looked at while standing, so the fonts are smaller
 * and more information is packed on one page compared to BergsteigenDataField1.
 */

class BergsteigenDataField2View extends WatchUi.DataField {

    hidden var calories = 0;
    hidden var clockTime;
    hidden var elapsedDistance = 0;
    hidden var battery = 0;
    hidden var currentLocation;
    hidden var sunrise;
    hidden var sunset;
    hidden var currentHeading = 0;
    hidden var meanSeaLevelPressure = 0.0;
    hidden var ambientPressure = 0.0;
    hidden var temperature = 0.0;

    function initialize() {
        DataField.initialize();
        clockTime = System.getClockTime();
    }

    /*
     * Set the layout. Anytime the size of obscurity of
     * the draw context is changed this will be called.
     * @param Graphics.DC dc
     */
    function onLayout(dc) {
        View.setLayout(Rez.Layouts.MainLayout2(dc));
        View.findDrawableById("unitElapsedDistance").setText("km");
        View.findDrawableById("labelCalories").setText("kcal");
        View.findDrawableById("labelLocation").setText("Position");
        View.findDrawableById("labelSun").setText(Rez.Strings.labelSun);
        View.findDrawableById("labelElapsedDistance").setText(Rez.Strings.labelDistance);
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
        clockTime = System.getClockTime();
        battery = System.getSystemStats().battery;
        // initialize all numeric properties which should be part of info
        var numberProperties = [:calories, :elapsedDistance, :ambientPressure, :meanSeaLevelPressure, :currentHeading];
        for (var i = 0; i < numberProperties.size(); i++) {
            if (info has numberProperties[i]) {
                if (info[numberProperties[i]] != null) {
                    self[numberProperties[i]] = info[numberProperties[i]];
                } else {
                    self[numberProperties[i]] = 0;
                }
            }
        }
        if (info has :currentLocation) {
            if (info.currentLocation != null) {
                currentLocation = info.currentLocation;
                var sc = new SunCalc();
                var now = Time.now();
                var loc = currentLocation.toRadians();
                sunrise = sc.calculate(now, loc[0], loc[1], SUNRISE);
                sunset = sc.calculate(now, loc[0], loc[1], SUNSET);
            } else {
                currentLocation = null;
                sunrise = null;
                sunset = null;
            }
        }
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
            var temperatureHistory = Toybox.SensorHistory.getTemperatureHistory({:period => 1});
            var lastTemperature = temperatureHistory.next().data;
            if (lastTemperature != null) {
                temperature = lastTemperature;
            }
        }
    }

    /*
     * Display the computed values.
     * Called once a second when the data field is visible.
     * @param Graphics.Dc dc
     */
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());
        // Set the foreground color and value
        var foregroundColor = Graphics.COLOR_BLACK;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            foregroundColor = Graphics.COLOR_WHITE;
        }
        var drawables = ["calories", "elapsedDistance", "sunrise", "sunset", "currentLat", "currentLon", "temperature", "currentHeading", "currentHeadingDeg"];
        for (var i = 0; i < drawables.size(); i++) {
            var drawable = View.findDrawableById(drawables[i]);
            drawable.setColor(foregroundColor);
        }

        var value;
        // clock time
        value = View.findDrawableById("clockTime");
        value.setText(Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]));

        // position (lat/lon)
        if (currentLocation instanceof Toybox.Position.Location) {
            var locationDecimal = currentLocation.toDegrees();
            value = View.findDrawableById("currentLat");
            value.setText(locationDecimal[0].format("%.5f"));
            value = View.findDrawableById("currentLon");
            value.setText(locationDecimal[1].format("%.5f"));
        } else {
            value = View.findDrawableById("currentLat");
            value.setText("N/A");
            value = View.findDrawableById("currentLon");
            value.setText("N/A");
        }

        // heading
        value = View.findDrawableById("currentHeading");
        value.setText(getHeadingLetter(currentHeading));
        value = View.findDrawableById("currentHeadingDeg");
        var currentHeadingDeg = Math.toDegrees(currentHeading);
        if (currentHeadingDeg < 0) {
            currentHeadingDeg = 360 + currentHeadingDeg;
        }
        value.setText(currentHeadingDeg.format("%d") + "°");

        // sunrise/sunset
        value = View.findDrawableById("sunrise");
        if (sunrise instanceof Time.Gregorian.Info) {
            value.setText(Lang.format("$1$:$2$", [sunrise.hour, sunrise.min.format("%02d")]));
        } else {
            value.setText("N/A");
        }
        value = View.findDrawableById("sunset");
        if (sunset instanceof Time.Gregorian.Info) {
            value.setText(Lang.format("$1$:$2$", [sunset.hour, sunset.min.format("%02d")]));
        } else {
            value.setText("N/A");
        }

        // calories
        value = View.findDrawableById("calories");
        value.setText(calories.format("%d"));

        // elapsed distance
        value = View.findDrawableById("elapsedDistance");
        value.setText((elapsedDistance / 1000).format("%.2f"));

        // temperature
        value = View.findDrawableById("temperature");
        value.setText(temperature.format("%d") + "°C");

        // barometric pressure
        value = View.findDrawableById("meanSeaLevelPressure");
        value.setText((ambientPressure / 100).format("%d") + "/" + (meanSeaLevelPressure / 100).format("%d") + "hPa");

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

        // all direct draw operations must be performed after View.onUpdate()

        drawBattery(battery, dc, 100, 220, 40, 15);
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
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(xStart, yStart, width, height);
        if (battery < 10) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(xStart + 3 + width / 2, yStart + 6, Graphics.FONT_XTINY, format("$1$%", [battery.format("%d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else if (battery < 20) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(xStart + 1, yStart + 1, (width-2) * battery / 100, height - 2);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(xStart + width - 1, yStart + 3, 4, height - 6);
    }

    /*
     * @param Number heading heading in radians
     */
    protected function getHeadingLetter(heading) {
        // shift by 11.75 degrees to simplify the if statements
        var headingDegrees = Math.toDegrees(heading) + 11.75;
        var letter = "-";
        if (headingDegrees < -157.5) {
            letter = "S";
        } else if (headingDegrees < -135) {
            letter = "SSW";
        } else if (headingDegrees < -112.5) {
            letter = "SW";
        } else if (headingDegrees < -90) {
            letter = "WSW";
        } else if (headingDegrees < -67.5) {
            letter = "W";
        } else if (headingDegrees < -45) {
            letter = "WNW";
        } else if (headingDegrees < -22.5) {
            letter = "NW";
        } else if (headingDegrees < 0) {
            letter = "NNW";
        } else if (headingDegrees < 22.5) {
            letter = "N";
        } else if (headingDegrees < 45) {
            letter = "NNO";
        } else if (headingDegrees < 67.5) {
            letter = "NO";
        } else if (headingDegrees < 90) {
            letter = "ONO";
        } else if (headingDegrees < 112.5) {
            letter = "O";
        } else if (headingDegrees < 135) {
            letter = "OSO";
        } else if (headingDegrees < 157.5) {
            letter = "SO";
        } else if (headingDegrees < 180) {
            letter = "SSO";
        } else if (headingDegrees < 202.5) {
            letter = "S";
        }
        return letter;
    }

}
