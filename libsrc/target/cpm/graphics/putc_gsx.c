/*
 *	CP/M GSX based graphics libraries
 *
 *	putc_gsx()
 *  use with "-pragma-redirect=fputc_cons=_putc_gsx"
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
int putc_gsx_yc=8;

/* Clear Graphics */

void putc_gsx(int chr)
{
	if (chr==12) {
		putc_gsx_xc=0;
		putc_gsx_yc=8;
		clg();
		return(0);
	}

	// CR
	if ((chr==10)||(chr==13)) {
		putc_gsx_xc=0;
		putc_gsx_yc += 9;
		return(0);
	}

	// Backspace
	if (chr==8) {
		if (putc_gsx_xc >= 0) putc_gsx_xc-=8;
		gios_put_text(gsx_xscale(putc_gsx_xc),gsx_yscale(putc_gsx_yc)," ");
		return(0);
	}
		
	gios_put_text(gsx_xscale(putc_gsx_xc),gsx_yscale(putc_gsx_yc),&chr);
	
	putc_gsx_xc += 8;
	if (putc_gsx_xc>gsx_maxx) {
		putc_gsx_xc = 0;
		putc_gsx_yc += 9;
	}
}
