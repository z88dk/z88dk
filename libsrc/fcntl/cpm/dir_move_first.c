/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: dir_move_first.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>

struct fcb *fc_dir;

char fc_dirpos;
char *fc_dirbuf

char buff[42];
char dirbuf[132];

int dir_move_first()
{
	fc_dirbuf=buff;
	bdos(CPM_SDMA,fc_dirbuf);
	fc_dir=buff;
	parsefcb(fc_dir,"*.*");
	return (fc_dirpos=bdos(CPM_FFST,fc_dir));
}
