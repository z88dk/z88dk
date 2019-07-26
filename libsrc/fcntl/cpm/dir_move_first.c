/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *  07/2019: Dirty workaround to stabilize dir_move_next when file operations happen.
 *
 *
 *  $Id: dir_move_first.c $
 */

#include <cpm.h>

struct fcb fc_dir;

char fc_dirpos;
char *fc_dirbuf;

char dirbuf[134];

int dir_move_first()
{
	fc_dirbuf=dirbuf;
	bdos(CPM_SDMA,fc_dirbuf);
	parsefcb(&fc_dir,"????????.???");
	dirbuf[133]=0;
	return (fc_dirpos=bdos(CPM_FFST,&fc_dir));
}
