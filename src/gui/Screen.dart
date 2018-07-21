import 'dart:html';
import 'dart:math';
import 'Tracer.dart';
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
    //The stage that the screen is representing or drawing
    Stage world;
    //The bounding area for where the renderer should be drawing
    double startX = 0.0;
    double startY = 0.0;
    double drawWidth = 0.0;
    double drawHeight = 0.0;
    //The tracers that trace the pendulums
    Tracer initialPendulumTracer;
    Tracer attachedPendulumTracer;

    /**
     * Makes a screen and sets Screen attributes such as the drag procedures
     */
    Screen(this.world) {
        this.screen = document.getElementById('screen');
        this.renderer = this.screen.getContext('2d');
        resizeProc();
        bool isDragging = false;
        //Drag procedures
        Function(Vector) handleDrag;
        this.screen.onMouseDown.listen((MouseEvent event) {
            Vector clickLocation = new Vector(event.client.x, event.client.y);
            Vector logicalMouseLocation = this.getLogicalCoordinates(clickLocation);
            if (pow(logicalMouseLocation.x - this.world.attachedPendulum.location.x, 2) + pow(logicalMouseLocation.y - this.world.attachedPendulum.location.y, 2) <= pow(this.world.attachedPendulum.radius, 2)) {
                isDragging = true;
                handleDrag = (Vector v) {
                    Vector sl = this.world.attachedPendulum.startingLocation;
                    this.world.attachedPendulum.angle = -atan2(sl.x - v.x, sl.y - v.y);
                    this.world.updatePendulumPositions();
                };
            } else if (pow(logicalMouseLocation.x - this.world.initialPendulum.location.x, 2) + pow(logicalMouseLocation.y - this.world.initialPendulum.location.y, 2) <= pow(this.world.initialPendulum.radius, 2)) {
                isDragging = true;
                handleDrag = (Vector v) {
                    Vector sl = this.world.initialPendulum.startingLocation;
                    this.world.initialPendulum.angle = -atan2(sl.x - v.x, sl.y - v.y);
                    this.world.updatePendulumPositions();
                };
            } else if (pow(logicalMouseLocation.x - this.world.initialPendulum.startingLocation.x, 2) + pow(logicalMouseLocation.y - this.world.initialPendulum.startingLocation.y, 2) <= 1) {
                isDragging = true;
                handleDrag = (Vector v) {
                    Vector change = v - this.world.initialPendulum.startingLocation;
                    this.world.initialPendulum.startingLocation += change;
                    this.world.initialPendulum.location += change;
                    this.world.attachedPendulum.startingLocation += change;
                    this.world.attachedPendulum.location += change;
                };
            }
            this.world.isPaused = isDragging;
        });
        this.screen.onMouseMove.listen((MouseEvent event) {
            if (!isDragging) {
                return;
            }
            handleDrag(this.getLogicalCoordinates(new Vector(event.client.x, event.client.y)));
        });
        window.onMouseUp.listen(([MouseEvent ignored]) {
            isDragging = false;
            this.world.isPaused = false;
            handleDrag = null;
        });
        this.initialPendulumTracer = new Tracer( () => this.world.initialPendulum.location );
        this.attachedPendulumTracer = new Tracer( () => this.world.attachedPendulum.location );
        this.initialPendulumTracer.color = "rgba(255,0,0,200)";
        this.attachedPendulumTracer.color = "rgba(0,255,0,200)";
    }

    /**
     * The procedure for what happens on window resize
     */
    void resizeProc([Event ignored = null]) {
        this.startX = 0.0;
        this.startY = 0.0;
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
        Vector vc = new Vector(viewCoordinates.x, viewCoordinates.y);
        vc.y = this.screen.height - vc.y;
        return (vc - new Vector(this.startX, this.startY)) * new Vector(this.world.width, this.world.height) / new Vector(this.drawWidth, this.drawHeight);
    }

    /**
     * The method that handles drawing the pendulums and updating the page icon to screen contents
     */
    draw() {
        //Clears screen
        this.renderer.clearRect(0, 0, this.screen.width, this.screen.height);
        //Updates the tracers
        for (Tracer tracer in [this.initialPendulumTracer, this.attachedPendulumTracer]) {
            tracer.update();
            this.renderer.strokeStyle = tracer.color;
            this.renderer.beginPath();
            Vector vc = this.getViewCoordinates(tracer.points[0]);
            this.renderer.moveTo(vc.x, vc.y);
            if (tracer.points.length == 1) {
                continue;
            }
            tracer.points.sublist(1).forEach((point) {
                vc = this.getViewCoordinates(point);
                this.renderer.lineTo(vc.x, vc.y);
            });
            this.renderer.stroke();
        }
        //Draws pendulums
        renderer.strokeStyle = "black";
        renderer.fillStyle = "black";
        Vector p1 = this.getViewCoordinates(this.world.pendulums[0].startingLocation);
        Vector p2 = this.getViewCoordinates(this.world.pendulums[0].location);
        Vector p3 = this.getViewCoordinates(this.world.pendulums[1].location);
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