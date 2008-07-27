/* Horrendous hack to get halfpi out */


#include <float.h>
#include <math.h>

extern double __LIB__ halfpi();


double halfpi()
{
	return ( pi() / 2. );
}
