
#include <rex/rex.h>

/************************************************************************/
/*                      Ellipse drawing routine				*/
/*	written by Waleed Hasan						*/
/************************************************************************/
DsEllipse(xc, yc, a0, b0) int xc, yc, a0, b0;
{
 	int x=0,y=b0;

 	long a=a0,b=b0;

	long asq=a*a,tasq=asq << 1;
 	long bsq=b*b,tbsq=bsq << 1;

 	long d,dx,dy;

 	d=bsq-asq*b+asq >> 2;
 	dx=0;dy=tasq*b;

 	while(dx<dy)
	{
		Set4Pixels(x,y,xc,yc,0);
		if(d>0L) {y--;dy-=tasq;d-=dy;}
		x++;dx+=tbsq;d+=bsq+dx;
	}
 	d+=(3L*(asq-bsq)>>1-(dx+dy))>>1;

 	while(y>=0)
	{
        	Set4Pixels(x,y,xc,yc,0);
	 	if(d<0L) {x++;dx+=tbsq;d+=dx;}
		y--;dy-=tasq;d+=asq-dy;
	}
}
