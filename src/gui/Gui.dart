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
        this.screen = new Screen(this.world);
        this.controlPanel = new ControlPanel();
        void resizeProc([Event ignored = null]) {
            this.screen.screen.width = (window.innerWidth * 0.7).toInt();
            this.screen.screen.height = window.innerHeight;
            this.controlPanel.controlPanel.style.width = '${window.innerWidth - this.screen.screen.width}px';
            this.controlPanel.controlPanel.style.height = '${window.innerHeight}px';
            this.screen.resizeProc();
        }
        resizeProc();
        window.onResize.listen(resizeProc);
        this.screen.draw();
        this.controlPanel.addNumericInput(
            "World",
            "Gravity",
            this.world.gravity,
            "m/s/s",
            0.0,
            100.0,
            0.1,
            (newGravity) => this.world.gravity = newGravity
        );
        this.controlPanel.addNumericInput(
            "World",
            "Time Warp",
            this.world.timeWarp,
            "",
            0.0,
            10.0,
            0.01,
            (newTimeWarp) => this.world.timeWarp = newTimeWarp
        );
        this.controlPanel.addNumericInput(
            "Pendulum 1",
            "Rod Length",
            this.world.initialPendulum.stringLength,
            "m",
            0.1,
            20.0,
            0.1,
            (newRodLength) => this.world.initialPendulum.stringLength = newRodLength
        );
        this.controlPanel.addNumericInput(
            "Pendulum 2",
            "Rod Length",
            this.world.attachedPendulum.stringLength,
            "m",
            0.1,
            20.0,
            0.1,
            (newRodLength) => this.world.attachedPendulum.stringLength = newRodLength
        );
        this.controlPanel.addNumericInput(
            "Pendulum 1",
            "Mass",
            this.world.initialPendulum.mass,
            "kg",
            0.1,
            100.0,
            0.1,
            (newMass) => this.world.initialPendulum.mass = newMass
        );
        this.controlPanel.addNumericInput(
            "Pendulum 2",
            "Mass",
            this.world.attachedPendulum.mass,
            "kg",
            0.1,
            100.0,
            0.1,
            (newMass) => this.world.attachedPendulum.mass = newMass
        );
        this.controlPanel.addBreak();
        this.controlPanel.addOutputField(
            "Pendulum 1",
            "Angle",
            this.world.initialPendulum.angle.toStringAsFixed(2),
            "rad",
            () => this.world.initialPendulum.angle.toStringAsFixed(2)
        );
        this.controlPanel.addOutputField(
            "Pendulum 1",
            "Angular Velocity",
            this.world.initialPendulum.angularVelocity.toStringAsFixed(2),
            "rad/s",
            () => this.world.initialPendulum.angularVelocity.toStringAsFixed(2)
        );
        this.controlPanel.addOutputField(
            "Pendulum 1",
            "Angular Acceleration",
            this.world.initialPendulum.angularAcceleration.toStringAsFixed(2),
            "rad/s/s",
            () => this.world.initialPendulum.angularAcceleration.toStringAsFixed(2)
        );
        this.controlPanel.addOutputField(
            "Pendulum 2",
            "Angle",
            this.world.attachedPendulum.angle.toStringAsFixed(2),
            "rad",
            () => this.world.attachedPendulum.angle.toStringAsFixed(2)
        );
        this.controlPanel.addOutputField(
            "Pendulum 2",
            "Angular Velocity",
            this.world.attachedPendulum.angularVelocity.toStringAsFixed(2),
            "rad/s",
            () => this.world.attachedPendulum.angularVelocity.toStringAsFixed(2)
        );
        this.controlPanel.addOutputField(
            "Pendulum 2",
            "Angular Acceleration",
            this.world.attachedPendulum.angularAcceleration.toStringAsFixed(2),
            "rad/s/s",
            () => this.world.attachedPendulum.angularAcceleration.toStringAsFixed(2)
        );
        this.controlPanel.addBreak();
        this.controlPanel.addOutputField(
            "Pendulum 1",
            "Location",
            "${this.world.initialPendulum.location}",
            "m",
            () => "${this.world.initialPendulum.location}"    
        );
        this.controlPanel.addOutputField(
            "Pendulum 1",
            "Velocity",
            "${this.world.initialPendulum.velocity}",
            "m/s",
            () => "${this.world.initialPendulum.velocity}"    
        );
        this.controlPanel.addOutputField(
            "Pendulum 1",
            "Acceleration",
            "${this.world.initialPendulum.acceleration}",
            "m/s/s",
            () => "${this.world.initialPendulum.acceleration}"    
        );
        this.controlPanel.addOutputField(
            "Pendulum 2",
            "Location",
            "${this.world.attachedPendulum.location}",
            "m",
            () => "${this.world.attachedPendulum.location}"    
        );
        this.controlPanel.addOutputField(
            "Pendulum 2",
            "Velocity",
            "${this.world.attachedPendulum.velocity}",
            "m/s",
            () => "${this.world.attachedPendulum.velocity}"    
        );
        this.controlPanel.addOutputField(
            "Pendulum 2",
            "Acceleration",
            "${this.world.attachedPendulum.acceleration}",
            "m/s/s",
            () => "${this.world.attachedPendulum.acceleration}"    
        );
    }

    /**
     * Updates the gui by updating the screen and control panel
     */
    void update() {
        this.screen.draw();
        this.controlPanel.update();
    }

}