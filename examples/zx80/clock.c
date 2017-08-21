
/*
 *  ZX80 timing, controlled video refresh, and graphics demo.
 *  Stefano Bodrato
 * 
 *  Build examples
 * 
 *  zcc +zx80 -create-app -llib3d clock.c

 $Id: clock.c,v 1.1 2013-01-07 14:39:58 stefano Exp $
*/

#include <graphics.h>
#include <time.h>
#include <games.h>
#include <lib3d.h>
#include <stdlib.h>
#include <stdio.h>


int x,y;
int x_min,y_min;
int x_hr,y_hr;
int i,j,k,t;
int sz, long_sz, short_sz;
int cx,cy;
int tm;
int flag;
char hr[10],mn[10];

main()
{
	sz=getmaxy()/2-1;
	long_sz=sz-2;
	short_sz=sz/2;

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
	gen_tv_field_init(0);

	circle(cx,cy,cy,1);

	for (i=0;i<60;i++) {
		x=icos(i*6)*sz/256;
		y=isin(i*6)*sz/256;
		
		plot (cx+x,cy+y);
	
	}

	x=-1;

	i=0;
	
//	tm=clock();
	flag=1;
	
	while (getk()!=' ') {
	gen_tv_field();
		//tm=clock();
		if (i++ == 59) i=0;
		if (i == 45) {
			if (x != -1) {
				// min
				undraw(cx-1,cy+1,cx+x_min,cy+y_min);
				undraw(cx+1,cy-1,cx+x_min,cy+y_min);
				undraw(cx+1,cy+1,cx+x_min,cy+y_min);
				undraw(cx-1,cy-1,cx+x_min,cy+y_min);
				flag=1;
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
					flag=1;
				}
				if (k++ == 59) k=0;
			}
		}

		if (x != -1) {
			//sec
			//undraw(cx+(x/2.9),cy+(y/2),cx+x,cy+y);
			unplot(cx+x,cy+y);
		}
	gen_tv_field();
		x=icos(i*6)*long_sz/256;
	gen_tv_field();
		y=isin(i*6)*long_sz/256;

	gen_tv_field();
		x_min=icos(j*6)*long_sz/256;
	gen_tv_field();
		y_min=isin(j*6)*long_sz/256;

	gen_tv_field();
		x_hr=icos(k*6)*short_sz/256;
	gen_tv_field();
		y_hr=isin(k*6)*short_sz/256;

		// sec
	//gen_tv_field();
	// Count up to 50 frames to wait a whole second
	// 52 *could* be valid for the USA, but Eigthyone
	// seems to run faster.. is it the emulator or me ?
	// Every minute some extra delay happens, so the clock
	// is not very precise  :/
	for (t=0;t<42;t++) {
		gen_tv_field();
		plot(cx+x,cy+y);
	}
		//	draw(cx+(x/2),cy+(y/2),cx+x,cy+y);
		//draw(cx,cy,cx+x,cy+y);
	gen_tv_field();

	if (flag) {
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
		}

//		circle(cx,cy,3,1);

		flag=0;

		//while ((clock() < (tm+CLOCKS_PER_SEC))&&(clock() > CLOCKS_PER_SEC)) {}
		//tm=clock();
	
	}

}
