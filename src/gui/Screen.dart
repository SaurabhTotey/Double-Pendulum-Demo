import 'dart:html';

/**
 * The class where everything gets rendered
 */
class Screen {

    //The HTML canvas element where everything gets rendered
    CanvasElement screen;
    //The utility object that can be used to actually draw on the screen
    CanvasRenderingContext2D renderer;

    /**
     * Makes a screen and sets Screen attributes
     */
    Screen() {
        this.screen = document.getElementById('screen');
        this.renderer = this.screen.getContext('2d');
    }

}