import 'dart:async';
import 'gui/Gui.dart';
import 'physics/Stage.dart';

/**
 * Entry point to the program
 */
void main() {
    final world = new Stage();
    final gui = new Gui(world);
    int step = 25;
    new Timer.periodic(new Duration(milliseconds: step), (timer) {
        world.step(step / 1000.0);
    });
    new Timer.periodic(new Duration(milliseconds: step), (timer) {
        gui.update();
    });
}