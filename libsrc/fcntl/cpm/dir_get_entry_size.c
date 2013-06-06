/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: dir_get_entry_size.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>

unsigned char *szptr;

long dir_get_entry_size()
{
	bdos(CPM_CFS,fc_dirbuf + fc_dirpos * 32);
	
	szptr = (33 + fc_dirbuf + fc_dirpos * 32);
	return (((unsigned long)szptr[0] + 256L*(unsigned long)szptr[1] + 65536L*(unsigned long)(szptr[2]&7)) * 128L);
}
