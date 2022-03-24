
/*
 *      Ultra-simplified emulation of the CC65 graphics library 
 *
 *	$Id: tgi.h $
 */

#ifndef __TGI_H__
#define __TGI_H__

#include <graphics.h>
#include <lib3d.h>
#include <sys/ioctl.h>                // required for switching the screen mode
#include <features.h>


/* Foo stuff, better to remove the unnecessary code while porting */
#define tgi_load_driver(a)  {}
#define tgi_unload() {}
#define tgi_install(a) {}
#define tgi_uninstall() {}
#define tgi_geterror() 0
#define TGI_ERR_OK 0


// Define screen mode number for graphics mode
#if defined(__LASER500__) || defined(__MULTI8__) || defined(__BEE__) || defined(__CPC__)
        #define MODE_SECONDSCREEN 2
#elif defined (__EINSTEIN__)
        #define MODE_SECONDSCREEN 10
#elif defined (__TS2068__)
        #define MODE_SECONDSCREEN 6
#else
        #define MODE_SECONDSCREEN 1        // Standard value if not defined otherwise
#endif


int TGI_MODE = MODE_SECONDSCREEN;
                        

// Enter in graphics mode
#define tgi_init() console_ioctl(IOCTL_GENCON_SET_MODE, &TGI_MODE);
#define tgi_clear() clg()

// Go back to text mode
#define tgi_done() fputc_cons(12)

/* Get MAX x and y coordinates */
#define tgi_getmaxx() getmaxx()
#define tgi_getmaxy() getmaxy()

#define tgi_getxres() getmaxx()+1
#define tgi_getyres() getmaxy()+1

#define tgi_getpixel(a,b)           point(a,b)
#define tgi_setpixel(a,b)           plot(a,b)
#define tgi_gotoxy(a,b)             setpos(a,b)
#define tgi_line(a,b,c,d)           draw(a,b,c,d)
#define tgi_lineto(a,b)             drawto(a,b)
#define tgi_circle(a,b,c)           circle(a,b,c,1)
#define tgi_bar(a,b,c,d)            fillb(a,b,c,d)
#define tgi_arc(x,y,rx,ry,sa,ea)    ellipse(x,y,sa,ea,rx,ry)


#endif
