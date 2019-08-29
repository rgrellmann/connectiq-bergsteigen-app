using Toybox.WatchUi;

class BergsteigenDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextMode() {
        WatchUi.pushView(new BergsteigenDataField2View(), self, WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousMode() {
        WatchUi.pushView(new BergsteigenDataField1View(), self, WatchUi.SLIDE_DOWN);
        return true;
    }

}