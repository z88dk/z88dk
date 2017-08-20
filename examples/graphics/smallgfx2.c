
#include <graphics.h>
#include <stdio.h>
#include <math.h>

main()
{
int x,a;
	clg();
	
	for (x=1;x<95;x++)
		{
		a=50-x;
		plot (x,32-(a*a/80));
	}
	
/* Draw a diamond - weak, but it demonstrates relative drawing! */
        
        plot(61,25);
	        drawr(15,15);
	        drawr(15,-15);
	        drawr(-15,-15);
	        drawr(-15,15);

        circle(30,30,20,1);
	circle(30,30,28,1);

	fill(8,35);
	
	fill(70,30);
	
	while (getk() != 13) {};
}
