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

    /**
     * Creates a pendulum
     */
    Pendulum({
        this.startingLocation,
        this.stringLength = 5.0,
        this.mass = 1.5,
        this.radius = 0.5,
        this.location
    });

}