/*
 *	CP/M GSX based graphics libraries
 *
 *	stencil_render(int stencil_vector[], unsigned char intensity)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: stencil_render.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ stencil_render(int stencil_vector[], unsigned char intensity) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;
extern int  __LIB__ getmaxy() __z88dk_fastcall;


void stencil_render(int stencil_vector[], unsigned char intensity)
{
	int y, sr_maxy;

	sr_maxy=getmaxy()+1;

	for (y=0;y<sr_maxy;y++) {

		if (stencil_vector[y]<stencil_vector[y+sr_maxy]) {
			
			gios_wmode(W_ERASE);
			gios_f_style(F_FULL);
			gios_draw(gsx_xscale(stencil_vector[y]),gsx_yscale(y),gsx_xscale(stencil_vector[y+sr_maxy]),gsx_yscale(y));

			gios_wmode(W_COMPLEMENT);
			gios_f_style(F_PATTERN);
			gios_f_index(11-intensity);
			gios_drawb(gsx_xscale(stencil_vector[y]),gsx_yscale(y),gsx_xscale(stencil_vector[y+sr_maxy]),gsx_yscale(y));


			gios_update();
		}

	}

	gios_wmode(W_REPLACE);
	gios_f_style(F_EMPTY);

}
