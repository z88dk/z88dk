	/*
		Z88DK base graphics libraries examples
		Spirograph curves
		Stefano Bodrato 2014
		ref: http://linuxgazette.net/133/luana.html
		
		For graphics only devices (no text), add "-pragma-redirect=fputc_cons=putc4x6"
		On Sinclair computers the specific maths library can be used, but in full form only (TINY mode will fail).
		
		Examples:
		  zcc +zx -lm -lndos -create-app spirograph.c
		  zcc +zx --math32 -lndos -create-app spirograph.c
	*/

	#include <graphics.h>
	#include <stdio.h>
	#include <math.h>

	float t,incr;
	float r0,r1,p;
	float cx,cy;
	float scale,loops;
	char  inputline[100];

	float x(float t) {
	return ((r0-r1)*cos(t) + p*cos((r0-r1)*t/r1));
	}

	float y(float t) {
	return ((r0-r1)*sin(t) - p*sin((r0-r1)*t/r1));
	}

	main()
	{

		printf ("%c\nOuter wheel radius (100) ?  ",12);
		r0=atof(fgets_cons(inputline,100));
		if (r0==0.0) r0=100.0;
		
		printf ("\nInner wheel radius (2) ?  ");
		r1=atof(fgets_cons(inputline,100));
		if (r1==0.0) r1=2.0;
		
		printf ("\nP wheel deta (80) ?  ");
		p=atof(fgets_cons(inputline,100));
		if (p==0.0) p=80.0;

		printf ("\nLoops (1) ?  ");
		loops=atof(fgets_cons(inputline,100));
		if (loops==0.0) loops=1.0;

		cx=getmaxx()/2.0;
		cy=getmaxy()/2.0;

		scale=cy/(r0+p);

		clg();

		incr=1.0/(float)360.0;

		for (t=0.0; t<=M_PI*2.0*loops; t=t+incr)
		{
				if (t==0.0)
					plot ( cx+(int) (x(t)*scale), cy-(y(t)*scale));
				else
					drawto ( cx+(int) (x(t)*scale), cy-(y(t)*scale));
		}
		
		while (getk() != '\n') {};

	}
  
