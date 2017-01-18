/*
	Minimal GUI functions, now included in X11.lib
	Stefano Bodrato, 26/3/2008
	
	$Id: win_move.c,v 1.1 2008-03-27 08:26:41 stefano Exp $
*/

#define _BUILDING_X
#include <gui.h>


// This is still broken
void win_move(int x, int y, struct gui_win win)
{
	char *winsave;
	
	winsave=malloc( 2+(win->width/8+1 + (win->flags & WIN_SHADOW)) * (win->height+(win->flags & WIN_SHADOW)) );
	sprintf(winsave, "%c%c",win->width+(win->flags & WIN_SHADOW),win->height+(win->flags & WIN_SHADOW) );
	
	getsprite(win->x,win->y,winsave);
	
	bkrestore(win->back);
	free(win->back);
	
	//win->x=x;  win->y=y;
	//win_open(win);
	//putsprite(x,y,winsave);
	free(winsave);
}
