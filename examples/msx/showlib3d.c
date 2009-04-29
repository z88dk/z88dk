/*
3d.c

Demo using standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

MSX port by Stefano Bodrato - Oct 2003

Use stick up and down enlarge/reduce the cube
fire - exits

*/

//#include <oz.h>
#include "lib3d.h"
#include "stdio.h"
#include "stdlib.h"
//#include "graphics.h"
#include "msx/gfx.h"


#define MX	MODE2_WIDTH/2
#define MY	MODE2_HEIGHT/2


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
static int zf = 0;


// off-screen surface buffer
//unsigned char* sbuffer = (unsigned char*)malloc(MODE2_MAX);

unsigned char sbuffer[MODE2_MAX];


int main(void)
{

	surface_t surf;

	//buf = (u_char*)malloc(MODE2_MAX);
	
	surf.data.ram = sbuffer;


	// set screen to graphic mode
	set_color(15, 1, 1);
	set_mode(mode_2);
	fill(MODE2_ATTR, 0xF1, MODE2_MAX);


	while (!get_trigger(0)) {
		//if(ozkeyhit()) c = ozngetch();
		//if(getk()) c = fgetc_cons();

		c=get_stick(0);
		switch(c) {
			case st_down:
				zf -= 10;
				if(zf < -100) zf = -100;
				break;
			case st_up:
				zf += 10;
				if(zf > 300) zf = 300;
				break;
			//case '3':
			//	exit (0);
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

		//clg();
		// clear the off-screen buffer
		memset(sbuffer, 0, MODE2_MAX);	// [*] 

		/* top face */
		surface_draw(&surf,p[0].x + MX, p[0].y + MY, p[1].x + MX, p[1].y + MY);
		surface_draw(&surf,p[1].x + MX, p[1].y + MY, p[2].x + MX, p[2].y + MY);
		surface_draw(&surf,p[2].x + MX, p[2].y + MY, p[3].x + MX, p[3].y + MY);
		surface_draw(&surf,p[3].x + MX, p[3].y + MY, p[0].x + MX, p[0].y + MY);
		/* bottom face */
		surface_draw(&surf,p[4].x + MX, p[4].y + MY, p[5].x + MX, p[5].y + MY);
		surface_draw(&surf,p[5].x + MX, p[5].y + MY, p[6].x + MX, p[6].y + MY);
		surface_draw(&surf,p[6].x + MX, p[6].y + MY, p[7].x + MX, p[7].y + MY);
		surface_draw(&surf,p[7].x + MX, p[7].y + MY, p[4].x + MX, p[4].y + MY);
		/* side faces */
		surface_draw(&surf,p[0].x + MX, p[0].y + MY, p[4].x + MX, p[4].y + MY);
		surface_draw(&surf,p[1].x + MX, p[1].y + MY, p[5].x + MX, p[5].y + MY);
		surface_draw(&surf,p[2].x + MX, p[2].y + MY, p[6].x + MX, p[6].y + MY);
		surface_draw(&surf,p[3].x + MX, p[3].y + MY, p[7].x + MX, p[7].y + MY);
        //ozsetdisplaypage(!ozgetdisplaypage());
        
		//ozsetactivepage(!ozgetactivepage());

		// show the off-screen buffer
		msx_vwrite_direct(sbuffer, 0, MODE2_MAX);
	}

	// go back to text mode
	set_mode(mode_0);
}
