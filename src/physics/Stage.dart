import 'dart:math';
import 'Pendulum.dart';
import 'RungeKutta.dart';
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
    //The pendulums as a list for making doing something to both pendulums easy
    List<Pendulum> pendulums;
    //A multiplier on how fast time moves in this world
    double timeWarp = 1.0;
    //The gravity in the world in m/s/s
    double gravity;
    //The stage width in meters
    double width;
    //The stage height in meters
    double height;
    //Whether the stage should be running or not
    bool isPaused = false;
    //How long the world has existed
    double totalTime = 0.0;

    /**
     * Creating a stage initializes the pendulums to be at a stable rest position by default
     */
    Stage({
        this.gravity = 9.8,
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
                location: new Vector(initialPendulum.location.x + 5, initialPendulum.location.y)
            );
        }
        this.pendulums = [this.initialPendulum, this.attachedPendulum];
    }

    /**
     * Moves the world forward by the specified amount of time
     * All math used is stolen from https://myphysicslab.com/pendulum/double-pendulum-en.html
     */
    void step(double delta) {
        if (this.isPaused) {
            return;
        }
        double dt = delta * this.timeWarp;
        this.totalTime += dt;
        //Calculates the angular acceleration for both pendulums
        double combinedMass = this.initialPendulum.mass + this.attachedPendulum.mass;
        double initialPendulumAngle = this.initialPendulum.angle;
        double attachedPendulumAngle = this.attachedPendulum.angle;
        double initialPendulumAngularVelocity = this.initialPendulum.angularVelocity;
        double attachedPendulumAngularVelocity = this.attachedPendulum.angularVelocity;
        double initialPendulumAngularAccelerationFunction(PositionAndSpeed state) => (-this.gravity * (combinedMass + this.initialPendulum.mass) * sin(state.position) - this.attachedPendulum.mass * this.gravity * sin(state.position - 2 * attachedPendulumAngle) - 2 * sin(state.position - attachedPendulumAngle) * this.attachedPendulum.mass * (pow(attachedPendulumAngularVelocity, 2) * this.attachedPendulum.stringLength + pow(state.speed, 2) * this.initialPendulum.stringLength * cos(state.position - attachedPendulumAngle))) / (this.initialPendulum.stringLength * (combinedMass + this.initialPendulum.mass - this.attachedPendulum.mass * cos(2 * (state.position - attachedPendulumAngle))));
        double attachedPendulumAngularAccelerationFunction(PositionAndSpeed state) => 2 * sin(initialPendulumAngle - state.position) * (pow(initialPendulumAngularVelocity, 2) * this.initialPendulum.stringLength * combinedMass + this.gravity * combinedMass * cos(initialPendulumAngle) + pow(state.speed, 2) * this.attachedPendulum.stringLength * this.attachedPendulum.mass * cos(initialPendulumAngle - state.position)) / (this.attachedPendulum.stringLength * (combinedMass + this.initialPendulum.mass - this.attachedPendulum.mass * cos(2 * (initialPendulumAngle - state.position))));
        PositionAndSpeed initialPendulumState = new PositionAndSpeed(initialPendulumAngle, initialPendulumAngularVelocity);
        PositionAndSpeed attachedPendulumState = new PositionAndSpeed(attachedPendulumAngle, attachedPendulumAngularVelocity);
        PositionAndSpeed newInitialPendulumState = semiImplicitEuler(initialPendulumState, dt, initialPendulumAngularAccelerationFunction);
        PositionAndSpeed newAttachedPendulumState = semiImplicitEuler(attachedPendulumState, dt, attachedPendulumAngularAccelerationFunction);
        //Updates the pendulums' positions using their angles
        this.initialPendulum.angularAcceleration = initialPendulumAngularAccelerationFunction(initialPendulumState);
        this.attachedPendulum.angularAcceleration = attachedPendulumAngularAccelerationFunction(attachedPendulumState);
        this.initialPendulum.angularVelocity = newInitialPendulumState.speed;
        this.attachedPendulum.angularVelocity = newAttachedPendulumState.speed;
        this.initialPendulum.angle = newInitialPendulumState.position;
        this.attachedPendulum.angle = newAttachedPendulumState.position;
        this.updatePendulumPositions();
        //Updates the pendulums' velocities using their angles and angular velocity
        this.pendulums.forEach( (pendulum) =>
            pendulum.velocity = new Vector.isosceles(pendulum.stringLength * pendulum.angularVelocity) * new Vector(cos(pendulum.angle), sin(pendulum.angle))
        );
        this.attachedPendulum.velocity += this.initialPendulum.velocity;
        //Updates the pendulum's accelerations
        this.pendulums.forEach( (pendulum) =>
            pendulum.acceleration = new Vector.isosceles(pendulum.stringLength) * new Vector(-pow(pendulum.angularVelocity, 2) * sin(pendulum.angle) + pendulum.angularAcceleration * cos(pendulum.angle), pow(pendulum.angularVelocity, 2) * cos(pendulum.angle) + pendulum.angularAcceleration * sin(pendulum.angle))
        );
        this.attachedPendulum.acceleration += this.initialPendulum.acceleration;
    }

    /**
     * A function that sets the positions of each pendulum using its angle
     * Is separated out into a function because it is called outside of stage when the angle of the pendulums are changed by outside factors (eg. Screen)
     */
    void updatePendulumPositions() {
        this.pendulums.forEach( (pendulum) =>
            pendulum.location = pendulum.startingLocation + new Vector.isosceles(pendulum.stringLength) * new Vector(sin(pendulum.angle), -cos(pendulum.angle))
        );
        this.attachedPendulum.location += this.attachedPendulum.startingLocation - this.initialPendulum.location;
        this.attachedPendulum.startingLocation = this.initialPendulum.location;
    }

}
