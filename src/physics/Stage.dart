import 'Pendulum.dart';
import 'Vector.dart';

/**
 * The class that is essentially the 'world' for the simulation
 * Handles all of the main logic and houses all of the simulation objects
 */
class Stage {

    //The first pendulum that doesn't have any really interesting behaviour
    Pendulum initialPendulum;
    //The attached pendulum that is what gets traced on the screen
    Pendulum attachedPendulum;
    //The gravity in the world in m/s/s
    double gravity;
    //The dampening effect on the pendulum swinging; works multiplicatively
    double dampenFactor;
    //The stage width in meters
    double width;
    //The stage height in meters
    double height;

    /**
     * Creating a stage initializes the pendulums to be at a stable rest position by default
     */
    Stage({
        this.gravity = 9.8,
        this.dampenFactor = 1.0,
        this.width = 20.0,
        this.height = 15.0,
        this.initialPendulum = null,
        this.attachedPendulum = null
    }) {
        if (initialPendulum == null) {
            initialPendulum = new Pendulum(
                startingLocation: new Vector(this.width / 2, this.height * 0.9),
                location: new Vector(this.width / 2, this.height * 0.9 - 5.0)
            );
        }
        if (attachedPendulum == null) {
            attachedPendulum = new Pendulum(
                startingLocation: initialPendulum.location,
                location: new Vector(initialPendulum.location.x, initialPendulum.location.y - 5.0)
            );
        }
    }

    /**
     * Moves the world forward by the specified amount of time
     */
    void step(double delta) {
        //TODO: make
    }

}