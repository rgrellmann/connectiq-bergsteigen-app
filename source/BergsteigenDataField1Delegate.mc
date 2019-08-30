using Toybox.WatchUi;
using Toybox.ActivityRecording;

class BergsteigenDataField1Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }


    function onSelect() {
        BergsteigenApp.startStopSession();
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() {
        WatchUi.switchToView(new BergsteigenDataField2View(), new BergsteigenDataField2Delegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() {
        WatchUi.switchToView(new BergsteigenDataField2View(), new BergsteigenDataField2Delegate(), WatchUi.SLIDE_DOWN);
        return true;
    }

}
