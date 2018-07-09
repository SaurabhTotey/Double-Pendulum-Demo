import 'dart:html';
import '../physics/Stage.dart';

/**
 * The class where everything gets rendered
 */
class Screen {

    //The HTML canvas element where everything gets rendered
    CanvasElement screen;
    //The utility object that can be used to actually draw on the screen
    CanvasRenderingContext2D renderer;
    //The stage that the screen will draw or represent
    Stage world;

    /**
     * Makes a screen and sets Screen attributes
     */
    Screen() {
        this.screen = document.getElementById('screen');
        this.renderer = this.screen.getContext('2d');
    }

}