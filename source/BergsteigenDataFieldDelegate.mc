using Toybox.WatchUi;
using Toybox.ActivityRecording;
using Toybox.Application;
using Toybox.System;

class BergsteigenDataFieldDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

//    // Input events
//
//    /*
//     * @param WatchUi::KeyEvent keyEvent
//     */
//    function onKey(keyEvent) {
//        // KEY_ENTER = 4, KEY_ESC = 5
//        println("BergsteigenDataFieldDelegate.onKey " + keyEvent.getKey());
//        if (keyEvent.getKey() == KEY_ENTER) { // 4
//            Application.getApp().startStopSession();
//            return true;
//        }
//        return false;
//    }
//
//    /*
//     * @param WatchUi::ClickEvent clickEvent
//     */
//    function onTap(clickEvent) {
//        println("BergsteigenDataFieldDelegate.onTap");
//        return BehaviorDelegate.onTap(clickEvent);
//    }
//
//    // Beahavior events
//
//    function onSelect() {
//        println("BergsteigenDataFieldDelegate.onSelect");
//        return BehaviorDelegate.onSelect();
//    }
//
//    function onNextPage() {
//        println("BergsteigenDataFieldDelegate.onNextPage");
//        var nextView = Application.getApp().getNextView();
//        if (nextView != null) {
//            WatchUi.switchToView(nextView, self, WatchUi.SLIDE_UP);
//        }
//        return true;
//    }
//
//    function onPreviousPage() {
//        println("BergsteigenDataFieldDelegate.onPreviousPage");
//        var previousView = Application.getApp().getPreviousView();
//        if (previousView != null) {
//            WatchUi.switchToView(previousView, self, WatchUi.SLIDE_DOWN);
//        }
//        return true;
//    }
//
//    function onBack() {
//        println("BergsteigenDataFieldDelegate.onBack");
//        return BehaviorDelegate.onBack();
//    }
//
//    function onMenu() {
//        println("BergsteigenDataFieldDelegate.onMenu");
//        return BehaviorDelegate.onMenu();
//    }
//
//    function onNextMode() {
//        println("BergsteigenDataFieldDelegate.onNextMode");
//        return BehaviorDelegate.onNextMode();
//    }
//
//    function onPreviousMode() {
//        println("BergsteigenDataFieldDelegate.onPreviousMode");
//        return BehaviorDelegate.onPreviousMode();
//    }
//
}
