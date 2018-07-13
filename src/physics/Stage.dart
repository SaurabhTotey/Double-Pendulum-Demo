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
     * All math used is stolen from https://myphysicslab.com/pendulum/double-pendulum-en.html
     */
    void step(double dt) {
        //Gets the pendulums as a list for making doing something to both pendulums easy
        List<Pendulum> pendulums = [this.initialPendulum, this.attachedPendulum];
        //Calculates the angular acceleration for both pendulums
        double combinedMass = this.initialPendulum.mass + this.attachedPendulum.mass;
        double angleDifference = this.initialPendulum.angle - this.attachedPendulum.angle;
        double denominatorFactor = combinedMass + this.initialPendulum.mass - this.attachedPendulum.mass * cos(2 * angleDifference);
        this.initialPendulum.angularAcceleration = (-this.gravity * (combinedMass + this.initialPendulum.mass) * sin(this.initialPendulum.angle) - this.attachedPendulum.mass * this.gravity * sin(angleDifference - this.attachedPendulum.angle) - 2 * sin(angleDifference) * this.attachedPendulum.mass * (pow(this.attachedPendulum.angularVelocity, 2) * this.attachedPendulum.stringLength + pow(this.initialPendulum.angularVelocity, 2) * this.initialPendulum.stringLength * cos(angleDifference))) / (this.initialPendulum.stringLength * denominatorFactor);
        this.attachedPendulum.angularAcceleration = 2 * sin(angleDifference) * (pow(this.initialPendulum.angularVelocity, 2) * this.initialPendulum.stringLength * combinedMass + this.gravity * combinedMass * cos(this.initialPendulum.angle) + pow(this.attachedPendulum.angularVelocity, 2) * this.attachedPendulum.stringLength * this.attachedPendulum.mass * cos(angleDifference)) / (this.attachedPendulum.stringLength * denominatorFactor);
        //Calculates the angles for both pendulums
        this.initialPendulum.angle = rungeKutta(0.0, this.initialPendulum.angle, dt, (timeStep) => rungeKutta(0.0, this.initialPendulum.angularVelocity, timeStep, (ignored) => this.initialPendulum.angularAcceleration));
        this.attachedPendulum.angle = rungeKutta(0.0, this.attachedPendulum.angle, dt, (timeStep) => rungeKutta(0.0, this.attachedPendulum.angularVelocity, timeStep, (ignored) => this.initialPendulum.angularAcceleration));
        //Calculates the angular velocity for both pendulums
        this.initialPendulum.angularVelocity = rungeKutta(0.0, this.initialPendulum.angularVelocity, dt, (timeStep) => this.initialPendulum.angularAcceleration);
        this.attachedPendulum.angularVelocity = rungeKutta(0.0, this.attachedPendulum.angularVelocity, dt, (timeStep) => this.initialPendulum.angularAcceleration);
        //TODO: above is probably incorrect to some degree
        //Updates the pendulums' positions using their angles
        pendulums.forEach( (pendulum) =>
            pendulum.location = pendulum.startingLocation + new Vector.isosceles(pendulum.stringLength) * new Vector(sin(pendulum.angle), -cos(pendulum.angle))
        );
        this.attachedPendulum.location += this.attachedPendulum.startingLocation - this.initialPendulum.location;
        this.attachedPendulum.startingLocation = this.initialPendulum.location;
        //Updates the pendulums' velocities using their angles and angular velocity
        pendulums.forEach( (pendulum) =>
            pendulum.velocity = new Vector.isosceles(pendulum.stringLength * pendulum.angularVelocity) * new Vector(cos(pendulum.angle), sin(pendulum.angle))
        );
        this.attachedPendulum.velocity += this.initialPendulum.velocity;
        //Updates the pendulum's accelerations
        pendulums.forEach( (pendulum) =>
            pendulum.acceleration = new Vector.isosceles(pendulum.stringLength) * new Vector(-pow(pendulum.angularVelocity, 2) * sin(pendulum.angle) + pendulum.angularAcceleration * cos(pendulum.angle), pow(pendulum.angularVelocity, 2) * cos(pendulum.angle) + pendulum.angularAcceleration * sin(pendulum.angle))
        );
        this.attachedPendulum.acceleration += this.initialPendulum.acceleration;
    }

}