/*=========================================================================

GFX EXAMPLE CODE - #10b
	"shaded 3D blocks"

Copyright (C) 2004  Rafael de Oliveira Jannone
Copyright (C) 2009  Stefano Bodrato

This example's source code is Public Domain.

WARNING: The author makes no guarantees and holds no responsibility for 
any damage, injury or loss that may result from the use of this source 
code. USE IT AT YOUR OWN RISK.

Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284

=========================================================================*/

#include <msx/defs.h>
#include <stdlib.h>
#include <msx/line.h>


	unsigned char polyarea[MODE2_HEIGHT*2];
	//unsigned char high[MODE2_HEIGHT];
//u_char *buf;

	unsigned char buf[MODE2_MAX];

main() {
	int c, l;
	unsigned char i;
	surface_t surf;

	//buf = (u_char*)malloc(MODE2_MAX);
	
	surf.data.ram = buf;

	set_color(15, 1, 1);
	set_mode(mode_2);
	fill(MODE2_ATTR, 0x31, MODE2_MAX);

	c = 0;
	//i = 0;

	// paint polygon
	for (;;) {	
		memset(buf, 0, MODE2_MAX);	// yeah... crap
		
		//memset(low, 64, MODE2_HEIGHT << 1);	// yeah... crap
		//memset(low, 255, MODE2_HEIGHT);	// yeah... crap
		//memset(high, 0, MODE2_HEIGHT << 1);	// yeah... crap
		//memset(high, 0, MODE2_HEIGHT);	// yeah... crap
/*
		for (i=6;i<20;i++) {
			polyarea_init(polyarea);
			polyarea_add_circle(128, 170 - i*4, 40-i*2 ,1, polyarea);
			surface_polyarea_render(&surf, polyarea, i/c);
		}
*/			

		for (i=4;i>0;i--) {
			// fake light source
			polyarea_init(polyarea);
			polyarea_add_circle(80+c*3-i, 42+i, i*3+5, 1, polyarea);
			surface_polyarea_render(&surf, polyarea, 14-(i*2));
		}

		for (i=11;i>0;i--) {
			polyarea_init(polyarea);
			polyarea_add_circle(128+(11-i), 150 - i, i*3 ,1, polyarea);
			polyarea_add_side(128-i*3+(11-i), 150 - i, 128, 30+i, polyarea);
			polyarea_add_side(128+i*3+(11-i), 150 - i, 128, 30+i, polyarea);
			surface_polyarea_render(&surf, polyarea, 6*(12-i)/(c+1));
		}

		// calculate polygon
		//calculate_side
		//polyarea_add_side(128 + c, c + 20, 40, 180 - c, polyarea);
		//polyarea_add_side(128 + c, c + 20, 255 - c, 96, polyarea);
		//polyarea_add_side(255 - c, 96, 40, 180 - c, polyarea);
		c = (c+1) & 15;
		//i = (c + 15) >> 4;
		//i = (c + 15) /6-2;
		//i++;

		//for (l = 20; l < 180; l++) {
			//surface_hline(&surf, low[l], l, high[l], DITHER(i, l));
			//surface_hline_dither(&surf, low[l], l, high[l], i);
			//surface_hline_dither(&surf, polyarea[l], l, polyarea[l+MODE2_HEIGHT], i);
		//}
		
		//polyarea_add_circle(64 + c*2, 64 + c/2, 60-c ,1, polyarea);

		//surface_polyarea_render(&surf, polyarea, i);

		msx_vwrite_direct(surf.data.ram, 0, MODE2_MAX);
		if (get_trigger(0))
			break;
	}

	set_mode(mode_0);
}
