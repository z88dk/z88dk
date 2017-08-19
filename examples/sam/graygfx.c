
#include <graphics.h>
#include <math.h>
#include <gray.h>

#pragma string name GrayTest

main()
{
int x,a;

	g_clg(G_WHITE);
		
	for (x=1;x<95;x++)
		{
		a=50-x;
		g_plot (x,32-(a*a/80),G_BLACK);
	}


	g_draw(3,3,93,3,G_DARK);
	g_draw(3,3,3,61,G_DARK);
	g_draw(93,3,93,61,G_DARK);
	g_draw(3,61,93,61,G_DARK);

	g_draw(2,2,92,2,G_LIGHT);
	g_draw(2,2,2,60,G_LIGHT);
	g_draw(92,2,92,60,G_LIGHT);
	g_draw(2,60,92,60,G_LIGHT);


/* Draw a diamond - weak, but it demonstrates relative drawing! */

        g_plot(61,25,G_DARK);
	        g_drawr(15,15,G_DARK);
	        g_drawr(15,-15,G_DARK);
	        g_drawr(-15,-15,G_DARK);
	        g_drawr(-15,15,G_DARK);

        g_circle(30,30,20,1,G_BLACK);
	g_circle(30,30,28,1,G_BLACK);

	g_page(1);
	fill(8,30);
	fill(70,30);
	
	g_page(0);
	fill(30,5);
	
	
	g_circle(30,30,25,1,G_WHITE);
	
	g_circle(30,30,40,1,G_BLACK);
	g_circle(30,30,41,1,G_DARK);
	g_circle(30,30,42,1,G_LIGHT);
	g_circle(30,30,43,1,G_WHITE);
	
	//while (1 != 2) {};
}
