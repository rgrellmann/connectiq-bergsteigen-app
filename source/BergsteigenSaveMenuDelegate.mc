using Toybox.WatchUi;
using Toybox.Application;

/*
 * Input Delegate for a (simple) Menu
 */
class BergsteigenSaveMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

//    function onMenuItem(item) {
//        println("BergsteigenSaveMenuDelegate.onMenuItem " + item);
//        if (item == :save) {
//            println("BergsteigenSaveMenuDelegate.onMenuItem if save");
//            Application.getApp().saveSession();
//        } else if (item == :discard) {
//            println("BergsteigenSaveMenuDelegate.onMenuItem if discard");
//            // var dialog = new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.reallyDiscard));
//            // WatchUi.pushView(dialog, new DiscardConfirmationDelegate(), WatchUi.SLIDE_UP);
//            // println("BergsteigenSaveMenuDelegate.onMenuItem after pushView Confirmation");
//            Application.getApp().discardSession();
//        } else if (item == :resume) {
//            println("BergsteigenSaveMenuDelegate.onMenuItem if resume");
//            Application.getApp().startStopSession();
//        }
//        println("BergsteigenSaveMenuDelegate.onMenuItem end of function");
//    }

}

class DiscardConfirmationDelegate extends WatchUi.ConfirmationDelegate {

    function initialize() {
        ConfirmationDelegate.initialize();
    }

//    function onResponse(response) {
//        if (response == CONFIRM_NO) {
//            println("DiscardConfirmationDelegate.onResponse cancel discard");
//        } else {
//            println("DiscardConfirmationDelegate.onResponse confirm discard");
//            Application.getApp().discardSession();
//        }
//        println("DiscardConfirmationDelegate.onResponse end of function");
//    }
}

/*
 * Input Delegate for an (advanced) Menu2
 */
class BergsteigenSaveMenuDelegate2 extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }
//
//    function onSelect(item) {
//        println("BergsteigenSaveMenuDelegate.onSelect " + item.getId());
//        if (item.getId() == :save) {
//            println("BergsteigenSaveMenuDelegate.onSelect if save");
//            Application.getApp().saveSession();
//        } else if (item.getId() == :discard) {
//            println("BergsteigenSaveMenuDelegate.onSelect if discard");
//            var dialog = new WatchUi.Confirmation(Rez.Strings.reallyDiscard);
//            WatchUi.pushView(dialog, new DiscardConfirmationDelegate(), WatchUi.SLIDE_UP);
//        } else if (item.getId() == :resume) {
//            println("BergsteigenSaveMenuDelegate.onSelect if resume");
//            Application.getApp().startStopSession();
//        }
//        println("BergsteigenSaveMenuDelegate.onSelect end of function");
//    }

}
