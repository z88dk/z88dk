
#include <stdio.h>
#include <graphics.h>


main()
{
	draw(2,2,60,40);

/* Draw a diamond - weak, but it demonstrates relative drawing! */
	plot(8,8);
	        drawr(8,8);
	        drawr(8,-8);
	        drawr(-8,-8);
	        drawr(-8,8);

	circle(30,30,13,1);
	circle(30,30,17,1);

	//fill(8,30);
	fgetc_cons();

}
