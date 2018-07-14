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
        this.renderer.strokeStyle = 'blue';
        this.renderer.lineWidth = 3;
        this.renderer.fillStyle = 'green';
    }

    /**
     * The method that handles drawing the pendulums
     */
    draw() {
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
            drawHeight - this.screen.width / this.logicalWidth * this.logicalHeight;
            startY = (this.screen.height - drawHeight) / 2;
        }
    }

}