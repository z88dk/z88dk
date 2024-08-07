/*
 *      Small C+ Library
 *
 *  bgi.h - Turbo C compatibility
 * 
 *	Minimal implementation of the Borland BGI style functions
 *	plus few more TC peculiarities.
 *
 *	To enabe the BGI emulation, just replace the existing <graphics.h> declaration
 *	with <bgi.h> in your TURBO C program
 *  Some of the features (such as the proportional text) require to be initialized, do not remove "initgraph".
 * 
 *  Good value for gfxscale (256x192):  -DGFXSCALEX=2/5 and -DGFXSCALEY=2/5   (try also 1/3)
 *  TS2068 HR (512x192):  -DGFXSCALEX=4/5 -DGFXSCALEY=2/5
 * 
 * 
 * Build examples:
 *  zcc +zx -lndos -DGFXSCALEX=2/5 -lm -create-app myprogram.c
 *  zcc +ts2068 -DGFXSCALEX=4/5 -DGFXSCALEY=2/5 -create-app -lm -pragma-define:CLIB_DEFAULT_SCREEN_MODE=6  myprogram.c
 *
 *      stefano - 22/10/2012
 *
 *	$Id: bgi.h $
 */

#ifndef __BGI_H__
#define __BGI_H__

/* Let's make sure <graphics.h> is loaded */
#include <graphics.h>
#include <lib3d.h>
#include <conio.h>
#include <X11/XLib.h>

//#pragma output nogfxglobals
unsigned char bgi_stencil[256*4];
int bgi_fillstyle=11;
//int bgi_fillcolor;
//#define	setfillstyle(a,b) bgi_fillstyle=(a?12-a:0);printf("\033[%um",PCDOS_COLORS[b]+30)
#define	setfillstyle(a,b) bgi_fillstyle=(a?12-a:0)

// setcolor(a) printf("\033[%um",PCDOS_COLORS[a]+30)
#define setcolor(a) {}
#define setbkcolor(a) {}
#define setlinestyle(a,b,c) {}
#define getmacc(a) {}

enum horiz { LEFT_TEXT, CENTER_TEXT, RIGHT_TEXT };

enum vertical { BOTTOM_TEXT, VCENTER_TEXT, TOP_TEXT };

enum font_names { DEFAULT_FONT, TRIPLEX_FONT, SMALL_FONT, SANS_SERIF_FONT,
             GOTHIC_FONT, SCRIPT_FONT, SIMPLEX_FONT, TRIPLEX_SCR_FONT,
			 COMPLEX_FONT, EUROPEAN_FONT, BOLD_FONT };

enum line_styles { SOLID_LINE, DOTTED_LINE, CENTER_LINE, DASHED_LINE, USERBIT_LINE };

enum fill_styles { EMPTY_FILL, SOLID_FILL, LINE_FILL, LTSLASH_FILL, SLASH_FILL,
                   BKSLASH_FILL, LTBKSLASH_FILL, HATCH_FILL, XHATCH_FILL, INTERLEAVE_FILL,
                   WIDE_DOT_FILL, CLOSE_DOT_FILL, USER_FILL };

enum graphics_drivers { DETECT, CGA, MCGA, EGA, EGA64, EGAMONO, IBM8514, HERCMONO,
                        ATT400, VGA, PC3270 };

enum graphics_modes { CGAC0, CGAC1, CGAC2, CGAC3, CGAHI, 
                      MCGAC0 = 0, MCGAC1, MCGAC2, MCGAC3, MCGAMED, MCGAHI,
                      EGALO = 0, EGAHI,
                      EGA64LO = 0, EGA64HI,
                      EGAMONOHI = 3,
                      HERCMONOHI = 0,
                      ATT400C0 = 0, ATT400C1, ATT400C2, ATT400C3, ATT400MED, ATT400HI,
                      VGALO = 0, VGAMED, VGAHI,
                      PC3270HI = 0,
                      IBM8514LO = 0, IBM8514HI };

enum graph_errors { grInvalidVersion = -18, grInvalidDeviceNum = -15, grInvalidFontNum,
                    grInvalidFont, grIOerror, grError, grInvalidMode, grNoFontMem,
                    grFontNotFound, grNoFloodMem, grNoScanMem, grNoLoadMem,
                    grInvalidDriver, grFileNotFound, grNotDetected, grNoInitGraph,
                    grOk };

enum putimage_ops{ COPY_PUT, XOR_PUT, OR_PUT, AND_PUT, NOT_PUT };

#define NORM_WIDTH      1
#define THICK_WIDTH     3

#define USER_CHAR_SIZE  0
#define HORIZ_DIR       0
#define VERT_DIR        1

#define CURRENT_WINDOW -1
#define ALL_WINDOWS -2
#define NO_CURRENT_WINDOW -3

Display *bgi_display;
XFontStruct *bgi_font_info;

GC *bgi_gc;
struct _XWIN bgi_mywin;
char bgi_font[]="9xxxxx";
int bgi_x;
int bgi_y;

//#define initgraph(a,b,c)	bgi_display=XOpenDisplay(NULL);bgi_screen=DefaultScreen(bgi_display);bgi_win=XCreateSimpleWindow(bgi_display,RootWindow(bgi_display,bgi_screen),0,0,DisplayWidth(bgi_display,bgi_screen)-4,DisplayHeight(bgi_display,bgi_screen)-4,4,BlackPixel(bgi_display,bgi_screen),WhitePixel(bgi_display,bgi_screen));XMapWindow(bgi_display,bgi_win)
#define initgraph(a,b,c)	clg();bgi_mywin.a_x=bgi_mywin.a_y=0;bgi_gc=XCreateGC(bgi_display,0,0,0);bgi_font_info=XLoadQueryFont(0,"9");XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define detectgraph(a,b)	{}
#define cleardevice()		clg()
//#define closegraph() clg;XFreeGC(bgi_display,bgi_gc);XCloseDisplay(bgi_display)
#define closegraph() clg

#define getmaxcolor()	1
#define graphresult()	grOk
//#define	grOk	0
#define grapherrormsg(a) "z88dk gfx emulation ready"
//#define DETECT	0

#define getdrivername() ("z88dk gfx emulation")


#define	settextjustify(a,b)	{}

#define getviewsettings(vp) (vp)->right=intvp->right;(vp)->bottom=intvp->bottom;(vp)->top=intvp->top;(vp)->left=intvp->left
#define setviewport(l,t,r,b,c) intvp->left=l;intvp->top=t;intvp->right=r;intvp->bottom=b

struct viewporttype {
    int left;
    int top;
    int right;
    int bottom;
    int clip;
};

struct viewporttype intvp;

typedef struct arccoordstype {
    int x;
    int y;
    int xstart;
    int ystart;
    int xend;
    int yend;
} arccoordstype;

//struct arccoordstype bgi_arccoordstype;


struct fillsettingstype {
    int pattern;
    int color;
};

struct linesettingstype {
    int linestyle;
    unsigned int upattern;
    int thickness;
};

struct palettetype {
    unsigned char size;
    signed char colors[16];
};

struct textsettingstype {
    int font;	
    int direction;  
    int charsize;
    int horiz;
    int vert;
};



#ifndef GFXSCALEY
#define GFXSCALEY GFXSCALEX
#endif

#define getaspectratio(xasp,yasp) *(xasp)=1;*(yasp)=1

#ifdef GFXSCALEX
#undef getmaxx
#undef getmaxy
#define	getmaxx()    ((float)getmaxx()*((float)1/((float)GFXSCALEX)))
#define	getmaxy()    ((float)getmaxy()*((float)1/((float)GFXSCALEY)))
#define	getpixel(a,b)	point((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	putpixel(a,b,c)	((c) ? plot((a)*GFXSCALEX,(b)*GFXSCALEY):unplot((a)*GFXSCALEX,(b)*GFXSCALEY))
#define	moveto(a,b) bgi_x=a;bgi_y=b;xorplot((a)*GFXSCALEX,(b)*GFXSCALEY);xorplot((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	moverel(a,b) bgi_x=getx()+(a)*GFXSCALEX;bgi_y=gety()+(b)*GFXSCALEY;xorplot(bgi_x,bgi_y);xorplot(bgi_x,bgi_y)
#define	linerel(a,b)	drawr((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	lineto(a,b)	drawto((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	rectangle(a,b,c,d)	drawb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX,((d)-(b))*GFXSCALEY)
//#define	bar(a,b,c,d)	fillb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX,((d)-(b))*GFXSCALEY)
#define	bar(a,b,c,d)	stencil_init(bgi_stencil);stencil_add_side((a)*GFXSCALEX,(b)*GFXSCALEY,(a)*GFXSCALEX,(d)*GFXSCALEY,bgi_stencil);stencil_add_side((c)*GFXSCALEX,(b)*GFXSCALEY,(c)*GFXSCALEX,(d)*GFXSCALEY,bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);drawb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX+1,((d)-(b))*GFXSCALEY+1)
//#define	bar3d(a,b,c,d,e,f) undrawb((a)*GFXSCALEX+1,(b)*GFXSCALEY+1,((c)-(a)+1)*GFXSCALEX+2,((d)-(b)+1)*GFXSCALEY+2);fillb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX,((d)-(b))*GFXSCALEY);xorborder((a)*GFXSCALEX+1,(b)*GFXSCALEY+1,((c)-(a)+1)*GFXSCALEX+2,((d)-(b)+1)*GFXSCALEY+2)
#define	bar3d(a,b,c,d,e,f) undrawb((a)*GFXSCALEX+1,(b)*GFXSCALEY+1,((c)-(a)+e)*GFXSCALEX,((d)-(b)+e)*GFXSCALEY);stencil_init(bgi_stencil);stencil_add_side((a)*GFXSCALEX,(b)*GFXSCALEY,(a)*GFXSCALEX,(d)*GFXSCALEY,bgi_stencil);stencil_add_side((c)*GFXSCALEX,(b)*GFXSCALEY,(c)*GFXSCALEX,(d)*GFXSCALEY,bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);drawb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX+1,((d)-(b))*GFXSCALEY+1);xorborder((a)*GFXSCALEX+1,(b)*GFXSCALEY+1,((c)-(a)+e)*GFXSCALEX,((d)-(b)+e)*GFXSCALEY)
#undef circle
#define	circle(a,b,c)	circle((a)*GFXSCALEX,(b)*GFXSCALEY,(c)*GFXSCALEX,1)
//#define	circle(a,b,c)	ellipse(a,b,0,360,c,c)
//#define	circle(a,b,c) polygon((a)*GFXSCALEX,(b)*GFXSCALEY,180,(c)*GFXSCALEY,0);
#define	sector(a,b,c,d,e,f)		stencil_init(bgi_stencil);stencil_add_ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,360-(d),360-(c),(e)*GFXSCALEX,(f)*GFXSCALEY,bgi_stencil);stencil_add_lineto((a)*GFXSCALEX,(b)*GFXSCALEY,bgi_stencil);stencil_add_lineto(((a)+icos(360-(d))*(e)/256)*GFXSCALEX,((b)+isin(360-(d))*(f)/256)*GFXSCALEY,bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);ellipse((a),(b),(c),(d),(e),(f));drawto((a)*GFXSCALEX,(b)*GFXSCALEY);drawto(((a)+icos(360-(c))*(e)/256)*GFXSCALEX,((b)+isin(360-(c))*(f)/256)*GFXSCALEY)
#define	ellipse(a,b,c,d,e,f)	ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,c,d,(e)*GFXSCALEX,-(f)*GFXSCALEY)
//#define	fillellipse(a,b,c,d)	ellipse(a,b,0,360,c,d);fill((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	fillellipse(a,b,c,d)	stencil_init(bgi_stencil);stencil_add_ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,0,360,(c)*GFXSCALEX,(d)*GFXSCALEY,bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);ellipse(a,b,0,360,c,d)
#define	line(a,b,c,d)	draw((a)*GFXSCALEX,(b)*GFXSCALEY,(c)*GFXSCALEX,(d)*GFXSCALEY)
//#define	line(a,b,c,d)	plot((a)*GFXSCALEX,(b)*GFXSCALEY);drawto((c)*GFXSCALEX,(d)*GFXSCALEY)
#undef arc
//#define	arc(a,b,c,d,e)	bgi_arccoordstype.x=a;bgi_arccoordstype.y=b;bgi_arccoordstype.xstart=a+icos(e)*c/256;bgi_arccoordstype.ystart==b+isin(e)*c/256;bgi_arccoordstype.xstart=a+icos(e)*d/256;bgi_arccoordstype.ystart==b+isin(e)*d/256;ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,c,d,e,e)
#define	arc(a,b,c,d,e)	ellipse((a),(b),c,d,e,e)
#define	pieslice(a,b,c,d,e)		stencil_init(bgi_stencil);stencil_add_ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,360-(d),360-(c),(e)*GFXSCALEX,(e)*GFXSCALEY,bgi_stencil);stencil_add_lineto((a)*GFXSCALEX,(b)*GFXSCALEY,bgi_stencil);stencil_add_lineto(((a)+icos(360-(d))*(e)/256)*GFXSCALEX,((b)+isin(360-(d))*(e)/256)*GFXSCALEY,bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);ellipse((a),(b),(c),(d),(e),(e));drawto((a)*GFXSCALEX,(b)*GFXSCALEY);drawto(((a)+icos(360-(c))*(e)/256)*GFXSCALEX,((b)+isin(360-(c))*(e)/256)*GFXSCALEY)
#define	drawpoly(a,b)	for(bgi_x=0;bgi_x<((a)-1);bgi_x++){draw(b[bgi_x*2]*GFXSCALEX,b[1+bgi_x*2]*GFXSCALEY,b[2+bgi_x*2]*GFXSCALEX,b[3+bgi_x*2]*GFXSCALEY);}
#define floodfill(a,b,c)	fill((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	outtext(c) XDrawString(bgi_display,bgi_mywin,bgi_gc,bgi_x*GFXSCALEX,bgi_y*GFXSCALEY,c,strlen(c));bgi_x+=XTextWidth(bgi_font_info->fid,c,strlen(c))
#define	outtextxy(a,b,c) XDrawString(bgi_display,bgi_mywin,bgi_gc,(a)*GFXSCALEX,(b)*GFXSCALEY,c,strlen(c));
#define	settextstyle(a,b,c) itoa((c)+(a)*3*GFXSCALEX,bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define	setusercharsize(a,b,c,d) itoa(10*(a)*GFXSCALEX/(b),bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define textheight(a) 10*GFXSCALEY
#define imagesize(lx,ly,rx,ry) (((rx-lx)*GFXSCALEX/8+1)*(ry-ly)*GFXSCALEY+2)
//#define getimage(lx,ly,rx,ry,i) i[0]=rx*GFXSCALEX;i[1]=ry*GFXSCALEY;getsprite(lx*GFXSCALEX,ly*GFXSCALEY,i)
#define getimage(lx,ly,rx,ry,i) {}
#define putimage(lx,ly,i,putmode) putsprite(putmode,lx*GFXSCALEX,ly*GFXSCALEY,i);


#else
#define	getpixel(a,b)	point(a,b)
#define	putpixel(a,b,c)	(c ? plot(a,b):unplot(a,b))
#define	moveto(a,b) bgi_x=a;bgi_y=b;xorplot(a,b);xorplot(a,b)
#define	moverel(a,b) bgi_x=getx()+(a);bgi_y=gety()+(b);xorplot(bgi_x,bgi_y);xorplot(bgi_x,bgi_y)
#define	linerel(a,b)	drawr(a,b)
#define	lineto(a,b)	drawto(a,b)
#define	rectangle(a,b,c,d)	drawb(a,b,(c)-(a),(d)-(b))
//#define	bar(a,b,c,d)	fillb(a,b,(c)-(a),(d)-(b))
#define	bar(a,b,c,d)	stencil_init(bgi_stencil);stencil_add_side((a),(b),(a),(d),bgi_stencil);stencil_add_side((c),(b),(c),(d),bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);drawb((a),(b),((c)-(a))+1,((d)-(b))+1)
//#define	bar3d(a,b,c,d,e,f) undrawb(a+1,b+1,(c)-(a)+2,(d)-(b)+2);fillb(a,b,(c)-(a),(d)-(b));xorborder(a+1,b+1,(c)-(a)+2,(d)-(b)+2)
#define	bar3d(a,b,c,d,e,f) undrawb(a+1,b+1,(c)-(a)+e,(d)-(b)+e);stencil_init(bgi_stencil);stencil_add_side((a),(b),(a),(d),bgi_stencil);stencil_add_side((c),(b),(c),(d),bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);drawb((a),(b),((c)-(a))+1,((d)-(b))+1);xorborder(a+1,b+1,(c)-(a)+e,(d)-(b)+e)
#undef circle
#define	circle(a,b,c)	circle(a,b,c,1)
//#define	circle(a,b,c)	ellipse(a,b,0,360,c,c)
#define	sector(a,b,c,d,e,f)		stencil_init(bgi_stencil);stencil_add_ellipse(a,b,360-(d),360-(c),e,f,bgi_stencil);stencil_add_lineto(a,b,bgi_stencil);stencil_add_lineto(((a)+icos(360-(d))*(e)/256),((b)+isin(360-(d))*(f)/256),bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);ellipse(a,b,c,d,e,f);drawto(a,b);drawto(((a)+icos(360-(c))*(e)/256),((b)+isin(360-(c))*(f)/256))
#define	ellipse(a,b,c,d,e,f)	ellipse(a,b,c,d,e,-f)
//#define	fillellipse(a,b,c,d)	ellipse(a,b,0,360,c,d);fill(a,b)
#define	fillellipse(a,b,c,d)	stencil_init(bgi_stencil);stencil_add_ellipse(a,b,0,360,c,d,bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);ellipse(a,b,0,360,c,d)
#define	line(a,b,c,d)	draw(a,b,c,d)
#undef arc
//#define	arc(a,b,c,d,e)	bgi_arccoordstype.x=a;bgi_arccoordstype.y=b;bgi_arccoordstype.xstart=a+icos(e)*c/256;bgi_arccoordstype.ystart==b+isin(e)*c/256;bgi_arccoordstype.xstart=a+icos(e)*d/256;bgi_arccoordstype.ystart==b+isin(e)*d/256;ellipse((a),(b),c,d,e,e)
#define	arc(a,b,c,d,e)	ellipse((a),(b),c,d,e,e)
//#define	pieslice(a,b,c,d,e)	ellipse(a,b,360-(d),360-(c),e,e);drawto(a,b);drawto(((a)+icos(360-(d))*(e)/256),((b)+isin(360-(d))*(e)/256))
#define	pieslice(a,b,c,d,e)		stencil_init(bgi_stencil);stencil_add_ellipse(a,b,360-(d),360-(c),e,e,bgi_stencil);stencil_add_lineto(a,b,bgi_stencil);stencil_add_lineto(((a)+icos(360-(d))*(e)/256),((b)+isin(360-(d))*(e)/256),bgi_stencil);stencil_render(bgi_stencil,bgi_fillstyle);ellipse(a,b,c,d,e,e);drawto(a,b);drawto(((a)+icos(360-(c))*(e)/256),((b)+isin(360-(c))*(e)/256))
#define	drawpoly(a,b)	for(bgi_x=0;bgi_x<(a-1);bgi_x++){draw(b[bgi_x*2],b[1+bgi_x*2],b[2+bgi_x*2],b[3+bgi_x*2]);}
#define floodfill(a,b,c)	fill(a,b)
#define	outtext(c) XDrawString(bgi_display,bgi_mywin,bgi_gc,bgi_x,bgi_y,c,strlen(c));bgi_x+=XTextWidth(bgi_font_info->fid,c,strlen(c))
#define	outtextxy(a,b,c) XDrawString(bgi_display,bgi_mywin,bgi_gc,a,b,c,strlen(c))
#define	settextstyle(a,b,c) itoa((c)+(a)*2,bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define	setusercharsize(a,b,c,d) itoa(10*(a)/(b),bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define textheight(a) 6
#define imagesize(lx,ly,rx,ry) ((((rx)-(lx))/8+1)*((ry)-(ly))+2)
//#define getimage(lx,ly,rx,ry,i) i[0]=rx;i[1]=ry;getsprite(lx,ly,i)
#define getimage(lx,ly,rx,ry,i) {}
#define putimage(lx,ly,i,putmode) putsprite(putmode,lx,ly,i);

#endif


#define XOR_PUT SPR_XOR



#endif /* __BGI_H__ */
