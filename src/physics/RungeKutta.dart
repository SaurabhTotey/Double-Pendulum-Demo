/**
 * The Runge Kutta function
 * Takes in an initial input that maps to an initial output
 * Takes in a derivative function that takes a given input and outputs the derivative or change in output at the input
 * Takes in the step from the given initial input
 * Returns an approximation of the output at initialInput + inputStep
 * If changeFunction always returns the same thing (is a constant function), this method effectively is euler's method
 */
double rungeKutta(double initialInput, double initialOutput, double inputStep, double changeFunction(double)) {
    return initialOutput + inputStep / 6 * (initialOutput + 4 * changeFunction(initialInput + inputStep / 2) + changeFunction(initialInput + inputStep));
}