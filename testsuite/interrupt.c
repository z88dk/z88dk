
extern void func3(void *);

void funcnmi() __critical  __interrupt {
	func3(0);
}

void func2im2()  __interrupt {
	int	x;
	func3(&x);
}

void func2im1() __critical  __interrupt(0) {
	long y;
	func3(&y);
}
