/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *  07/2019: Workaround to stabilize dir_move_next when file operations happen.
 *  08/2019: Dealing with the bdos() function in a correct way
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
	parsefcb(&fc_dir,"*.*");
	fc_dirpos=bdos(CPM_FFST,&fc_dir);
	fc_dirbuf[133]=0;
	return (fc_dirpos==-1?0x24:0);	// Not knowing what to pass for non-zero, let's simulate FLOS error code $24 (= Reached end of directory)
}
