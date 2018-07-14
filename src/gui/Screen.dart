import 'dart:html';
import 'dart:math';
import '../physics/Pendulum.dart';
import '../physics/Vector.dart';

/**
 * The class where everything gets rendered
 */
class Screen {

    //The HTML canvas element where everything gets rendered
    CanvasElement screen;
    //The utility object that can be used to actually draw on the screen
    CanvasRenderingContext2D renderer;
    //The pendulums to draw
    List<Pendulum> pendulums;
    //THe logical coordinates of the stage
    double logicalWidth;
    double logicalHeight;

    /**
     * Makes a screen and sets Screen attributes
     */
    Screen(Pendulum p1, Pendulum p2, this.logicalWidth, this.logicalHeight) {
        this.screen = document.getElementById('screen');
        this.renderer = this.screen.getContext('2d');
        this.pendulums = [p1, p2];
    }

    /**
     * The method that handles drawing the pendulums
     */
    draw() {
        this.renderer.clearRect(0, 0, this.screen.width, this.screen.height);
        double startX = 0.0;
        double startY = 0.0;
        double drawWidth = 0.0;
        double drawHeight = 0.0;
        if (this.screen.height / this.logicalHeight < this.screen.width / this.logicalWidth) {
            drawHeight = this.screen.height.toDouble();
            drawWidth = this.screen.height / this.logicalHeight * this.logicalWidth;
            startX = (this.screen.width - drawWidth) / 2;
        } else {
            drawWidth = this.screen.width.toDouble();
            drawHeight = this.screen.width / this.logicalWidth * this.logicalHeight;
            startY = (this.screen.height - drawHeight) / 2;
        }
        //Converts the given logical coordinates to view or screen coordinates
        Vector getViewCoordinates(Vector logicalCoordinates) {
            Vector viewCoords = logicalCoordinates * new Vector(drawWidth, drawHeight) / new Vector(this.logicalWidth, this.logicalHeight) + new Vector(startX, startY);
            viewCoords.y = this.screen.height - viewCoords.y;
            return viewCoords;
        }
        Vector p1 = getViewCoordinates(this.pendulums[0].startingLocation);
        Vector p2 = getViewCoordinates(this.pendulums[0].location);
        Vector p3 = getViewCoordinates(this.pendulums[1].location);
        this.renderer.beginPath();
        this.renderer.moveTo(p1.x.toInt(), p1.y.toInt());
        this.renderer.lineTo(p2.x.toInt(), p2.y.toInt());
        this.renderer.lineTo(p3.x.toInt(), p3.y.toInt());
        this.renderer.stroke();
        this.renderer.beginPath();
        this.renderer.arc(p2.x.toInt(), p2.y.toInt(), pendulums[0].radius * drawWidth / this.logicalWidth, 0.0, 2 * PI);
        this.renderer.arc(p3.x.toInt(), p3.y.toInt(), pendulums[1].radius * drawWidth / this.logicalWidth, 0.0, 2 * PI);
        this.renderer.fill();
    }

}