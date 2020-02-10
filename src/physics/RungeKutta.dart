class PositionAndSpeed {

    double position;
    double speed;

    PositionAndSpeed(this.position, this.speed);

    PositionAndSpeed.empty() {
        this.position = 0.0;
        this.speed = 0.0;
    }

    operator +(PositionAndSpeed other) => new PositionAndSpeed(this.position + other.position, this.speed + other.position);
    operator *(double scalar) => new PositionAndSpeed(this.position * scalar, this.speed * scalar);
    operator /(double scalar) => new PositionAndSpeed(this.position / scalar, this.speed / scalar);

}

PositionAndSpeed rungeKutta(PositionAndSpeed initialState, double dt, Function(PositionAndSpeed, Double) computeAccelerationFunction) {

    PositionAndSpeed evaluateFunction(PositionAndSpeed state, double dt, PositionAndSpeed previousResults) {
        PositionAndSpeed eulerStep = state + previousResults * dt;
        return new PositionAndSpeed(eulerStep.speed, computeAccelerationFunction(eulerStep, dt));
    }

    PositionAndSpeed a = evaluateFunction(initialState, 0.0, PositionAndSpeed.empty());
    PositionAndSpeed b = evaluateFunction(initialState, dt / 2, a);
    PositionAndSpeed c = evaluateFunction(initialState, dt / 2, b);
    PositionAndSpeed d = evaluateFunction(initialState, dt, c);

    return (a + 2.0 * (b + c) + d) / 6.0;

}
