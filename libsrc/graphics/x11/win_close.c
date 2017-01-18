/*
	Minimal GUI functions, now included in X11.lib
	Stefano Bodrato, 26/3/2008
	
	$Id: win_close.c,v 1.1 2008-03-27 08:26:40 stefano Exp $
*/

#define _BUILDING_X
#include <gui.h>


void win_close(struct gui_win win)
{
  bkrestore(win->back);
  free(win->back);
}
