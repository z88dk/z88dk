/* Accum support */



double doub_val;


_Accum func1(_Accum a, _Accum b) {
	return a + b;
}

_Accum func1a_TypedConstants() {
	return func1(3.14hk, 2.5hk);
}
_Accum func1a_OpenConstants() {
	return func1(3.14, 2.5);
}

// This will promote up to double
_Accum func2(_Accum a) {
	return a * doub_val;
}

// Remains at _Accum level
_Accum func3a(_Accum a) {
	return a * 2.5;
}
_Accum func3b(_Accum a) {
	return 2.5 * a;
}
_Accum func3c(_Accum a) {
	return 3 * a;
}
_Accum func3d(_Accum a) {
	return a * 3;
}

_Accum func3e(_Accum a) {
	return 2 * a;
}

_Accum func3f(_Accum a) {
	return a * 2;
}
_Accum func4c(_Accum a) {
	return 3 / a;
}
_Accum func4d(_Accum a) {
	return a / 3;
}
_Accum func4e(_Accum a) {
	return 1 / a;
}

// RHS is promoted to double
_Accum func5a(double a, _Accum b) {
        return a * b;
}
// LHS is promoted to double
_Accum func5b(double a, _Accum b) {
        return b * a;
}
// LHS int is promoted to double
_Accum func5c(int a, double b) {
        return a * b;
}
// RHS int is promoted to double
_Accum func5d(int a, double b) {
        return b * a;
}
// RHS is promoted to _Accum
_Accum func5e(int a, _Accum b) {
        return b * a;
}
// LHS is promoted to _Accum
_Accum func5f(int a, _Accum b) {
        return a * b;
}

// RHS is promoted to double
_Accum func6a(double a, _Accum b) {
        return a + b;
}
// LHS is promoted to double
_Accum func6b(double a, _Accum b) {
        return b + a;
}
// LHS int is promoted to double
_Accum func6c(int a, double b) {
        return a + b;
}
// RHS int is promoted to double
_Accum func6d(int a, double b) {
        return b + a;
}
// RHS is promoted to _Accum
_Accum func6e(int a, _Accum b) {
        return b + a;
}
// LHS is promoted to _Accum
_Accum func6f(int a, _Accum b) {
        return a + b;
}

// RHS int is promoted to _Accum
_Accum func7a(long a, _Accum b) {
        return b + a;
}
// LHS is promoted to _Accum
_Accum func7b(long a, _Accum b) {
        return a + b;
}
// RHS int is promoted to _Floa16
_Accum func7c(long a, _Accum b) {
        return b * a;
}
// LHS is promoted to _Accum
_Accum func7d(long a, _Accum b) {
        return a * b;
}

_Accum func8a() {
	return 1.0;
}

_Accum func8b() {
	return 1L;
}
