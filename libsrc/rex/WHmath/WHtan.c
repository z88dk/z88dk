
#include <rex/rex.h>
#include <rex/WHmath.h>

double WHtan(double arg)
{ /* memory is more important than speed here! */
	return(WHsin(arg)/WHcos(arg));
}
