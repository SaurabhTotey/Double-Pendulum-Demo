import 'Vector.dart';

/**
 * The class that represents a pendulum and its string in the simulation
 */
class Pendulum {

    //Where the string that the pendulum is on is fixed
    Vector startingLocation;
    //The length of the String
    double stringLength;
    //The mass of the pendulum
    double mass;
    //The radius of the Pendulum
    double radius;
    //The current location of the center of the pendulum
    Vector location;

    /**
     * Creates a pendulum
     */
    Pendulum({this.startingLocation, this.stringLength, this.mass, this.radius, this.location});

}