/*
 *	clock() function
 *
 *	Return the current time basically
 *	Typically used to find amount of CPU time
 *	used by a program.
 *
 *	ANSI allows any time at start of program so
 *	properly written programs should call this fn
 *	twice and take the difference
 *
 *	stefano, 11/2013
 *	
 * --------
 * $Id: clock.c,v 1.2 2013-11-13 20:46:42 stefano Exp $
 */

#include <time.h>
#include <x1.h>


/*
 * Get the current time
 */

unsigned int unbcd(unsigned int value) {
	return ( (value >> 4) * 10 + (value & 15) );
}

clock_t clock()
{
	subcpu_command(SUBCPU_GET_CLOCK);
	return( ((clock_t)unbcd(subcpu_get())*3600) + ((clock_t)unbcd(subcpu_get())*60) + (clock_t)unbcd(subcpu_get()) );
}

