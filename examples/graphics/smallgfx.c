
#include <graphics.h>


void main()
{
	clg();

	/* diagonal row */
	draw(0,0,getmaxx(),getmaxy());  /* the lowest resolution we have is the ZX81 one */

	if (getmaxx()<100) {
		/* Draw a diamond - weak, but it demonstrates relative drawing! */
        plot(50,8);
	        drawr(6,6);
	        drawr(6,-6);
	        drawr(-6,-6);
	        drawr(-6,6);

	} else {

		/* Draw a diamond */
        plot(64,25);
	        drawr(15,15);
	        drawr(15,-15);
	        drawr(-15,-15);
	        drawr(-15,15);

	}

	circle(30,30,20,1);
	circle(30,30,28,1);
		fill(8,30);

}
