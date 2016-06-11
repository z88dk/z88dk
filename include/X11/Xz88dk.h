/* $Id: Xz88dk.h,v 1.2 2016-06-11 13:37:14 dom Exp $ */

#ifndef _XZ88DK_H_
#define _XZ88DK_H_

#include <sys/compiler.h>
#include <X11/Xlib.h>
//#include <graphics.h>
//#include <games.h>


//#include <stdio.h>


#ifdef _BUILDING_X

  extern int _x_proportional;
  extern int _y_proportional;
  extern char *_xchar_proportional;
  extern int _X_int1;
  extern int _X_int2;
  extern int _X_int3;

  extern int _x_must_expose;

#else

  int _x_proportional;
  int _y_proportional;
  char *_xchar_proportional;
  int _X_int1;
  int _X_int2;
  int _X_int3;

  int _x_must_expose=1;

#endif


/* Base X objects */

extern struct _XDisplay __LIB__ *XOpenDisplay(char *display_name);
extern void __LIB__ XCloseDisplay(struct _XDisplay *display);

extern int __LIB__ DefaultScreen(struct _XDisplay *display);

extern int __LIB__ RootWindow(struct _XDisplay *display,int screen) __SMALLCDECL;

extern Window __LIB__ XCreateSimpleWindow(struct _XDisplay *display, Window rootwindow, int x, int y, int width, int height, int border_width, int forecolor, int backcolor) __SMALLCDECL;
extern int __LIB__ XDestroyWindow(struct _XDisplay *display, Window win) __SMALLCDECL;

extern struct GC __LIB__ *XCreateGC(struct _XDisplay *display, Window win, int valuemask, int values) __SMALLCDECL;
extern void __LIB__ XFreeGC(struct _XDisplay *display, struct _XGC gc) __SMALLCDECL;

/* Base X objects properties */
extern char __LIB__ *XDisplayName(char *display_name);
extern int __LIB__ DisplayWidth(struct _XDisplay *display,int screen) __SMALLCDECL;
extern int __LIB__ DisplayHeight(struct _XDisplay *display,int screen) __SMALLCDECL;
extern int __LIB__ DefaultDepth(struct _XDisplay *display,int screen) __SMALLCDECL;
extern int __LIB__ BlackPixel(struct _XDisplay *display, int screen) __SMALLCDECL;
extern int __LIB__ WhitePixel(struct _XDisplay *display, int screen) __SMALLCDECL;

extern void __LIB__ XMapWindow(struct _XDisplay *display, Window win) __SMALLCDECL;

extern void __LIB__ XSetForeground(struct _XDisplay *display, struct _XGC gc, int color) __SMALLCDECL;
extern void __LIB__ XSetLineAttributes(struct _XDisplay *display, struct _XGC gc, int line_width, int line_style, int cap_style, int join_style) __SMALLCDECL;
extern void __LIB__ XSetDashes(struct _XDisplay *display, struct _XGC gc, int dash_offset, int dash_list, int list_length) __SMALLCDECL;
extern void __LIB__ XSetStandardProperties(struct _XDisplay *display, Window win, char *window_name, char *icon_name, char *icon_pixmap, char *argv, int argc, int size_hints) __SMALLCDECL;


/* Events */

extern void __LIB__ XSelectInput(struct _XDisplay *display, Window win, int event_mask) __SMALLCDECL;
extern void __LIB__ XNextEvent(struct _XDisplay *display, int *event) __SMALLCDECL;
extern Bool __LIB__ XCheckWindowEvent(struct _XDisplay *display, Window win, int event_mask, int event) __SMALLCDECL;
extern int __LIB__ XCheckTypedEvent(struct _XDisplay *display, int type, int event) __SMALLCDECL;
extern int __LIB__ XFlush(struct _XDisplay *display);


/* Text handling */

extern int __LIB__ XTextWidth(struct _XFontStruct *font_struct, char *string, int count) __SMALLCDECL;
extern struct _XFontStruct __LIB__ *XLoadQueryFont(struct _XDisplay *display, char *fontname) __SMALLCDECL;
extern void __LIB__ XDrawString(struct _XDisplay *display, Window win, struct _XGC gc, int x, int y, char *text, int textlen) __SMALLCDECL;

extern void  __LIB__ XUnloadFont(struct _XDisplay *display, Font font) __SMALLCDECL;
extern void  __LIB__ XSetFont(struct _XDisplay *display, struct _XGC gc, Font font) __SMALLCDECL;


/* Pictures handling */

extern Pixmap __LIB__ XCreateBitmapFromData(struct _XDisplay *display, Window win, char *bits, int width, int height) __SMALLCDECL;


/* Graphics drawing functions */

// It could even work, but the window positioning offset !
//#define XDrawRectangle drawb
extern void __LIB__ XDrawRectangle(struct _XDisplay *display, Window win, struct _XGC gc, int x, int y, int width, int height) __SMALLCDECL;
extern void __LIB__ XDrawPoint(struct _XDisplay *display, Window win, struct _XGC gc, int x, int y) __SMALLCDECL;
extern void __LIB__ XDrawLine(struct _XDisplay *display, Window win, struct _XGC gc, int x1, int y1, int x2, int y2) __SMALLCDECL;
extern void __LIB__ XClearWindow(struct _XDisplay *display, Window win, struct _XGC gc, int x, int y, int width, int height, Bool Exposures) __SMALLCDECL;


/*  Internal declarations  */

extern char __LIB__ *_xfindchar(char c, char *font) __SMALLCDECL;
extern void __LIB__ _xfputc (char c, char *font, Bool bold) __SMALLCDECL;



/*  Internal structures  */

struct _XWIN {
	int	x;
	int	y;
	int	width;		// Drawable area width
	int	height;		// Drawable area height
	int	a_x;		// area x pos
	int	a_y;		// area y pos
	int	full_width;
	int	full_height;
	char	*title;
        char    *icon;
        char    *background;
};




#endif /* _XZ88DK_H_ */
