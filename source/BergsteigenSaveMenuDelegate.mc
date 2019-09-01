using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

class BergsteigenSaveMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        println("BergsteigenSaveMenuDelegate.onSelect " + item.getId());
        if (item.getId() == "save") {
            Application.getApp().saveSession();
        } else if (item.getId() == "discard") {
            Application.getApp().discardSession();
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

}
