/*
 *	tape()
 *
 *	SW controlled tape recorder
 *	on the Sharp X1
 *
 *	stefano, 2018
 *	
 * --------
 * $Id: tape.c $
 */

#include <x1.h>


/*
 * Send command to tape recorder
 */


extern int __FASTCALL__ tape(int command)
{
	subcpu_command(SUBCPU_TAPE_CONTROL);
	subcpu_set(command);
}

