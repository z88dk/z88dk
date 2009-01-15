/*
3d.c

Demo using standard Wizard 3d and 4d math functions
Copyright© 2002, Mark Hamilton

Freehand port to Z88DK/MSX to experiment various mixed libraries flavours.
The framebuffer system comes from the GFX lib, Copyright (C) 2004  Rafael de Oliveira Jannone

Rafael is developing his own 3D rotation implementation, here we are showing the "old way".

Compile with:
	zcc +msx -llib3d -startup=2 showlib3d.c   (MSXDOS)
	-or-
	zcc +msx -llib3d -create-app showlib3d.c  (to be run with the BASIC BLOAD cmd)


Use Joystick UP/DOWN to zoom in and out, FIRE to exit.

*/

//#include <oz.h>
#include "lib3d.h"
#include "graphics.h"
#include "stdio.h"
#include "stdlib.h"
#include "msx/line.h"

//#define TIMING


#define MX	(MODE2_WIDTH/2)
#define MY	(MODE2_HEIGHT/2)


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
static unsigned char c = 0;
static int i;
static int zf = 0;

//unsigned char* sbuffer;
//u_char* sbuffer[MODE2_MAX];
 
u_char* buf[MODE2_MAX];

surface_t surf;

//long heap;

int main(void)
{

//mallinit();
//sbrk(30000,MODE2_MAX+100);
// off-screen surface buffer
//sbuffer = (unsigned char*)malloc(MODE2_MAX);

	surf.data.ram = buf;

	// set screen to graphic mode
	set_color(15, 1, 1);
	set_mode(mode_2);
	fill(MODE2_ATTR, 0xF1, MODE2_MAX);

	while (!get_trigger(0)) {
		//if(ozkeyhit()) c = ozngetch();
		//if(getk()) c = fgetc_cons();

		c=st_dir[get_stick(0)]
		switch(c) {
			case st_down:
				zf -= 10;
				if(zf < -150) zf = -150;
				break;
			case st_up:
				zf += 10;
				if(zf > 800) zf = 800;
				break;
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
		memset(surf.data.ram, 0, MODE2_MAX);


		/* top face */
		surface_line(&surf,p[0].x + MX, p[0].y + MY, p[1].x + MX, p[1].y + MY);
		surface_line(&surf,p[1].x + MX, p[1].y + MY, p[2].x + MX, p[2].y + MY);
		surface_line(&surf,p[2].x + MX, p[2].y + MY, p[3].x + MX, p[3].y + MY);
		surface_line(&surf,p[3].x + MX, p[3].y + MY, p[0].x + MX, p[0].y + MY);

		/* bottom face */
		surface_line(&surf,p[4].x + MX, p[4].y + MY, p[5].x + MX, p[5].y + MY);
		surface_line(&surf,p[5].x + MX, p[5].y + MY, p[6].x + MX, p[6].y + MY);
		surface_line(&surf,p[6].x + MX, p[6].y + MY, p[7].x + MX, p[7].y + MY);
		surface_line(&surf,p[7].x + MX, p[7].y + MY, p[4].x + MX, p[4].y + MY);

		/* side faces */
		surface_line(&surf,p[0].x + MX, p[0].y + MY, p[4].x + MX, p[4].y + MY);
		surface_line(&surf,p[1].x + MX, p[1].y + MY, p[5].x + MX, p[5].y + MY);
		surface_line(&surf,p[2].x + MX, p[2].y + MY, p[6].x + MX, p[6].y + MY);
		surface_line(&surf,p[3].x + MX, p[3].y + MY, p[7].x + MX, p[7].y + MY);


		// show the off-screen buffer
		msx_vwrite_direct(surf.data.ram, 0, MODE2_MAX);
	}

	// go back to text mode
	set_mode(mode_0);
}

