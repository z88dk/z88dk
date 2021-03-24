/*
 *	CP/M GSX based graphics libraries
 *
 *	clg()
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: clg.c $
 */

#include <cpm.h>
#include <string.h>
//#include <graphics.h>
extern void __LIB__ clg(void);
extern int gsx_maxx;
extern int gsx_maxy;
extern int gsx_xscale_factor;
extern int gsx_yscale_factor;

/* Clear Graphics */

void clg()
{
	gios_ctl.n_ptsin=0;
	gios_ctl.n_intin=10;
	bzero(gios_intin,20);
	//gios_intin[0]=device_id
	gios_intin[0]=gios_intin[2]=gios_intin[4]=gios_intin[6]=gios_intin[8]=gios_intin[9]=1;
	gios(GSX_OPEN);

	gsx_maxx=gios_intout[0];
	gsx_maxy=gios_intout[1];
	
	gsx_xscale_factor=32767/gsx_maxx;
	gsx_yscale_factor=32767/gsx_maxy;

	gios_l_style(1);
	gios_clg();
	
	gios_l_color(7);
}
