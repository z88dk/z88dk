/* gui.h - simple GUI functions */

#ifndef __GUI_H__
#define __GUI_H__

#include "gui.h"
#include "malloc.h"
#include "stdio.h"
#include "graphics.h"

#ifdef ALTGUI
#include "games.h"
#endif

#define WIN_BORDER	1
#define WIN_LITE_BORDER	2
#define WIN_SHADOW	4

#define win_border	WIN_BORDER
#define win_lite_border	WIN_LITE_BORDER
#define win_shadow	WIN_SHADOW


struct gui_win {
        char    *back;
        char    x;
        char    y;
        char    width;
        char    height;
        char    flags;
};



#ifdef ALTGUI

	char topleft[] = 
		{ 4,4,
			0x30,
			0x40,
			0x80,
			0x80
		};
	
	char topleft_mask[] = 
		{ 4,4,
			0x30,
			0x70,
			0xF0,
			0xF0
		};
	
	char topright[] = 
		{ 4,4,
			0xC0,
			0x20,
			0x10,
			0x10
		};
	
	char topright_mask[] = 
		{ 4,4,
			0xC0,
			0xE0,
			0xF0,
			0xF0
		};
	
	char bottomleft[] = 
		{ 4,4,
			0x80,
			0x80,
			0x40,
			0x30
		};
	
	char bottomleft_mask[] = 
		{ 4,4,
			0xF0,
			0xF0,
			0x70,
			0x30
		};
	
	char bottomright[] = 
		{ 4,4,
			0x10,
			0x10,
			0x20,
			0xC0
		};
	
	char bottomright_mask[] = 
		{ 4,4,
			0xF0,
			0xF0,
			0xE0,
			0xC0
		};

#endif


win_open(struct gui_win win)
{
int x;

win->back=malloc( 4+(win->width/8+1 + (win->flags & WIN_SHADOW)) * (win->height+(win->flags & WIN_SHADOW)) );
sprintf(win->back, "%c%c",win->width+(win->flags & WIN_SHADOW),win->height+(win->flags & WIN_SHADOW) );
bksave(win->x,win->y,win->back);


#ifdef ALTGUI
	
	if ((win->flags & WIN_SHADOW) > 0)
		  {
			putsprite(spr_or,win->x+win->width-2,win->y+5,topright_mask);
			putsprite(spr_or,win->x+win->width-2,win->y+win->height-2,bottomright_mask);
			putsprite(spr_or,win->x+5,win->y+win->height-2,bottomleft_mask);
	    		
	    		for (x=-1; x<4; x++)
			{
				//horizontal shadow
				draw(win->x+9,win->y+win->height-1+x,win->x+win->width-3,win->y+win->height-1+x);
				//vertical shadow
				draw(win->x+win->width-1+x,win->y+9,win->x+win->width-1+x,win->y+win->height-3);
			}
		  }

	clga(win->x, win->y+5, win->width, win->height-10);
	clga(win->x+5, win->y, win->width-10, win->height);
	
	putsprite(spr_mask,win->x+1,win->y+1,topleft_mask);
	putsprite(spr_or,win->x+1,win->y+1,topleft);
	
	putsprite(spr_mask,win->x+win->width-5,win->y+1,topright_mask);
	putsprite(spr_or,win->x+win->width-5,win->y+1,topright);
	
	putsprite(spr_mask,win->x+1,win->y+win->height-5,bottomleft_mask);
	putsprite(spr_or,win->x+1,win->y+win->height-5,bottomleft);
	
	putsprite(spr_mask,win->x+win->width-5,win->y+win->height-5,bottomright_mask);
	putsprite(spr_or,win->x+win->width-5,win->y+win->height-5,bottomright);

	draw(win->x+5,win->y,win->x+win->width-6,win->y);
	draw(win->x+5,win->y+win->height-1,win->x+win->width-6,win->y+win->height-1);
	draw(win->x,win->y+5,win->x,win->y+win->height-6);
	draw(win->x+win->width-1,win->y+5,win->x+win->width-1,win->y+win->height-6);

	  //xorborder(win->x, win->y, win->width, win->height);

	//draw(win->x,win->y+5,win->x,win->y-10);
	//draw(win->x,win->y+5,win->x,win->y-10);

#else

	if ((win->flags & WIN_SHADOW) > 0)
	  {
	    for (x=1; x<4; x++)
	  	drawb (win->x+4,win->y+4,win->width-x,win->height-x);
	  }
	  
	  clga(win->x, win->y, win->width, win->height);
	
	if ((win->flags & WIN_BORDER) > 0)
	  drawb(win->x, win->y, win->width, win->height);
	
	if ((win->flags & WIN_LITE_BORDER) > 0)
	  xorborder(win->x, win->y, win->width, win->height);

#endif

}


win_close(struct gui_win win)
{
  bkrestore(win->back);
  free(win->back);
}


// This is still broken
win_move(int x, int y, struct gui_win win)
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

#endif
