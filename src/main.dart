import 'dart:async';
import 'gui/Gui.dart';
import 'physics/Stage.dart';

/**
 * Entry point to the program
 */
void main() {
    final world = new Stage();
    final gui = new Gui(world);
    int ms = 5;
    new Timer.periodic(new Duration(milliseconds: ms), (timer) {
        world.step(ms / 1000.0);
    });
    new Timer.periodic(new Duration(milliseconds: ms), (timer) {
        gui.screen.draw();
    });
}