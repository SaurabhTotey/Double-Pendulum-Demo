import 'dart:html';
import 'dart:math';
import '../physics/Stage.dart';
import '../physics/Vector.dart';

/**
 * The class where everything gets rendered
 */
class Screen {

    //The HTML canvas element where everything gets rendered
    CanvasElement screen;
    //The utility object that can be used to actually draw on the screen
    CanvasRenderingContext2D renderer;
    //THe logical coordinates of the stage
    Stage world;
    //The bounding area for where the renderer should be drawing
    double startX = 0.0;
    double startY = 0.0;
    double drawWidth = 0.0;
    double drawHeight = 0.0;

    /**
     * Makes a screen and sets Screen attributes
     */
    Screen(this.world) {
        this.screen = document.getElementById('screen');
        this.renderer = this.screen.getContext('2d');
        resizeProc();
    }

    /**
     * The procedure for what happens on window resize
     */
    void resizeProc([Event ignored = null]) {
        if (this.screen.height / this.world.height < this.screen.width / this.world.width) {
            this.drawHeight = this.screen.height.toDouble();
            this.drawWidth = this.screen.height / this.world.height * this.world.width;
            this.startX = (this.screen.width - this.drawWidth) / 2;
        } else {
            this.drawWidth = this.screen.width.toDouble();
            this.drawHeight = this.screen.width / this.world.width * this.world.height;
            this.startY = (this.screen.height - this.drawHeight) / 2;
        }
    }

    /**
     * Converts the given logical coordinates to view or screen coordinates
     */
    Vector getViewCoordinates(Vector logicalCoordinates) {
        Vector viewCoords = logicalCoordinates * new Vector(this.drawWidth, this.drawHeight) / new Vector(this.world.width, this.world.height) + new Vector(this.startX, this.startY);
        viewCoords.y = this.screen.height - viewCoords.y;
        return viewCoords;
    }

    /**
     * Converts the given screen coordinates into logical or world coordinates
     */
    Vector getLogicalCoordinates(Vector viewCoordinates) {
        return new Vector.empty(); //TODO: make
    }

    /**
     * The method that handles drawing the pendulums
     */
    draw() {
        this.renderer.clearRect(0, 0, this.screen.width, this.screen.height);
        Vector p1 = getViewCoordinates(this.world.pendulums[0].startingLocation);
        Vector p2 = getViewCoordinates(this.world.pendulums[0].location);
        Vector p3 = getViewCoordinates(this.world.pendulums[1].location);
        this.renderer.beginPath();
        this.renderer.moveTo(p1.x.toInt(), p1.y.toInt());
        this.renderer.lineTo(p2.x.toInt(), p2.y.toInt());
        this.renderer.lineTo(p3.x.toInt(), p3.y.toInt());
        this.renderer.stroke();
        this.renderer.beginPath();
        this.renderer.arc(p2.x.toInt(), p2.y.toInt(), this.world.pendulums[0].radius * drawWidth / this.world.width, 0.0, 2 * PI);
        this.renderer.arc(p3.x.toInt(), p3.y.toInt(), this.world.pendulums[1].radius * drawWidth / this.world.width, 0.0, 2 * PI);
        this.renderer.fill();
    }

}