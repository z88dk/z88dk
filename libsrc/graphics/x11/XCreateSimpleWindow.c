/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XCreateSimpleWindow.c,v 1.1 2014-04-16 06:16:31 stefano Exp $
*/

#define ALTGUI

#define _BUILDING_X
#include <X11/Xlib.h>

#include <graphics.h>

#define TITLE_AREA 9

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



struct _XWIN mywin;

Window XCreateSimpleWindow(Display *display, Window rootwindow, int x, int y, int width, int height, int border_width, int forecolor, int backcolor) {

	width = width + 4;
	height = height + TITLE_AREA + 4;
	
/*
win->back=malloc( 4+(width/8+1 + (win->flags & WIN_SHADOW)) * (height+(win->flags & WIN_SHADOW)) );
sprintf(win->back, "%c%c",width+(win->flags & WIN_SHADOW),height+(win->flags & WIN_SHADOW) );
bksave(x,y,win->back);
*/

#ifdef ALTGUI

	if (border_width > 3)
	//if ((win->flags & WIN_SHADOW) > 0)
		  {
			putsprite(spr_or,x+width-2,y+5,topright_mask);
			putsprite(spr_or,x+width-2,y+height-2,bottomright_mask);
			putsprite(spr_or,x+5,y+height-2,bottomleft_mask);
	    		
	    		for (_X_int1=-1; _X_int1<4; _X_int1++)
			{
				//horizontal shadow
				draw(x+9,y+height-1+_X_int1,x+width-3,y+height-1+_X_int1);
				//vertical shadow
				draw(x+width-1+_X_int1,y+9,x+width-1+_X_int1,y+height-3);
			}
		  }

	clga(x, y+5, width, height-10);
	clga(x+5, y, width-10, height);
	
	putsprite(spr_mask,x+1,y+1,topleft_mask);
	putsprite(spr_or,x+1,y+1,topleft);
	
	putsprite(spr_mask,x+width-5,y+1,topright_mask);
	putsprite(spr_or,x+width-5,y+1,topright);
	
	putsprite(spr_mask,x+1,y+height-5,bottomleft_mask);
	putsprite(spr_or,x+1,y+height-5,bottomleft);
	
	putsprite(spr_mask,x+width-5,y+height-5,bottomright_mask);
	putsprite(spr_or,x+width-5,y+height-5,bottomright);

	draw(x+5,y,x+width-6,y);
	draw(x+5,y+height-1,x+width-6,y+height-1);
	draw(x,y+5,x,y+height-6);
	draw(x+width-1,y+5,x+width-1,y+height-6);

	  //xorborder(x, y, width, height);

	//draw(x,y+5,x,y-10);
	//draw(x,y+5,x,y-10);
#else

	if (border_width >= 1)
	    mywin->full_width = width;

	if (border_width > 3)
	//if ((win->flags & WIN_SHADOW) > 0)
	  {
	    mywin->full_width = width + 4;
	    for (_X_int1=1; _X_int1<4; _X_int1++)
	  	drawb (x+4,y+4,width-_X_int1,height-_X_int1);
	  }
	  
	  clga(x, y, width, height);
	
	//if ((win->flags & WIN_BORDER) > 0)
	if (border_width >= 1)
	  drawb(x, y, width, height);
	
	//if (border_width = 1)
	//  xorborder(x, y, width, height);

#endif
	//_X_int1=y + mywin->y_offset + 10;
	draw(x, y+TITLE_AREA, x + width, y+TITLE_AREA);

	mywin->x = x;
	mywin->y = y;
	mywin->width = width-4;
	mywin->height = height-TITLE_AREA-4;
	mywin->a_x = x+2;
	mywin->a_y = y+TITLE_AREA+2;
	mywin->full_height = height;

	
	return mywin;

}
