/* Float16 support */



double doub_val;


_Float16 func1(_Float16 a, _Float16 b) {
	return a + b;
}

_Float16 func1a_TypedConstants() {
	return func1(3.14f16, 2.5f16);
}
_Float16 func1a_OpenConstants() {
	return func1(3.14, 2.5);
}

// This will promote up to double
_Float16 func2(_Float16 a) {
	return a * doub_val;
}

// Remains at _Float16 level
_Float16 func3a(_Float16 a) {
	return a * 2.5;
}
_Float16 func3b(_Float16 a) {
	return 2.5 * a;
}
_Float16 func3c(_Float16 a) {
	return 3 * a;
}
_Float16 func3d(_Float16 a) {
	return a * 3;
}
// Uses ldexp
_Float16 func3e(_Float16 a) {
	return 2 * a;
}
// Uses ldexp
_Float16 func3f(_Float16 a) {
	return a * 2;
}
_Float16 func4c(_Float16 a) {
	return 3 / a;
}
_Float16 func4d(_Float16 a) {
	return a / 3;
}
