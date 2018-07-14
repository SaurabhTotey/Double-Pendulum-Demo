import 'dart:html' hide Screen;
import 'ControlPanel.dart';
import 'Screen.dart';
import '../physics/Stage.dart';

/**
 * The class that handles aligning all GUI elements
 */
class Gui {

    //The screen where everything gets drawn to
    Screen screen;
    //The control panel where the user can change physics options or settings
    ControlPanel controlPanel;
    //The stage that the screen will draw or represent
    Stage world;

    /**
     * Constructs the Gui to make the components auto resize when the window resizes
     */
    Gui(this.world) {
        this.screen = new Screen(this.world.initialPendulum, this.world.attachedPendulum, this.world.width, this.world.height);
        this.controlPanel = new ControlPanel();
        void resizeProc([Event ignored = null]) {
            this.screen.screen.width = (window.innerWidth * 0.75).toInt();
            this.screen.screen.height = window.innerHeight;
            this.controlPanel.controlPanel.style.width = '${window.innerWidth - this.screen.screen.width}px';
            this.controlPanel.controlPanel.style.height = '${window.innerHeight}px';
        }
        resizeProc();
        window.onResize.listen(resizeProc);
        this.screen.draw();
    }

}