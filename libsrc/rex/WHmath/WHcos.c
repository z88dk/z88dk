
#include <rex/rex.h>
#include <rex/WHmath.h>

double WHcos(double arg)
{
        if(arg<0.0)
		arg = -arg;
	return(sinus(arg, 1));
}
