/*
 *	tape_status()
 *
 *	SW controlled tape recorder
 *	on the Sharp X1
 *
 *	stefano, 2018
 *	
 * --------
 * $Id: tape_status.c $
 */

#include <arch/x1.h>


/*
 * Sense tape recorder status
 */


extern void tape_status(int command)
{
	subcpu_command(SUBCPU_TAPE_SENSOR);
	return(subcpu_get());
}

