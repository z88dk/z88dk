
#include <rex/rex.h>
#include <rex/WHmath.h>

#define sq2p1          2.41421356
#define sq2m1          0.41421356
#define pio2           1.57079633
#define pio4           0.78539816

/*
	satan reduces its argument (known to be positive)
	to the range [0,0.414...] and calls xatan.
*/

double satan(double arg)
{
	

	if(arg < sq2m1)
		return(xatan(arg));
	else if(arg > sq2p1)
		return(pio2 - xatan(1.0/arg));
	else
		return(pio4 + xatan((arg-1.0)/(arg+1.0)));
}
