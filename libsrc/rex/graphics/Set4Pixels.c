
#include <rex/rex.h>

#define PIX(xx,yy) DsDisplayPointSet(xx,yy,1)

Set4Pixels(x, y, xc, yc, Do8) int x, y, xc, yc, Do8;
{
	PIX(xc + x, yc + y);
	PIX(xc - x, yc + y);
 	PIX(xc + x, yc - y);
 	PIX(xc - x, yc - y);
 	if(Do8)
	{
	 	PIX(xc + y, yc + x);
	 	PIX(xc - y, yc + x);
	 	PIX(xc + y, yc - x);
	 	PIX(xc - y, yc - x);
	}
}
