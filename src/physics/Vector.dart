import 'dart:math';

/**
 * A class that represents a mathematical vector in 2 dimensions
 */
class Vector {

    double x;
    double y;


    /**
     * Creates a vector that takes in both fields
     */
    Vector(this.x, this.y);

    /**
     * Constructs a vector; fields both get set to given value
     */
    Vector.isosceles(double val) {
        this.x = val;
        this.y = val;
    }

    /**
     * Constructs a vector; fields default to 0
     */
    Vector.empty() {
        this.x = 0.0;
        this.y = 0.0;
    }

    operator +(Vector other) => new Vector(this.x + other.x, this.y + other.y);
    operator -(Vector other) => new Vector(this.x - other.x, this.y - other.y);
    operator *(Vector other) => new Vector(this.x * other.x, this.y * other.y);
    operator /(Vector other) => new Vector(this.x / other.x, this.y / other.y);
    operator %(Vector other) => new Vector(this.x % other.x, this.y % other.y);

    // operator +(double scalar) => new Vector(this.x + scalar, this.y + scalar);
    // operator -(double scalar) => new Vector(this.x - scalar, this.y - scalar);
    // operator *(double scalar) => new Vector(this.x * scalar, this.y * scalar);
    // operator /(double scalar) => new Vector(this.x / scalar, this.y / scalar);
    // operator %(double scalar) => new Vector(this.x % scalar, this.y % scalar);

    double get length => sqrt(pow(this.x, 2) + pow(this.y, 2));
    void set length(double l) {
        final scalar = l / this.length;
        this.x *= scalar;
        this.y *= scalar;
    }

    double get angle => atan2(this.y, this.x);
    void set angle(double a) {
        final l = this.length;
        this.x = sin(a) * l;
        this.y = cos(a) * l;
    }

}

/**
 * Gets the dot product of two vectors
 */
double dot(Vector a, Vector b) => a.x * b.x + a.y + b.y;