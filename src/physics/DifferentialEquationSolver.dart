
/**
 * A class that holds both a position and a speed, and contains some utility operator overloads
 */
class PositionAndSpeed {

    double position;
    double speed;

    /**
     * Constructs a position and speed that takes in both fields
     */
    PositionAndSpeed(this.position, this.speed);

    /**
     * Constructs a PositionAndSpeed where both position and speed are 0
     */
    PositionAndSpeed.empty() {
        this.position = 0.0;
        this.speed = 0.0;
    }

    operator +(PositionAndSpeed other) => new PositionAndSpeed(this.position + other.position, this.speed + other.speed);
    operator *(double scalar) => new PositionAndSpeed(this.position * scalar, this.speed * scalar);
    operator /(double scalar) => new PositionAndSpeed(this.position / scalar, this.speed / scalar);

}

/**
 * Evaluates a position and speed state a time dt after the state given by initialState
 * Needs to be given a function to calculate acceleration at any arbitrary time dt away from any arbitrary state
 * Uses the Runge-Kutta 4 method to do so
 * All math used is stolen from https://gafferongames.com/post/integration_basics/
 */
PositionAndSpeed rungeKutta(PositionAndSpeed initialState, double dt, Function(PositionAndSpeed) computeAccelerationFunction) {

    PositionAndSpeed numericalDerivative(PositionAndSpeed state, double dt, PositionAndSpeed previousNumericalDerviative) {
        PositionAndSpeed eulerStep = state + previousNumericalDerviative * dt;
        return new PositionAndSpeed(eulerStep.speed, computeAccelerationFunction(eulerStep));
    }

    PositionAndSpeed a = numericalDerivative(initialState, 0.0, PositionAndSpeed.empty());
    PositionAndSpeed b = numericalDerivative(initialState, dt / 2.0, a);
    PositionAndSpeed c = numericalDerivative(initialState, dt / 2.0, b);
    PositionAndSpeed d = numericalDerivative(initialState, dt, c);

    return initialState + (a + (b + c) * 2.0 + d) / 6.0 * dt;

}

/**
 * Evaluates a position and speed state a time dt after the state given by the initialState
 * Needs to be given a function to calculate acceleration at any arbitrary time dt away from any arbitrary state
 * Uses the Forward-Euler method to do so
 * Is worse than rungeKutta, and should only be used for testing
 * This method is really bad and actually inserts energy into the system
 */
PositionAndSpeed forwardEuler(PositionAndSpeed initialState, double dt, Function(PositionAndSpeed) computeAccelerationFunction) {
    PositionAndSpeed copy = new PositionAndSpeed(initialState.position, initialState.speed);
    copy.position += copy.speed * dt;
    copy.speed += computeAccelerationFunction(initialState) * dt;
    return copy;
}

/**
 * Evaluates a position and speed state a time dt after the state given by the initialState
 * Needs to be given a function to calculate acceleration at any arbitrary time dt away from any arbitrary state
 * Uses the Semi-Implicit-Euler method to do so
 * Is worse than rungeKutta, and should only be used for testing
 * Approximately keeps energy constant
 */
PositionAndSpeed semiImplicitEuler(PositionAndSpeed initialState, double dt, Function(PositionAndSpeed) computeAccelerationFunction) {
    PositionAndSpeed copy = new PositionAndSpeed(initialState.position, initialState.speed);
    copy.speed += computeAccelerationFunction(initialState) * dt;
    copy.position += copy.speed * dt;
    return copy;
}
