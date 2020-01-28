/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: get_current_volume.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>

int get_current_volume()
{
	return (bdos(CPM_IDRV,0));
}
