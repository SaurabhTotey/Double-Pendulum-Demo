import 'dart:html' hide Screen;
import 'ControlPanel.dart';
import 'Screen.dart';

/**
 * The class that handles aligning all GUI elements
 */
class Gui {

    Screen screen = new Screen();
    ControlPanel controlPanel = new ControlPanel();

    /**
     * Constructs the Gui to make the components auto resize when the window resizes
     */
    Gui() {
        void resizeProc([Event ignored = null]) {
            this.screen.screen.width = (window.innerWidth * 0.75).toInt();
            this.screen.screen.height = window.innerHeight;
            this.controlPanel.controlPanel.style.width = '${window.innerWidth - this.screen.screen.width}px';
            this.controlPanel.controlPanel.style.height = '${window.innerHeight}px';
        }
        resizeProc();
        window.onResize.listen(resizeProc);
    }

}