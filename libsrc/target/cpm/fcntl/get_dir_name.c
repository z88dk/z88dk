/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: get_dir_name.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>

char tempdirname[] = "USER_0";

int get_dir_name()
{
	tempdirname[5]='0'+getuid();
	return tempdirname;
}
