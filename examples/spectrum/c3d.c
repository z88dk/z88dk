
/*
	Coloured lib3d demo - uses the "buffer" feature to avoid flicker
	uses cclg, cplot, ccopybuffer.

	The "lr64x48" #define activates the alternate resolution.
	Comment out the "bufferedgfx" #define to see what happens behind the scenes.

	build with:   zcc +zx -lndos -lm -create-app lib3d.c
	              - or -
	              zcc +zx -lndos -lm -create-app -DALTLOWGFX lib3d.c

	$id:$
*/

//#define ALTLOWGFX  1
#define bufferedgfx 1

#include <stdio.h>
#include <zxlowgfx.h>
//#include <math.h>
#include <lib3d.h>

#define MX	10
#define MY	10

#define COLOR1 6	// foreground cube color
#define COLOR2 2	// background cube color

Vector_t cube[8]
= { { -20 ,  20,   20 },
	{  20 ,  20,   20 },
	{  20 , -20,   20 },
	{ -20 , -20,   20 },
	{ -20 ,  20,  -20 },
	{  20 ,  20,  -20 },
	{  20 , -20,  -20 },
	{ -20 , -20,  -20 } };

	static Vector_t rot;
	static Vector_t t;
	static Point_t p[8];
	static unsigned c = 0;
	static int i;
	static int zf = 600;

#ifdef ALTLOWGFX  
  #define ddraw(x,y,x1,y1,c) cdraw(2*(x),y,2*(x1),y1,c);
#else
  #define ddraw(x,y,x1,y1,c) cdraw(x,2*(y),x1,2*(y1),c);
#endif

void main()
{
	cclg(0);	// Clear screen and init pattern
	
	while(c != 13) {
		//if(ozkeyhit()) c = ozngetch();
		//if(getk()) c = fgetc_cons();
		c=getk();
		switch(c) {
			case '1':
				zf -= 10;
				if(zf < 300) zf = 300;
				break;
			case '2':
				zf += 10;
				if(zf > 1000) zf = 1000;
				break;
			//case '3':
			//	exit (0);
		}
		c = 0;
		for(i = 0; i < 8; i++) {
			ozcopyvector(&t,&cube[i]);
			ozrotatepointx(&t, rot.x);
			ozrotatepointy(&t, rot.y);
			t.z += zf;  // zoom factor
			ozplotpoint(&t, &p[i]);
		}
		rot.y = (rot.y+1)%360;
		rot.x = (rot.x+2)%360;
		
		cclgbuffer(0); // clear color buffer (no pattern: faster)


		// top face
		ddraw(10+p[0].y + MX, 5+p[0].x + MY, 10+p[1].y + MX, 5+p[1].x + MY, COLOR2);
		ddraw(10+p[1].y + MX, 5+p[1].x + MY, 10+p[2].y + MX, 5+p[2].x + MY, COLOR2);
		ddraw(10+p[2].y + MX, 5+p[2].x + MY, 10+p[3].y + MX, 5+p[3].x + MY, COLOR2);
		ddraw(10+p[3].y + MX, 5+p[3].x + MY, 10+p[0].y + MX, 5+p[0].x + MY, COLOR2);
		// bottom face
		ddraw(10+p[4].y + MX, 5+p[4].x + MY, 10+p[5].y + MX, 5+p[5].x + MY, COLOR2);
		ddraw(10+p[5].y + MX, 5+p[5].x + MY, 10+p[6].y + MX, 5+p[6].x + MY, COLOR2);
		ddraw(10+p[6].y + MX, 5+p[6].x + MY, 10+p[7].y + MX, 5+p[7].x + MY, COLOR2);
		ddraw(10+p[7].y + MX, 5+p[7].x + MY, 10+p[4].y + MX, 5+p[4].x + MY, COLOR2);
		// side faces
		ddraw(10+p[0].y + MX, 5+p[0].x + MY, 10+p[4].y + MX, 5+p[4].x + MY, COLOR2);
		ddraw(10+p[1].y + MX, 5+p[1].x + MY, 10+p[5].y + MX, 5+p[5].x + MY, COLOR2);
		ddraw(10+p[2].y + MX, 5+p[2].x + MY, 10+p[6].y + MX, 5+p[6].x + MY, COLOR2);
		ddraw(10+p[3].y + MX, 5+p[3].x + MY, 10+p[7].y + MX, 5+p[7].x + MY, COLOR2);


		// top face
		ddraw(p[0].x + MX, p[0].y + MY, p[1].x + MX, p[1].y + MY, COLOR1);
		ddraw(p[1].x + MX, p[1].y + MY, p[2].x + MX, p[2].y + MY, COLOR1);
		ddraw(p[2].x + MX, p[2].y + MY, p[3].x + MX, p[3].y + MY, COLOR1);
		ddraw(p[3].x + MX, p[3].y + MY, p[0].x + MX, p[0].y + MY, COLOR1);
		// bottom face
		ddraw(p[4].x + MX, p[4].y + MY, p[5].x + MX, p[5].y + MY, COLOR1);
		ddraw(p[5].x + MX, p[5].y + MY, p[6].x + MX, p[6].y + MY, COLOR1);
		ddraw(p[6].x + MX, p[6].y + MY, p[7].x + MX, p[7].y + MY, COLOR1);
		ddraw(p[7].x + MX, p[7].y + MY, p[4].x + MX, p[4].y + MY, COLOR1);
		// side faces
		ddraw(p[0].x + MX, p[0].y + MY, p[4].x + MX, p[4].y + MY, COLOR1);
		ddraw(p[1].x + MX, p[1].y + MY, p[5].x + MX, p[5].y + MY, COLOR1);
		ddraw(p[2].x + MX, p[2].y + MY, p[6].x + MX, p[6].y + MY, COLOR1);
		ddraw(p[3].x + MX, p[3].y + MY, p[7].x + MX, p[7].y + MY, COLOR1);


		ccopybuffer(); // display new frame
	}
	
}

