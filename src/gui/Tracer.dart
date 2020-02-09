import '../physics/Vector.dart';

/**
 * A class that handles drawing a tracing line for a function that generates points
 */
class Tracer {

    //All the points that the tracer has caught
    List<Vector> points = [];
    //The color that the tracer will use
    String color = "rgba(255,0,0,150)";
    //How the tracer generates points
    Vector Function() pointGenerator;

    /**
     * Makes a tracer given a function that gets the point
     */
    Tracer(this.pointGenerator);

    /**
     * Adds a point to the tracer using the pointGenerator
     */
    void update() {
        this.points.add(pointGenerator());
    }

}
