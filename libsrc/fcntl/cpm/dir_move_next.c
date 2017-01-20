/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: dir_move_next.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>

int dir_move_next()
{
	return (fc_dirpos=bdos(CPM_FNXT,fc_dir));
}
