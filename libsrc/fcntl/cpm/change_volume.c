/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: change_volume.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>

int change_volume(int driveno)
{
	return (bdos(CPM_LGIN,driveno));
}
