/*
 *	CP/M GSX based graphics libraries
 *
 *	putc_gsx()
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: putc_gsx.c $
 */

#include <cpm.h>
#include <string.h>
//#include <graphics.h>
extern void __LIB__ putc_gsx(int chr);
extern void __LIB__ clg();
extern int gsx_maxx;
extern int gsx_maxy;


int putc_gsx_xc=0;
int putc_gsx_yc=0;

/* Clear Graphics */

void putc_gsx(int chr)
{
	if (chr==12) {
		putc_gsx_xc=0;
		putc_gsx_yc=0;
		clg();
		return(0);
	}

	if ((chr==10)||(chr==13)) {
		putc_gsx_xc=0;
		putc_gsx_yc += 10;
		return(0);
	}
		
	gios_put_text(gsx_xscale(putc_gsx_xc),gsx_yscale(putc_gsx_yc),&chr);
	
	putc_gsx_xc += 8;
	if (putc_gsx_xc>gsx_maxx) {
		putc_gsx_xc = 0;
		putc_gsx_yc += 10;
	}
}
