#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>

//#pragma output hrgpage=36096

#include <stdio.h>
#include "icon"
  
#define BITMAPDEPTH 1
  
Display *display;
int screen;

/* values for window_size in main */
#define SMALL 1
#define OK 0

void main(argc, argv)
int argc;
char **argv;
{
Window win;
unsigned int width, height, display_width, display_height;
int	x = 0, y = 0;
unsigned int border_width = 4;
char *window_name = "Basic Window Program";
char *icon_name = "basicwin";
Pixmap icon_pixmap;
XSizeHints size_hints;
XEvent report;
GC gc;
XFontStruct *font_info;
char *display_name = NULL;
int window_size = 0;

if ((display=XOpenDisplay(display_name)) == NULL)
  {
  fprintf(stderr,"basicwin: cannot connect to X server %s\n",
	  XDisplayName(display_name));
  exit(-1);
  }

screen = DefaultScreen(display);

display_width = DisplayWidth(display,screen);
display_height = DisplayHeight(display,screen);


width = display_width-16;
height = display_height-16;

//width = 230;
//height = 160;

win = XCreateSimpleWindow(display, RootWindow(display,screen),
			  x, y, width, height, border_width,
			  BlackPixel(display,screen),
			  WhitePixel(display,screen));

icon_pixmap = XCreateBitmapFromData(display, win, icon_bits,
				    icon_width, icon_height);

size_hints.flags = PPosition | PSize | PMinSize;
size_hints.x = x;
size_hints.y = y;
size_hints.width = width;
size_hints.height = height;
size_hints.min_width = 350;
size_hints.min_height = 250;

XSetStandardProperties(display, win, window_name, icon_name, icon_pixmap,
		       argv, argc, &size_hints);

XSelectInput(display, win, ExposureMask |
	     KeyPressMask |
	     ButtonPressMask |
	     StructureNotifyMask);

load_font(&font_info);

get_GC(win, &gc, font_info);

XMapWindow(display, win);

while (1)
  {
  XNextEvent(display, &report);
  switch (report.type)
    {
     case Expose:
    
    while (XCheckTypedEvent(display, Expose, &report))
      ;
    if (window_size == SMALL)
      TooSmall(win, gc, font_info);
    else
      {
      draw_text(win, gc, font_info, width, height);
      draw_graphics(win, gc, width, height);
      }
    break;
    
     case ConfigureNotify:
    
    width = report.xconfigure.width;
    height = report.xconfigure.height;
    if (width < size_hints.min_width || height < size_hints.min_height)
      window_size = SMALL;
    else
      window_size = OK;
    break;
    
     case ButtonPress:
     case KeyPress:
    
    XUnloadFont(display, font_info->fid);
    XFreeGC(display, gc);
    XCloseDisplay(display);
    exit(1);
    break;
    
     default:
    
    break;
    }
  }
}

get_GC(win, gc, font_info)
Window win;
GC *gc;
XFontStruct *font_info;
{
unsigned long valuemask = 0;
XGCValues values;
unsigned int line_width = 1;
int line_style = LineSolid; /*LineOnOffDash;*/
int cap_style = CapButt;
int join_style = JoinMiter;
int dash_offset = 0;
static char dash_list[] = {20, 40};
int list_length = sizeof(dash_list);

*gc = XCreateGC(display, win, valuemask, &values);

XSetFont(display, *gc, font_info->fid);

XSetForeground(display, *gc, BlackPixel(display,screen));

XSetLineAttributes(display, *gc, line_width, line_style, cap_style, join_style);

XSetDashes(display, *gc, dash_offset, dash_list, list_length);
}


load_font(font_info)
XFontStruct **font_info;
{
char *fontname = "9x15";

if ((*font_info=XLoadQueryFont(display,fontname)) == NULL)
  {
  printf("stderr, basicwin: cannot open 9x15 font\n");
  exit(-1);
  }
}

draw_text(win, gc, font_info, win_width, win_height)
Window win;
GC gc;
XFontStruct *font_info;
unsigned int win_width, win_height;
{
int y = 20;
char *string1 = "Hi! I'm a window, who are you?";
char *string2 = "To terminate program; Press any key";
char *string3 = "or button while in this window.";
char *string4 = "Screen Dimensions:";
int len1, len2, len3, len4;
int width1, width2, width3;
char cd_height[50], cd_width[50], cd_depth[50];
int font_height;
int y_offset, x_offset;

len1 = strlen(string1);
len2 = strlen(string2);
len3 = strlen(string3);

width1 = XTextWidth(font_info, string1, len1);
width2 = XTextWidth(font_info, string2, len2);
width3 = XTextWidth(font_info, string3, len3);

XDrawString(display, win, gc, (win_width-width1)/2, y, string1, len1);
XDrawString(display, win, gc, (win_width-width2)/2, (int)(win_height-35), string2, len2);
XDrawString(display, win, gc, (win_width-width3)/2, (int)(win_height-15), string3, len3);

sprintf(cd_height,"Height - %d pixels", DisplayHeight(display,screen));
sprintf(cd_width,"Width - %d pixels", DisplayWidth(display,screen));
sprintf(cd_depth,"Depth - %d plane(s)", DefaultDepth(display,screen));

len4 = strlen(string4);
len1 = strlen(cd_height);
len2 = strlen(cd_width);
len3 = strlen(cd_depth);

font_height = font_info->max_bounds.ascent + 
  font_info->max_bounds.descent;

//printf("Font height: %u - Win height: %u\n",font_height, win_height);

y_offset = win_height/2 - font_height - font_info->max_bounds.descent;
x_offset = (int) win_width/4;

XDrawString(display, win, gc, x_offset, y_offset, string4, len4);
y_offset += font_height;

XDrawString(display, win, gc, x_offset, y_offset, cd_height, len1);
y_offset += font_height;

XDrawString(display, win, gc, x_offset, y_offset, cd_width, len2);
y_offset += font_height;

XDrawString(display, win, gc, x_offset, y_offset, cd_depth, len3);
}


draw_graphics(win, gc, window_width, window_height)
Window win;
GC gc;
unsigned int window_width, window_height;
{
int x,y;
unsigned int width, height;

height = window_height/2;
width = 3 * window_width/4;

x = window_width/2 - width/2;
y = window_height/2 - height/2;

XDrawRectangle(display, win, gc, x, y, width, height);
}

TooSmall(win, gc, font_info)
Window win;
GC gc;
XFontStruct *font_info;
{
char *string1 = "Too Small";
int x,y;

y = font_info->max_bounds.ascent + 2;
x = 2;

XDrawString(display, win, gc, x, y, string1, strlen(string1));
}

