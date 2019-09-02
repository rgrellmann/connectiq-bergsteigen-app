using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background1 extends WatchUi.Drawable {

    /* @var Number */
    hidden var bgColor;

    function initialize() {
        var dictionary = {
            :identifier => "Background1"
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

        // horizontal line in the middle
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(10, 120, 230, 120);

        // fill top and bottom edge (always black)
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, 240, 30);
        dc.fillRectangle(0, 215, 240, 240);

        // draw arrows for ascent and descent
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        var xStart = 215; var yStart = 52;
        dc.drawLine(xStart, yStart, xStart - 5, yStart + 5);
        dc.drawLine(xStart, yStart, xStart,     yStart + 17);
        dc.drawLine(xStart, yStart, xStart + 5, yStart + 5);
        yStart = 98;
        dc.drawLine(xStart, yStart, xStart - 5, yStart - 5);
        dc.drawLine(xStart, yStart, xStart,     yStart - 17);
        dc.drawLine(xStart, yStart, xStart + 5, yStart - 5);
    }

}
