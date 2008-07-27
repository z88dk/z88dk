/* Convert a floating point number into a buffer */

#include <stdio.h>
#include <math.h>
#include <float.h>
#include <stdlib.h>

void ftoa(double number, int prec, char *str)
{
        float fix_number,realpart_number;

	/* Weird things happen above a precision of 4... */
	if ( prec > 4 ) {
		prec = 4;
	}

        fix_number=floor(number);
        realpart_number=(number-fix_number)*pow10(prec);
        sprintf(str,"%d.%d",(int)fix_number,abs(realpart_number));
}

