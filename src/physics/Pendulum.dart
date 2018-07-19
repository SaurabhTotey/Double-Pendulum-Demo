import 'dart:math';
import 'Vector.dart';

/**
 * The class that represents a pendulum and its string in the simulation
 */
class Pendulum {

    //Where the string that the pendulum is on is fixed
    Vector startingLocation;
    //The length of the String in m
    double stringLength;
    //The mass of the pendulum in kg
    double mass;
    //The radius of the pendulum in m
    double radius;
    //The current location of the center of the pendulum
    Vector location;
    //The current velocity of the center of the pendulum
    Vector velocity = new Vector.empty();
    //The current acceleration of the center of the pendulum
    Vector acceleration = new Vector.empty();
    //The angle of the pendulum where 0 is downwards, and counterclockwise is positive
    double angle;
    //The change of the angle where 0 is downwards, and counterclockwise is positive
    double angularVelocity = 0.0;
    //The change of the change of the angle where 0 is downwards, and counterclockwise is positive
    double angularAcceleration = 0.0;

    /**
     * Creates a pendulum
     */
    Pendulum({
        this.startingLocation,
        this.stringLength = 5.0,
        this.mass = 1.5,
        this.radius = 0.5,
        this.location
    }) {
        //this.angle = atan2(location.x - startingLocation.x, location.y - startingLocation.y);
        this.angle = -atan2(startingLocation.x - location.x, startingLocation.y - location.y);
    }

}