
#include <rex/rex.h>

/************************************************************************/
/*                      Circle drawing routine                          */
/*	written by Waleed Hasan						*/
/************************************************************************/

DsCircle( xc, yc, r)int xc, yc, r;
{
 int x=0,y=r;
 int a=r>>1;

 for(;x<=y;)
	{
	 	Set4Pixels(x,y,xc,yc,1);
	 	x++;
	 	a-=x;
	 	if(a<0){a+=y;y--;}
	}
}
