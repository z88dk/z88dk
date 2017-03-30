
/*
 *  Yet another demo.
 *  Timing accuracy depends on the target platform and on the clock()
 *  implementation.   If clock() is not available a (bad) surrogate could
 *  be sleep(1) or csleep(95) or a delay loop.
 * 
 *  Build examples
 *  zcc +zx -oclock -lndos -create-app -lm -llib3d -DDETAILED clock.c
 *  zcc +zx81ansi -oclock -startup=3 -lgfx81hr192 -lndos -create-app -llib3d -DDETAILED clock.c
 *  zcc +zx81 -oclock -startup=2 -lgfx81 -lndos -create-app -llib3d clock.c
 *  zcc +ts2068 -create-app -lm -lgfx2068hr -lm -llib3d -DDETAILED -Dhires clock.c

 $Id: clock.c,v 1.1 2012-11-07 15:10:06 stefano Exp $
*/

#include <graphics.h>
#include <time.h>
#include <games.h>
#include <lib3d.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef hires
#define XDIV 128
#else
#define XDIV 256
#endif

#ifdef DETAILED
// 16 bytes every sprite with the exception of #8 which is 23 bytes long
char roman_nums[] = { 
// twelve
15, 7, 0xEE , 0xEE , 0x44 , 0x44 , 0x28 , 0x44 , 0x10 , 0x44 , 0x28 , 0x44 , 0x44 , 0x44 , 0xEE , 0xEE,
// one
11, 7, 0x0E , 0x10 , 0x04 , 0x00 , 0x04 , 0x00 , 0x04 , 0x00 , 0x04 , 0x00 , 0x04 , 0x00 , 0x0E , 0x10,
11, 7, 0x3B , 0x80 , 0x11 , 0x00 , 0x11 , 0x00 , 0x11 , 0x00 , 0x11 , 0x00 , 0x11 , 0x00 , 0x3B , 0x80,
11, 7, 0xEE , 0xE0 , 0x44 , 0x40 , 0x44 , 0x40 , 0x44 , 0x40 , 0x44 , 0x40 , 0x44 , 0x40 , 0xEE , 0xE0 ,
11, 7, 0xEE , 0xE0 , 0x44 , 0x40 , 0x44 , 0x40 , 0x42 , 0x80 , 0x42 , 0x80 , 0x41 , 0x00 , 0xE1 , 0x00,
11, 7, 0x3B , 0x80 , 0x11 , 0x00 , 0x11 , 0x00 , 0x0A , 0x00 , 0x0A , 0x00 , 0x04 , 0x00 , 0x04 , 0x00,
11, 7, 0xEE , 0xE0 , 0x44 , 0x40 , 0x44 , 0x40 , 0x28 , 0x40 , 0x28 , 0x40 , 0x10 , 0x40 , 0x10 , 0xE0,
15, 7, 0xEE , 0xEE , 0x44 , 0x44 , 0x44 , 0x44 , 0x28 , 0x44 , 0x28 , 0x44 , 0x10 , 0x44 , 0x10 , 0xEE,
// eight
 19, 7, 0xEE , 0xEE , 0xE0 , 0x44 , 0x44 , 0x40 , 0x44 , 0x44 , 0x40 , 0x28 , 0x44, 0x40 , 0x28 , 0x44 , 0x40 , 0x10 , 0x44 , 0x40 , 0x10 , 0xEE , 0xE0,

 11, 7, 0xEE , 0xE0 , 0x44 , 0x40 , 0x42 , 0x80 , 0x41 , 0x00 , 0x42 , 0x80 , 0x44, 0x40 , 0xEE , 0xE0,
11, 7, 0x3B , 0x80 , 0x11 , 0x00 , 0x0A , 0x00 , 0x04 , 0x00 , 0x0A , 0x00 , 0x11 , 0x00 , 0x3B , 0x80,
11, 7, 0xEE , 0xE0 , 0x44 , 0x40 , 0x28 , 0x40 , 0x10 , 0x40 , 0x28 , 0x40 , 0x44 , 0x40 , 0xEE , 0xE0
};
#endif


int x,y;
int x_min,y_min;
int x_hr,y_hr;
int i,j,k;
int sz, long_sz, short_sz;
int cx,cy;
int tm;
char hr[10],mn[10];

main()
{
#ifdef DETAILED
	sz=getmaxy()/2-5;
	long_sz=sz-18;
	short_sz=sz/2;
#else
	sz=getmaxy()/2-1;
	long_sz=sz-2;
	short_sz=sz/2;
#endif	
	cx=getmaxx()/2;
	cy=getmaxy()/2;
	
	printf("%cTime set..\n\n  Hours: ",12);
	gets(hr);
	k=atoi(hr);
	printf("\n  Minutes: ");
	scanf("%s",hr);
	j=atoi(hr);

	k=k*5+(j/12);
	if (k<15)
		k=k+45;
	else
		k-=15;

	if (j<15)
		j=j+45;
	else
		j-=15;
	
	clg();

#ifdef hires
	circle(cx,cy,cy*2,1);
#else
	circle(cx,cy,cy,1);
#endif
	
#ifdef DETAILED
#ifdef hires
	circle(cx,cy,cy*2-4,1);
	circle(cx,cy,7,1);
#else
	circle(cx,cy,cy-3,1);
	circle(cx,cy,3,1);
#endif
#endif
	for (i=0;i<60;i++) {
		x=icos(i*6)*sz/XDIV;
		y=isin(i*6)*sz/256;
		
		plot (cx+x,cy+y);
	
	}

#ifdef DETAILED
	for (i=0;i<12;i++) {
		x=isin(i*30)*(sz-8)/XDIV;
		y=icos(i*30)*(sz-8)/256;
		putsprite(spr_or, cx+x-5, cy-y-3, roman_nums + i*16 + 7*(i>8));
	}
#endif

	x=-1;

	i=0;
	
	tm=clock();
	
	while (getk()!=' ') {
		tm=clock();
		if (i++ == 59) i=0;
		if (i == 45) {
			if (x != -1) {
				// min
				undraw(cx-1,cy+1,cx+x_min,cy+y_min);
				undraw(cx+1,cy-1,cx+x_min,cy+y_min);
				undraw(cx+1,cy+1,cx+x_min,cy+y_min);
				undraw(cx-1,cy-1,cx+x_min,cy+y_min);
			}
			if (j++ == 59) {
				j=0;
			}
			if (j == 45) {
				if (x != -1) {
					undraw(cx,cy,cx+x_hr,cy+y_hr);
					undraw(cx-1,cy+1,cx+x_hr-1,cy+y_hr+1);
					undraw(cx+1,cy-1,cx+x_hr+1,cy+y_hr-1);
					undraw(cx+1,cy+1,cx+x_hr+1,cy+y_hr+1);
					undraw(cx-1,cy-1,cx+x_hr-1,cy+y_hr-1);
				}
				if (k++ == 59) k=0;
			}
		}

		if (x != -1) {
			//sec
			undraw(cx,cy,cx+x,cy+y);
		}
		
		x=icos(i*6)*long_sz/XDIV;
		y=isin(i*6)*long_sz/256;

		x_min=icos(j*6)*long_sz/XDIV;
		y_min=isin(j*6)*long_sz/256;

		x_hr=icos(k*6)*short_sz/XDIV;
		y_hr=isin(k*6)*short_sz/256;

		// sec
		draw(cx,cy,cx+x,cy+y);

		// min
		draw(cx-1,cy+1,cx+x_min,cy+y_min);
		draw(cx+1,cy-1,cx+x_min,cy+y_min);
		draw(cx+1,cy+1,cx+x_min,cy+y_min);
		draw(cx-1,cy-1,cx+x_min,cy+y_min);

		// hr
		draw(cx,cy,cx+x_hr,cy+y_hr);
		draw(cx-1,cy+1,cx+x_hr-1,cy+y_hr+1);
		draw(cx+1,cy-1,cx+x_hr+1,cy+y_hr-1);
		draw(cx+1,cy+1,cx+x_hr+1,cy+y_hr+1);
		draw(cx-1,cy-1,cx+x_hr-1,cy+y_hr-1);

		circle(cx,cy,3,1);
#ifdef DETAILED
		circle(cx,cy,5,1);
#endif

		//sleep (1);
		while ((clock() < (tm+CLOCKS_PER_SEC))&&(clock() > CLOCKS_PER_SEC)) {}
		tm=clock();
	
	}

}
