
#include <rex/rex.h>
#include <rex/WHmath.h>
#include <float.h>

#define SIN2opi	        0.63661977
#define SINp0	 13578840.97877376
#define SINp1	 -4942908.10090284
#define SINp2	   440103.05353753
#define SINp3	   -13847.27249982
#define SINp4	      145.96884067
#define SINq0	  8644558.65292253
#define SINq1	   408179.22523433
#define SINq2	     9463.09610154
#define SINq3	      132.65349088

#define FMOD(a,b)  ((a) - floor( (a)/(b) ) * (b))

double sinus(double arg,int quad)
{
	double e, f;
	double ysq;
	double x,y;
	int k;
	double temp1, temp2;

	x = arg;
        if(x<0.0) {
		x = -x;
		quad += 2;
	}
	x = x*SIN2opi;	/*underflow?*/
        if(x>32764.0){
		y = FMOD(x,e);
		e += quad;
		FMOD(0.25*e,f);
                quad = e - 4.0*f;
	}else{
		k = x;
		y = x - k;
		quad = (quad + k) & 03;
	}
	if (quad & 01)
                y = 1.0-y;
	if(quad > 1)
		y = -y;

	ysq = y*y;
	temp1 = ((((SINp4*ysq+SINp3)*ysq+SINp2)*ysq+SINp1)*ysq+SINp0)*y;
	temp2 = ((((ysq+SINq3)*ysq+SINq2)*ysq+SINq1)*ysq+SINq0);
	return(temp1/temp2);
}
