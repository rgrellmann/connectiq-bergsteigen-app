using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background2 extends WatchUi.Drawable {

    hidden var bgColor;

    function initialize() {
        var dictionary = {
            :identifier => "Background2"
        };
        Drawable.initialize(dictionary);
    }

    /*
     * @param Number color Graphics.COLOR_* constant or 24-bit integer of the form 0xRRGGBB
     */
    function setColor(color) {
        bgColor = color;
    }

    /*
     * @param Graphics.Dc dc
     */
    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, bgColor);
        dc.clear();
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        // line below vertical center
        dc.drawLine(10, 132, 230, 132);
        // line in lower third
        dc.drawLine(30, 191, 210, 191);
        // upper and lower edges
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, 240, 30);
        dc.fillRectangle(0, 215, 240, 240);
        // arrows for sunrise and sunset
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        var xStart = 219; var yStart = 67;
        dc.drawLine(xStart, yStart, xStart - 5, yStart + 5);
        dc.drawLine(xStart, yStart, xStart,     yStart + 17);
        dc.drawLine(xStart, yStart, xStart + 5, yStart + 5);
        yStart = 109;
        dc.drawLine(xStart, yStart, xStart - 5, yStart - 5);
        dc.drawLine(xStart, yStart, xStart,     yStart - 17);
        dc.drawLine(xStart, yStart, xStart + 5, yStart - 5);
        // heading symbol
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
        var pts = [[41, 115], [37, 127], [41, 123], [45, 127], [41, 115]];
        dc.fillPolygon(pts);
    }

}
