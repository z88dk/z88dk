
#include <graphics.h>


main()
{
	clg();
	draw(0,0,95,63);

/* Draw a diamond - weak, but it demonstrates relative drawing! */
        plot(64,25);
	        drawr(15,15);
	        drawr(15,-15);
	        drawr(-15,-15);
	        drawr(-15,15);

        circle(30,30,20,1);
	circle(30,30,28,1);

	fill(8,30);

}
