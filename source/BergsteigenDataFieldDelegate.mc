using Toybox.WatchUi;
using Toybox.ActivityRecording;
using Toybox.Application;
using Toybox.System;

class BergsteigenDataFieldDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        println("BergsteigenDataFieldDelegate.onSelect");
        return BehaviorDelegate.onSelect();
    }

    function onKey(keyEvent) {
        println("BergsteigenDataFieldDelegate.onKey " + keyEvent.getKey());
        if (keyEvent.getKey() == KEY_ENTER) {
            Application.getApp().startStopSession();
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function onNextPage() {
        println("BergsteigenDataFieldDelegate.onNextPage");
        var nextView = Application.getApp().getNextView();
        if (nextView != null) {
            WatchUi.switchToView(nextView, self, WatchUi.SLIDE_UP);
        }
        return true;
    }

    function onPreviousPage() {
        println("BergsteigenDataFieldDelegate.onPreviousPage");
        var previousView = Application.getApp().getPreviousView();
        if (previousView != null) {
            WatchUi.switchToView(previousView, self, WatchUi.SLIDE_DOWN);
        }
        return true;
    }

    function onBack() {
        println("BergsteigenDataFieldDelegate.onBack");
        return BehaviorDelegate.onBack();
    }

    function onMenu() {
        println("BergsteigenDataFieldDelegate.onMenu");
        return BehaviorDelegate.onMenu();
    }

    function onNextMode() {
        println("BergsteigenDataFieldDelegate.onNextMode");
        return BehaviorDelegate.onNextMode();
    }

    function onPreviousMode() {
        println("BergsteigenDataFieldDelegate.onPreviousMode");
        return BehaviorDelegate.onPreviousMode();
    }

    function onTap(clickEvent) {
        println("BergsteigenDataFieldDelegate.onTap");
        return BehaviorDelegate.onTap();
    }

}
