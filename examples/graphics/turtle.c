/*

	Z88DK base graphics libraries examples
	Simple turtle graphics example.
	'wide resolution' graphics drivers will double the x coordinate pointer to keep the aspect ratio
	
	The picture size is adapted to the target display size,
	this is also a good example on how to pass a function as a parameters
	
	to build:  zcc +<target> <stdio options> -llib3d -create-app turtle.c
	
	Examples:
		zcc +zx -lndos -create-app -llib3d turtle.c
		zcc +ts2068 -lgfx2068hr -lndos -create-app -llib3d turtle.c
	
	$Id: turtle.c $

*/


#include <graphics.h>
#include <lib3d.h>


void square (int x) {
		fwd(x);
		turn_right(90);
		fwd(x);
		turn_right(90);
		fwd(x);
		turn_right(90);
		fwd(x);
		turn_right(90);
}

void triangle (int x) {
		fwd(x);
		turn_right(120);
		fwd(x);
		turn_right(120);
		fwd(x);
		turn_right(120);
}

void init () {
	clg();
	unplot(0,0);
	pen_up();
	move (getmaxx()/2,getmaxy()/2);
	pen_down();
}

int rotate (int a, int n, int c, void (*f)(int)) {
	while (n > 0) {
		turn_right(a);
		(*f)(n);
		n=n-c;
	}
}


int main()
{
	while (1) {
		init();
		rotate(8,getmaxy()/3,2,square);
		init();
		rotate(8,getmaxy()/2,2,triangle);
	}
}
