using Toybox.WatchUi;

class BergsteigenDataField2Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        BergsteigenApp.startStopSession();
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() {
        WatchUi.switchToView(new BergsteigenDataField1View(), new BergsteigenDataField1Delegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() {
        WatchUi.switchToView(new BergsteigenDataField1View(), new BergsteigenDataField1Delegate(), WatchUi.SLIDE_DOWN);
        return true;
    }

}