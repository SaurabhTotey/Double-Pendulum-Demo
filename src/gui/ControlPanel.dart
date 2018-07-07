import 'dart:html';

/**
 * The class where the user can control physics settings
 */
class ControlPanel {

    //The HTML element where the control panel is housed
    DivElement controlPanel;

    /**
     * Constructor for a Control Panel that sets all of the ControlPanel attributes
     */
    ControlPanel() {
        this.controlPanel = document.getElementById('control-panel');
    }

}