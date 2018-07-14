import 'gui/Gui.dart';
import 'physics/Stage.dart';

/**
 * Entry point to the program
 */
void main() {
    final world = new Stage();
    final gui = new Gui(world);
}