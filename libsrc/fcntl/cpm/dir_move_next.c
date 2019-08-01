/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *  07/2019: Dirty workaround to stabilize dir_move_next when file operations happen.
 *
 *
 *  $Id: dir_move_next.c $
 */

#include <cpm.h>

int entry_count;
char current_entry;

int dir_move_next()
{
	current_entry=fc_dirbuf[133];
	dir_move_first();
	for (entry_count=0; entry_count<current_entry; entry_count++) bdos(CPM_FNXT,&fc_dir);
	fc_dirbuf[133]=current_entry+1;
	return (fc_dirpos=bdos(CPM_FNXT,&fc_dir));
}
