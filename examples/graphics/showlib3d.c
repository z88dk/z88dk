/*
3d.c

Demo using standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

Flickering (non paged graphics) port to Z88DK by Stefano Bodrato - Oct 2003

use keys 1 and 2 to enlarge/reduce the cube
3 - exits

*/

// zcc +zx -vn showlib3d.c -o showlib3d -lndos -llib3d -create-app

//#include <oz.h>
#include <lib3d.h>
#include <graphics.h>
#include <stdio.h>
#include <stdlib.h>

//#define TIMING

int main(void);

/*
#define MX	238/2
#define MY	80/2
*/

#define MX	96/2
#define MY	64/2

Vector_t cube[8]
= { { -20 ,  20,   20 },
	{  20 ,  20,   20 },
	{  20 , -20,   20 },
	{ -20 , -20,   20 },
	{ -20 ,  20,  -20 },
	{  20 ,  20,  -20 },
	{  20 , -20,  -20 },
	{ -20 , -20,  -20 } };

int main(void)
{
	static Vector_t rot;
	static Vector_t t;
	static Point_t p[8];
	static unsigned c = 0;
	static int i;
	static int zf = 0;
#ifdef TIMING
    extern unsigned _oz64hz_word;
    static unsigned frames;
#endif
    //ozinitprofiler();
	//ozsetactivepage(1);
	//ozsetdisplaypage(0);
#ifdef TIMING
    frames=0;
    _oz64hz_word=0;
#endif
	while(c != 13) {
		//if(ozkeyhit()) c = ozngetch();
		//if(getk()) c = fgetc_cons();
		c=getk();
		switch(c) {
			case '1':
				zf -= 10;
				if(zf < -100) zf = -100;
				break;
			case '2':
				zf += 10;
				if(zf > 300) zf = 300;
				break;
			case '3':
				exit (0);
		}
		c = 0;
		for(i = 0; i < 8; i++) {
			ozcopyvector(&t,&cube[i]);
			ozrotatepointx(&t, rot.x);
			ozrotatepointy(&t, rot.y);
			t.z += zf; /* zoom factor */
			ozplotpoint(&t, &p[i]);
		}
		rot.y = (rot.y+1)%360;
		rot.x = (rot.x+2)%360;
		clg();
		/* top face */
		draw(p[0].x + MX, p[0].y + MY, p[1].x + MX, p[1].y + MY);
		draw(p[1].x + MX, p[1].y + MY, p[2].x + MX, p[2].y + MY);
		draw(p[2].x + MX, p[2].y + MY, p[3].x + MX, p[3].y + MY);
		draw(p[3].x + MX, p[3].y + MY, p[0].x + MX, p[0].y + MY);
		/* bottom face */
		draw(p[4].x + MX, p[4].y + MY, p[5].x + MX, p[5].y + MY);
		draw(p[5].x + MX, p[5].y + MY, p[6].x + MX, p[6].y + MY);
		draw(p[6].x + MX, p[6].y + MY, p[7].x + MX, p[7].y + MY);
		draw(p[7].x + MX, p[7].y + MY, p[4].x + MX, p[4].y + MY);
		/* side faces */
		draw(p[0].x + MX, p[0].y + MY, p[4].x + MX, p[4].y + MY);
		draw(p[1].x + MX, p[1].y + MY, p[5].x + MX, p[5].y + MY);
		draw(p[2].x + MX, p[2].y + MY, p[6].x + MX, p[6].y + MY);
		draw(p[3].x + MX, p[3].y + MY, p[7].x + MX, p[7].y + MY);
        //ozsetdisplaypage(!ozgetdisplaypage());
#ifdef TIMING
        frames++;
        if(_oz64hz_word>64*10)
        {
            static char buf[80];
            sprintf(buf,"%d frames in 10 seconds",frames);
            ozputs(0,0,buf);
            ozgetch();
            _oz64hz_word=0;
            frames=0;
        }
#endif
		//ozsetactivepage(!ozgetactivepage());
	}
}
