
#include <stdio.h>
#include <math.h>
#include <graphics.h>

#define iterates 101

float r,r1,r2,i,i1,i2,sr,si;
float a,b,d,d1;
float x0,y0,ux,uy;
float zr,zi;
float eps;
int n;
float xmax,ymax;

void main()
{

 	clg();

	xmax=(float)getmaxx();
	ymax=(float)getmaxy();
	
	r1=-1.6;  r2=1.6;
	i1=-1.2;  i2=1.2;
	sr=0.10004;
	si=-1.14545;
	
	ux=xmax/(r2-r1);
	uy=ymax/(i2-i1);
	
	x0=-r1*ux;
	y0=-i1*uy;
	
	//eps=exp(-6.0*log(10.0));
	eps=0.000001;

   // Remove to avoid the simmetry speedup trick
   //r2/=4.0;
	
	r=r1;
	do {
		i=i1;
		do {
			a=r; b=i;
			d=0.0; d1=1.0;
			n=0;
			
			do {
				d1=d;
				
				zr=(a*a)-(b*b)+sr;
				zi=(2.0*a*b)+si;
				a=zr; b=zi;
				d=(a*a)+(b*b);
			} while ((d<4.0) && (n++<=iterates) && (fabs(d-d1)>eps));
			
			if (d>4) {
				if (!(n&1)){
				  plot ((int)(x0+r*ux),(int)(y0-i*uy));
				  // Remove to avoid the simmetry speedup trick
				  plot (xmax-(int)(x0+r*ux),ymax-(int)(y0-i*uy));
				}
			}
			i=i+(1.0/uy);
		} while (i<i2);
		r=r+(1.0/ux);
   // change to avoid the simmetry speedup trick
   } while (r<=0.0);
	//} while (r<r2);
}

