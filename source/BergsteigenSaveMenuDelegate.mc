using Toybox.WatchUi;
using Toybox.Application;

/*
 * Input Delegate for a (simple) Menu
 */
class BergsteigenSaveMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        println("BergsteigenSaveMenuDelegate.onSelect " + item);
        if (item == :save) {
            println("BergsteigenSaveMenuDelegate.onSelect if save");
            Application.getApp().saveSession();
        } else if (item == :discard) {
            println("BergsteigenSaveMenuDelegate.onSelect if discard");
            Application.getApp().discardSession();
        } else if (item == :resume) {
            println("BergsteigenSaveMenuDelegate.onSelect if resume");
            Application.getApp().startStopSession();
        }
        println("BergsteigenSaveMenuDelegate1.onSelect end of function");
    }

}

/*
 * Input Delegate for an (advanced) Menu2
 */
class BergsteigenSaveMenuDelegate2 extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        println("BergsteigenSaveMenuDelegate.onSelect " + item.getId());
        if (item.getId() == :save) {
            println("BergsteigenSaveMenuDelegate.onSelect if save");
            Application.getApp().saveSession();
        } else if (item.getId() == :discard) {
            println("BergsteigenSaveMenuDelegate.onSelect if discard");
            Application.getApp().discardSession();
        } else if (item.getId() == :resume) {
            println("BergsteigenSaveMenuDelegate.onSelect if resume");
            Application.getApp().startStopSession();
        }
        println("BergsteigenSaveMenuDelegate.onSelect end of function");
    }

}
