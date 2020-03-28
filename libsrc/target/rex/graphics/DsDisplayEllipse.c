
/* 
  (partial) ASM ellipse drawing routine
			By Waleed Hasan - 11Jan2002

  This is not in full assembly, but calling the asm set_4_pix
  saved some bytes & made the ellipse drawing faster

  $Id: DsDisplayEllipse.c,v 1.3 2015-01-21 17:51:52 stefano Exp $
 */
 
#asm
	EXTERN	ellset4pix
	
.DsDisplayEllipse
#endasm
 
void DsDisplayEllipse(xc, yc, a0, b0)
int xc, yc, a0, b0;
{
 	long a=a0,b=b0;
 	int x=0,y=b0;
	long asq=a*a,tasq=asq<<1;
 	long bsq=b*b,tbsq=bsq<<1;

 	long d=bsq-asq*b+asq>>2,dx=0,dy=tasq*b;

 	while(dx<dy)
	{
#asm
	call	ellset4pix
#endasm
		if(d>0L) {y--;dy-=tasq;d-=dy;}
		x++;dx+=tbsq;d+=bsq+dx;
	}
 	d+=(3L*(asq-bsq)>>1-(dx+dy))>>1;

 	while(y>=0)
	{
#asm
	call	ellset4pix
#endasm
	 	if(d<0L) {x++;dx+=tbsq;d+=dx;}
		y--;dy-=tasq;d+=asq-dy;
	}
}
