  
  
/* ----------------------------------------------------------
   Z80SVG
   by Stefano Bodrato

   This program translates an SVG vector file 
   in a C source data declaration to be used
   in z88dk with the "draw_profile" function.

   MinGW
   gcc -Wall -O2 -o z80svg z80svg.c libxml2.dll

   $Id: z80svg.c,v 1.18 2015-02-11 19:27:05 stefano Exp $
 * ----------------------------------------------------------
*/


#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <libxml2/libxml/parser.h>

#include "../../include/gfxprofile.h"
//#include "gfxprofile.h"

//#ifdef LIBXML_READER_ENABLED

#ifdef __MINGW32__
#define fcloseall _fcloseall
#endif

/* 
 * Let's reduce the autosize computed scale to save memory
 * (overlapping corners are excluded)
 */

#define scale_divisor 2.5

struct svgcolor{
	char color_name[30];
	int  shade_level;
};


const struct svgcolor ctable[]={
    {"aliceblue", 1},
    {"antiquewhite", 1},
    {"aqua", 4},
    {"aquamarine", 3},
    {"azure", 1},
    {"beige", 1},
    {"bisque", 2},
    {"black", 11},
    {"blanchedalmond", 2},
    {"blue", 8},
    {"blueviolet", 6},
    {"brown", 8},
    {"burlywood", 4},
    {"cadetblue", 6},
    {"chartreuse", 6},
    {"chocolate", 7},
    {"coral", 5},
    {"cornflowerblue", 5},
    {"cornsilk", 1},
    {"crimson", 7},
    {"cyan", 4},
    {"darkblue", 10},
    {"darkcyan", 8},
    {"darkgoldenrod", 7},
    {"darkgray", 4},
    {"darkgreen", 10},
    {"darkgrey", 4},
    {"darkkhaki", 5},
    {"darkmagenta", 8},
    {"darkolivegreen", 8},
    {"darkorange", 6},
    {"darkorchid", 6},
    {"darkred", 10},
    {"darksalmon", 4},
    {"darkseagreen", 5},
    {"darkslateblue", 8},
    {"darkslategray", 9},
    {"darkslategrey", 9},
    {"darkturquoise", 6},
    {"darkviolet", 6},
    {"deeppink", 5},
    {"deepskyblue", 5},
    {"dimgray", 7},
    {"dimgrey", 7},
    {"dodgerblue", 5},
    {"firebrick", 8},
    {"floralwhite", 1},
    {"forestgreen", 9},
    {"fuchsia", 4},
    {"gainsboro", 2},
    {"ghostwhite", 1},
    {"gold", 5},
    {"goldenrod", 6},
    {"gray", 6},
    {"green", 10},
    {"greenyellow", 5},
    {"grey", 6},
    {"honeydew", 1},
    {"hotpink", 4},
    {"indianred", 6},
    {"indigo", 9},
    {"ivory", 1},
    {"khaki", 3},
    {"lavender", 1},
    {"lavenderblush", 1},
    {"lawngreen", 6},
    {"lemonchiffon", 1},
    {"lightblue", 3},
    {"lightcoral", 4},
    {"lightcyan", 1},
    {"lightgoldenrodyellow", 1},
    {"lightgray", 2},
    {"lightgreen", 4},
    {"lightgrey", 2},
    {"lightpink", 2},
    {"lightsalmon", 4},
    {"lightseagreen", 6},
    {"lightskyblue", 3},
    {"lightslategray", 6},
    {"lightslategrey", 6},
    {"lightsteelblue", 3},
    {"lightyellow", 1},
    {"lime", 8},
    {"limegreen", 7},
    {"linen", 1},
    {"magenta", 4},
    {"maroon", 10},
    {"mediumaquamarine", 5},
    {"mediumblue", 9},
    {"mediumorchid", 5},
    {"mediumpurple", 5},
    {"mediumseagreen", 6},
    {"mediumslateblue", 5},
    {"mediumspringgreen", 6},
    {"mediumturquoise", 5},
    {"mediumvioletred", 6},
    {"midnightblue", 9},
    {"mintcream", 1},
    {"mistyrose", 1},
    {"moccasin", 2},
    {"navajowhite", 2},
    {"navy", 10},
    {"oldlace", 1},
    {"olive", 8},
    {"olivedrab", 7},
    {"orange", 5},
    {"orangered", 7},
    {"orchid", 4},
    {"palegoldenrod", 2},
    {"palegreen", 4},
    {"paleturquoise", 2},
    {"palevioletred", 5},
    {"papayawhip", 1},
    {"peachpuff", 2},
    {"peru", 6},
    {"pink", 2},
    {"plum", 3},
    {"powderblue", 2},
    {"purple", 8},
    {"red", 8},
    {"rosybrown", 5},
    {"royalblue", 6},
    {"saddlebrown", 8},
    {"salmon", 4},
    {"sandybrown", 4},
    {"seagreen", 8},
    {"seashell", 1},
    {"sienna", 7},
    {"silver", 3},
    {"skyblue", 3},
    {"slateblue", 6},
    {"slategray", 6},
    {"slategrey", 6},
    {"snow", 1},
    {"springgreen", 6},
    {"steelblue", 6},
    {"tan", 4},
    {"teal", 8},
    {"thistle", 3},
    {"tomato", 5},
    {"turquoise", 4},
    {"violet", 3},
    {"wheat", 2},
    {"white", 0},
    {"whitesmoke", 1},
    {"yellow", 4},
    {"yellowgreen", 6},
    {"", 255}
};


/* Global variables */

/* colors */
unsigned char pen;
unsigned char fill;
/* default */
unsigned char color;
int color_balance;
/* fill flags */
unsigned char area;
unsigned char line;
/* Counters */
int	elementcnt;
unsigned int pathcnt,nodecnt,skipcnt;

/* File and string buffer pointers */
char destline[10000];
FILE *source,*dest;

/* flags */
int inipath;
int grouping=0;
int maxelements=0;
int verbose=0;
int expanded=0;
int rotate=0;
int pathdetails=0;
int wireframe=0;
int autosize=0;
int forcedmode=0;
int xshift=0;
int yshift=0;

unsigned char inix,iniy;
unsigned char oldx, oldy;


/* Positioning */
float scale=100;
float xyproportion=1;
float width, height;
float xx,yy,cx,cy,fx,fy;
float lm,rm,tm,bm;
float alm,arm,atm,abm;
unsigned char x,y;

/* Current command */
unsigned char cmd;

int gethex(char hexval) {
	char c;
	if (isdigit(hexval)) return (hexval-'0');
	c=toupper(hexval);
	if ((c<'A')||(c>'F')) return(0);
	return (10+(c-'A'));
}

char *skip_spc(char *p) {
	while ( (isspace(*p) || (*p == ',')) && (strlen(p) > 0) ) p++;
	return (p);
}

char *skip_num(char *p) {
	p=skip_spc(p);
	p++;
	while ( (isdigit(*p) || (*p == '.') ) && (strlen(p) > 0) ) p++;
	p=skip_spc(p);
	return (p);
}

int get_color(char *style) {
	int color;
	int c;
	
	c=0;

	while (ctable[c++].shade_level<255) {
		if(!strcmp(style, ctable[c].color_name))
			return(ctable[c].shade_level);
	}

	if(!strncmp(style, "rgb",3)) {
		while (!isdigit(*style) && (strlen(style) > 0) ) style++;
		color=atoi(style);
		while ( (*style != ',') && (strlen(style) > 0) ) style++;
		color=color+atoi(++style);
		while ( (*style != ',') && (strlen(style) > 0) ) style++;
		color=color+atoi(++style);
		color = color_balance+(11-(11*color/(255*3)));
		return (color);
	}

	if(!strncmp(style, "url",3))
		return(3);

//	if(!strcmp(style, "black"))
//		return(DITHER_BLACK);
//	else if(!strcmp(style, "white"))
//		return(DITHER_WHITE);
//	else 
	if (style[0] == '#') {
		color = color_balance+(11-11*(16*gethex(style[1])+gethex(style[2])+
		  16*gethex(style[3])+gethex(style[4])+
		  16*gethex(style[5])+gethex(style[6]))/(255*3));
		if (color > 11) color=11;
		if (color < 0) color=0;
		return (color);
	  }
	else return (-1);  /* "none" */
}

int look_parent_name(xmlNodePtr node,char * layer_name)
{
	xmlNodePtr parentnode;
	xmlChar *attr;
	char Dummy[600];

	parentnode = node;
	
	while (parentnode->parent != NULL) {
			attr = xmlGetProp(parentnode, (const xmlChar *) "id");
			if (attr != NULL) {
				sprintf(Dummy,"%s",(const char *)attr);
				if (strcmp(layer_name,Dummy)==0) return 1;
			}
			parentnode=parentnode->parent;
	}
	return 0;
}


/* Pick pen and area style */
void chkstyle_a (xmlNodePtr node)
{
	xmlChar *attr;
	int retcode;
	float opacity;
	char *style;

	  opacity = 0.6;
	  attr = xmlGetProp(node, (const xmlChar *) "fill-opacity");
	  if(attr != NULL) {
			opacity=atof((const char *)attr);
			//xmlFree(attr);
	  }
	  //  a pass with valgrind would be a great idea  :/
	  //
	  attr = xmlGetProp(node, (const xmlChar *) "fill");
	  if(attr != NULL) {
			style=strdup((const char *)attr);
			retcode=get_color(style);
			free(style);
			if (retcode == -1) {
				if ((area == 1)&&(verbose==1)) fprintf(stderr,"\n  Disabling area mode");
				area=0;
				}
			else if (opacity > 0.5) {
				area=1;
				fill=(unsigned char)retcode;
				if (verbose==1) fprintf(stderr,"\n  Area mode enabled, dither level: %i",fill);
			} else {
				if ((area == 1) && (verbose==1)) fprintf(stderr,"\n  Disabling area mode (too transparent)");
				area=0;
			}
			//xmlFree(attr);
	  }
	  //
	  
	  /* Now the line properties */
	  opacity=0.6;
	  attr = xmlGetProp(node, (const xmlChar *) "stroke-opacity");
	  if(attr != NULL) {
			opacity=atof((const char *)attr);
			//xmlFree(attr);
	  }
	  //

	  attr = xmlGetProp(node, (const xmlChar *) "stroke");
	  if(attr != NULL) {
			style=strdup((const char *)attr);
			retcode=get_color(style);
			free(style);
			
			if (opacity > 0.5) retcode=DITHER_BLACK;
			if (retcode == -1) {
				if ((line == 1)&&((verbose==1))) fprintf(stderr,"\n  Disabling line mode (too transparent)");
				line=0;
				}
			else {
				line=1;
				pen=(unsigned char)retcode;
				if (verbose==1) fprintf(stderr,"\n  Line mode enabled, dither level: %i",fill);
			}
			//!!!xmlFree(attr);
	  }
	  //
	  if (line == 1) {
		  attr = xmlGetProp(node, (const xmlChar *) "stroke-width");
		  if(attr != NULL) {
			  pen=atoi((const char *)attr);
			  if ((pen>1)&&(pen!=0)) {
				pen=DITHER_BLACK+(pen)/2;
				if (pen>15) pen=15;
				if (verbose==1) fprintf(stderr,"\n  Extra pen width: %i", pen);
				//xmlFree(attr);
			  } else pen = color;
		  } //else pen = color;
		  //
	  }
}


void chkstyle_b(xmlNodePtr node)
{
	xmlChar *attr;
	char *style;
	char *sstyle;
	int retcode;
	float forceline;
	float opacity;
	float stroke_opacity;

	  attr = xmlGetProp(node, (const xmlChar *) "style");
	  if(attr != NULL) {
		stroke_opacity = 0;
		retcode = 0;
		opacity = 0;
		forceline = 0;
		sstyle=strdup((const char *)attr);
		style=sstyle;
		strtok(style,";:");
		while (style != NULL) {
			if (!strcmp(style,"fill")) {
				style=strtok(NULL,";:");
				retcode=get_color(style);
				if ((retcode == -1)||(forceline == 1)) {
					if ((area == 1)&&(verbose==1)) fprintf(stderr,"\n  Disabling area mode");
					area=0;
					}
				else {
					area=1;
					fill=(unsigned char)retcode;
					if (verbose==1) fprintf(stderr,"\n  Area mode enabled, dither level: %i",fill);
				}
			}

			if (!strcmp(style,"fill-opacity")) {
				style=strtok(NULL,";:");
				opacity=atof(style);
				if (opacity <= 0.5) {
					if ((area == 1)&&(verbose==1)) fprintf(stderr,"\n  Disabling area mode (too transparent)");
					area=0;
				}
			}

			if (!strcmp(style,"stroke-opacity")) {
				style=strtok(NULL,";:");
				stroke_opacity=atof(style);
				if ((retcode == -1) && (stroke_opacity > 0.6)) {
					if (verbose==1) fprintf(stderr,"\n  Restoring line mode");
					line=1;
				}
			}

			if (!strcmp(style,"opacity")) {
				style=strtok(NULL,";:");
				forceline=atof(style);
			}

			if (!strcmp(style,"stroke")) {
				style=strtok(NULL,";:");
				retcode=get_color(style);
				// Second condition happens only when opacity is definded *before* the stroke color
				if ((retcode != -1) || (stroke_opacity>0.6) || (forceline == 1)) {
					line=1;
					if (retcode == -1)
						pen = DITHER_BLACK;
					else
						pen=(unsigned char)retcode;
					if (verbose==1) fprintf(stderr,"\n  Line mode enabled, dither level: %i",fill);
					}
				else {
					if ((line == 1)&&(verbose==1)) fprintf(stderr,"\n  Disabling line mode");
					line=0;
				}
			}
			
			if (!strcmp(style,"stroke-width")) {
				style=strtok(NULL,";:");
				if (line == 1) {
					pen=atoi(style);
					  if ((pen>1)&&(pen!=0)) {
						pen=DITHER_BLACK+(pen)/2;
						if (pen>15) pen=15;
						if (verbose==1) fprintf(stderr,"\n  Extra pen width: %i", pen);
					  } else pen = color;
				}
			}

			style=strtok(NULL,";:");
		//free(sstyle);
		}
	  //free(style);
	  //xmlFree(attr);
	  }
}


void chkstyle(xmlNodePtr node) {
				if (wireframe != 1) {
					chkstyle_a (node);
					chkstyle_b (node);
					switch (forcedmode) {
						case 1:
							line=1;	area=0;
							break;
						case 2:
							line=0;	area=1;
							break;
						case 3:
							line=1;	area=1;
							break;
						case 4:
							line=1;
							break;
						case 5:
							area=1;
							break;
						case 6:
							line=0;
							break;
						case 7:
							area=0;
							break;
					}
				}
}

void move_to (unsigned char x,unsigned char y) {

		if ((expanded==0)&&(elementcnt > 0))
			if ((area==1)||(line==1))
				fprintf(dest,"\t0x%2X,0x%02X, %s\n", REPEAT_COMMAND, elementcnt, destline);
		elementcnt=0;
		//sprintf(destline,"");
		destline[0]='\0';
		if ((inipath==0) && (area==1) && (line==1))
			fprintf( dest,"\n\t0x%2X, ", CMD_AREA_INITB );
		else if (grouping == 0) {
			if ((inipath==1) && (area==1))
				fprintf(dest,"\t0x%2X,\n", CMD_AREA_CLOSE|fill);
			if ((area==1) && (line==1))
				fprintf( dest,"\n\t0x%2X, ", CMD_AREA_INITB );
		}
		inix=x;
		iniy=y;
		if ((area==1)||(line==1)) {
			if ((area==1) && (line==0)) {
			  fprintf(dest,"\n\t0x%2X,0x%02X,0x%02X,\n\t", CMD_AREA_PLOT, x, y);
			}
			else
			  fprintf(dest,"\n\t0x%2X,0x%02X,0x%02X,\n\t", CMD_PLOT|pen, x, y);
		}
		inipath=1;
}

void line_to (unsigned char x,unsigned char y,unsigned char oldx,unsigned char oldy) {
	if (expanded == 0) {
		if ((x != oldx) || (y != oldy)) {
		  if ((area==1) && (line==0))
			if (elementcnt == 0)
				sprintf(destline,"%s 0x%2X,0x%02X,0x%02X,", destline, CMD_AREA_LINETO, x, y);
			else
				sprintf(destline,"%s 0x%02X,0x%02X,", destline, x, y);
		  else {
			if ((area==1)||(line==1)) {
				if (elementcnt == 0)
					sprintf(destline,"%s 0x%2X,0x%02X,0x%02X,", destline, CMD_LINETO|pen, x, y);
				else
					sprintf(destline,"%s 0x%02X,0x%02X,", destline, x, y);
			}
		  }
		}
		else {elementcnt--; skipcnt++;}
	} else {
		if (((expanded == 1) && ((x != oldx) && (y != oldy))) ||
			((expanded == 2) && ((x != oldx) || (y != oldy)))) {
		  if ((area==1) && (line==0))
			fprintf(dest," 0x%2X,0x%02X,0x%02X,", CMD_AREA_LINETO, x, y);
		  else if ((area==1)||(line==1))
			fprintf(dest," 0x%2X,0x%02X,0x%02X,", CMD_LINETO|pen, x, y);
		} 
		else if ((x != oldx) && (y == oldy)) {
		  if ((area==1) && (line==0))
			fprintf(dest," 0x%2X,0x%02X,", CMD_AREA_HLINETO, x);
		  else if ((area==1)||(line==1))
			fprintf(dest," 0x%2X,0x%02X,", CMD_HLINETO|pen, x);
		} 
		else if ((x == oldx) && (y != oldy)) {
		  if ((area==1) && (line==0))
			fprintf(dest," 0x%2X,0x%02X,", CMD_AREA_VLINETO, y);
		  else if  ((area==1)||(line==1))
			fprintf(dest," 0x%2X,0x%02X,", CMD_VLINETO|pen, y);
		} 
		else {elementcnt--; skipcnt++;}
	}
	elementcnt++;
}

void close_area() {
	if ((expanded == 0)&&(elementcnt>0))
		if ((area==1)||(line==1))
			fprintf(dest,"\t0x%2X,0x%02X, %s\n\t", REPEAT_COMMAND, elementcnt, destline);

	if ((area == 1) && (inipath==1)) {
		fprintf(dest,"\t0x%2X,\n", CMD_AREA_CLOSE|fill);
	}
}


void scale_and_shift() {

float ax;
char * tmpstr;

	tmpstr=malloc(100);
	/* Scale and shift the picture (part of the main loop) */
	cx=(scale*xyproportion*(cx-xx)/100);
	cy=(scale*(cy-yy)/100);
	if (rotate==1) {
		ax=cx;	cx=cy;	cy=ax;
	}
	
	if (pathdetails==1) printf("\n%c %f %f",cmd,cx,cy);
	
	sprintf (tmpstr,"%0.f",(255*cx/width));
	fx=atof(tmpstr)+xshift;
	if (autosize==2) {
		if (fx<=0) fx=0;
		if (fx>=255) fx=255;
		sprintf (tmpstr,"%0.f",fx-xshift);
	}
	x=atoi(tmpstr)+xshift;
	sprintf (tmpstr,"%0.f",(255*cy/height));
	fy=atof(tmpstr)+yshift;	
	if (autosize==2) {
		if (fy<=0) fy=0;
		if (fy>=255) fy=255;
		sprintf (tmpstr,"%0.f",fy-yshift);
	}
	y=atoi(tmpstr)+yshift;

	/* keep track of margins */
	if (lm>fx) lm=fx;
	if (rm<fx) rm=fx;
	if (tm>fy) tm=fy;
	if (bm<fy) bm=fy;

	//printf("|%c| 0x%02X 0x%02X",cmd, x, y);
	if ((area==1)||(line==1))
		if (pathdetails==2) printf("\n%c %03u %03u",cmd, x, y);
	
	free(tmpstr);
}


int main( int argc, char *argv[] )
{
	char Dummy[600];
	char currentlayer[300]="";
    int i;
    char** p = argv+1;
	char *arg;
	float x1,x2,y1,y2;

	char stname[150]="svg_picture";
	char sname[300]="";
	char dname[300]="";

	int takedisabled=0;
	int curves_cnt;
	int excluded_nodes=0;

	xmlDocPtr doc;
	xmlNodePtr node;
	xmlChar *attr;
	xmlNodePtr gnode[100];
	/*unsigned char nodecolor[500];
	unsigned char nodefill[500];
	unsigned char nodearea[500];
	unsigned char nodeline[500];*/
	unsigned int gcount=0;

	char *path;
	// Static line buffer, to make it compatible to MinGW32
	char spath[2000000];
	unsigned char oldcmd;
	float svcx,svcy;

    if ( (argc < 2) ) {
      fprintf(stderr,"\nParameter error, use 'z80svg -h' for help.\n\n");
      exit(1);
    }

	color=DITHER_BLACK;  /* 11 (black thin pen) is default */
	color_balance=0;  /* 11 (black thin pen) is default */

	for (i = 1; i < argc; i++) {
	 arg = argv[i];
	 if (arg && *arg == '-') {
	   switch (arg[1]) {
	   case 'h' :
			fprintf(stderr,"\n\nz80svg - SVG vector format conversion tool for z88dk \n");
			fprintf(stderr,"Usage: z80svg [options] <SVG file>");
			fprintf(stderr,"\nOptions:");
			fprintf(stderr,"\n   -nSTRUCTNAME: name of the C structure being created.");
			fprintf(stderr,"\n      The default name is 'svg_picture'");
			fprintf(stderr,"\n   -oTARGET: output file name. '.h' is always added.");
			fprintf(stderr,"\n      Default is the source SVG file name with trailing '.h'.");
			fprintf(stderr,"\n   -a: shift and resize automatically to roughly 100 points.");
			fprintf(stderr,"\n   -sSCALE: optional percentage to resize the picture size.");
			fprintf(stderr,"\n   -zPROPORTION: x/y proportion (default is 1).");
			fprintf(stderr,"\n   -xXSHIFT: optional top-left corner shifting, X coordinate.");
			fprintf(stderr,"\n      Negative values are allowed.");
			fprintf(stderr,"\n   -yYSHIFT: optional top-left corner shifting, Y coordinate.");
			fprintf(stderr,"\n      Negative values are allowed.");
			fprintf(stderr,"\n   -cCOLOR: Change pen color, default is black (11).");
			fprintf(stderr,"\n      (0-11) white to black, (12-15) thicker gray to black.");
			fprintf(stderr,"\n   -bSHIFT: Adjust 'color' brightness, +/- 10.");
			fprintf(stderr,"\n   -w: Enable wireframe mode.       |  -r: Rotate the picture.");
			fprintf(stderr,"\n   -i: Include the disabled layers. |  -v: Verbose.");
			fprintf(stderr,"\n   -e<1,2>: Encode in expanded form, repeating every command.");
			fprintf(stderr,"\n   -l<1-255>: Force max number of 'lineto' elements in a row.");
			fprintf(stderr,"\n   -g: Group paths forming the same area in a single stencil block.");
			fprintf(stderr,"\n   -f1..7: Force line/area modes (1/0 0/1 1/1 1/X X/1 0/X X/0).");
			fprintf(stderr,"\n   -p1/-p2: List path details to stdout (float or converted int values).");
			fprintf(stderr,"\n");
			exit(1);
			break;
	   case 'n' :
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid struct name\n");
				exit(2);
			}
			sprintf(stname,"%s", arg+2);
			break;
	   case 'o' :
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid output file name\n");
				exit(3);
			}
			sprintf(dname,"%s", arg+2);
			break;
	   case 's' :
			scale=atof(arg+2);
			if (scale < 1) {
				fprintf(stderr,"\nInvalid scale value\n");
				exit(4);
			}
			break;
	   case 'z' :
			xyproportion=atof(arg+2);
			if (xyproportion < 1) {
				fprintf(stderr,"\nInvalid value for x/y proportion\n");
				exit(5);
			}
			break;
	   case 'x' :
			xshift=atoi(arg+2);
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid X shifting value.\n");
				exit(6);
			}
			break;
	   case 'y' :
			yshift=atoi(arg+2);
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid Y shifting value.\n");
				exit(7);
			}
			break;
	   case 'c' :
			color=atoi(arg+2);
			if (color > 15) {
				fprintf(stderr,"\nInvalid color.\n");
				exit(8);
			}
			break;
	   case 'l' :
			maxelements=atoi(arg+2);
			if (maxelements > 255) {
				fprintf(stderr,"\nInvalid max. number of line elements per row.\n");
				exit(9);
			}
			break;
	   case 'b' :
			color_balance=atoi(arg+2);
			if ((color_balance > 10)||(color_balance < -10)) {
				fprintf(stderr,"\nInvalid color brightness shift.\n");
				exit(10);
			}
			break;
	   case 'w' :
			wireframe=1;
			break;
	   case 'v' :
			verbose=1;
			break;
	   case 'r' :
			rotate=1;
			break;
	   case 'i' :
			takedisabled=1;
			break;
	   case 'g' :
			grouping=1;
			break;
	   case 'p' :
			pathdetails=atoi(arg+2);
			if ((pathdetails==0)||(pathdetails>2)) {
				fprintf(stderr,"\nInvalid path detail listing option.\n");
				exit(11);
			}
			break;
	   case 'f' :
			forcedmode=atoi(arg+2);
			if ((forcedmode==0)||(forcedmode>7)) {
				fprintf(stderr,"\nInvalid 'force mode' option.\n");
				exit(12);
			}
			break;
	   case 'e' :
			expanded=atoi(arg+2);
			if (expanded>2) {
				fprintf(stderr,"\nInvalid option for expanded format.\n");
				exit(13);
			}
			break;
	   case 'a' :
			autosize=1;
			break;
	   default :
			if (*p != arg) *p = arg;
			p++;
			break;
	   }
	 }
	 else {
	   if (*p != arg) *p = arg;
	   p++;
	 }
	}

	if (maxelements==0) {
		if (expanded == 0)
			maxelements=64;
		else
			maxelements=30;
	}

	sprintf(sname,"%s", arg);

    /* Initialize the XML library */
    /* (do we really need this?) */
    LIBXML_TEST_VERSION

	if (verbose==1) fprintf(stderr,"\n------\ntroubleshooting tips\n------\n");

	oldcmd=0;
	xx=0; yy=0; cx=0; cy=0;

	if (autosize==1)
		fprintf(stderr,"\n------\nAutosize mode, FIRST PASS\n------\n");
		
autoloop:

	doc = xmlParseFile(sname);
	
	if (doc == NULL ) {
		fprintf(stderr,"Error, can't parse the source SVG file   %s\n",sname);
		exit(14);
	}
 
 	node = xmlDocGetRootElement(doc);
	if (node == NULL) {
		fprintf(stderr,"Error empty SVG document\n");
		xmlFreeDoc(doc);
		exit(15);
	}

	if (strlen(dname)==0) sprintf(dname,"%s", sname);
    strcpy(Dummy,dname);
    strcat(Dummy,".h");               /* add suffix .h to target name */
    if( (dest=fopen( Dummy, "wb+" )) == NULL )
    {
		fprintf(stderr,"Error, can't open the destination file   %s\n", Dummy);
		xmlFreeDoc(doc);
		// (void)fcloseall();
		exit(16);
    }
	fprintf(stderr,"\nOutput file is %s\n", Dummy);

    fprintf( dest, "\n\n\nstatic unsigned char %s[] = {  ", stname );
	//if (wireframe == 0) fprintf( dest,"\n\t0x%2X,", CMD_AREA_INIT );

	if( ferror( dest ) ) {
		fprintf(stderr, "Error writing on target file:  %s\n", dname );
		xmlFreeDoc(doc);
		// (void)fcloseall();
		exit(17);
    }

 		// Check if it is an svg file
		if(xmlStrcmp(node->name, (const xmlChar *) "svg") != 0)
		{
			fprintf(stderr, "Not an svg file\n");
			xmlFreeDoc(doc);
			exit(18);
		}

		//destline=malloc(5000);
		width = height = 255;
		x = y = inix = iniy = 0;
		pen=color;
		fill=color;
		area=0;
		line=1;

		// Width
		attr = xmlGetProp(node, (const xmlChar *) "width");
		if(attr != NULL) {
			width = atof((const char *)attr);
			//xmlFree(attr);
		}

		// Height
		attr = xmlGetProp(node, (const xmlChar *) "height");
		if(attr != NULL)
			height = atof((const char *)attr);
		//xmlFree(attr);

		// X
		attr = xmlGetProp(node, (const xmlChar *) "x");
		if(attr != NULL)
			xx = atof((const char *)attr);
		//xmlFree(attr);
		// Y
		attr = xmlGetProp(node, (const xmlChar *) "y");
		if(attr != NULL)
			yy = atof((const char *)attr);
		//xmlFree(attr);

		// Init abs margin limits (inverted)
		alm = width;
		arm = 0;
		atm = height;
		abm = 0;
		
		// Normalize max coordinates
		if (width >height)
			height=width;
		else
			width=height;
		
		//go one step deeper
		if (node->xmlChildrenNode != NULL)	// This protection is probably not necessary
			node = node->xmlChildrenNode;

		// Show all nodes in the current pos
		excluded_nodes =0;
		pathcnt=0;
		inipath=0;
		while(node != NULL) {

			if(xmlStrcmp(node->name, (const xmlChar *) "namedview") == 0) {

				attr = xmlGetProp(node, (const xmlChar *) "id");
				if (attr == NULL)
					strcpy(Dummy,"(id missing)");
				else {
					sprintf(Dummy,"%s",(const char *)attr);
					//xmlFree(attr);
				}
				if (verbose==1) fprintf(stderr,"\nAnalyzing view: %s",Dummy);
				//

				attr = xmlGetProp(node, (const xmlChar *) "current-layer");
				if (attr != NULL) {
					sprintf(currentlayer,"%s",(const char *)attr);
					if (verbose==1) fprintf(stderr,"\nLimiting to layer: %s",currentlayer);
					//xmlFree(attr);
				}
				//
			}



			if(xmlStrcmp(node->name, (const xmlChar *) "g") == 0) {

				gnode[gcount]=node;
				gcount++;

				attr = xmlGetProp(node, (const xmlChar *) "id");
				if (attr == NULL)
					strcpy(Dummy,"(name missing)");
				else {
					sprintf(Dummy,"%s",(const char *)attr);
					//xmlFree(attr);
				}
				
				//if (strlen(currentlayer)!=0) {
				//if (takedisabled==1) {
				//if ((takedisabled==1) || (strlen(currentlayer)==0) || (strcmp(currentlayer,Dummy)==0)) {
				if ((takedisabled==1) || (strlen(currentlayer)==0) || look_parent_name(node,currentlayer)) {
				
					if (verbose==1) fprintf(stderr,"\nEntering subnode (%u), id: %s",gcount,Dummy);

					pen=color;
					fill=color;
					area=0;
					line=1;

					chkstyle (node);

					if (node->xmlChildrenNode != NULL)
						node = node->xmlChildrenNode;
					else
						if (verbose==1) fprintf(stderr," -> (empty subnode)");
				} else {
					excluded_nodes++;
					if (verbose==1) fprintf(stderr,"\nExcluding subnode (%u), id: %s, use '-i' to force inclusion.",gcount,Dummy);
				}
			}

			/*      */
			/* Line */
			/*      */
			if(xmlStrcmp(node->name, (const xmlChar *) "line") == 0) {

				inipath=0;
				elementcnt=0;

				if (verbose==1) fprintf(stderr,"\nObject: 'line'.");

				chkstyle (node);
				
				x1=y1=x2=y2=0;
				oldx=oldy=0;
				svcx=svcy=0;
				
				attr = xmlGetProp(node, (const xmlChar *) "x1");
				if(attr != NULL) {
					x1=atof((const char *)attr)-xx;
					//xmlFree(attr);
				}
				attr = xmlGetProp(node, (const xmlChar *) "y1");
				if(attr != NULL) {
					y1=atof((const char *)attr)-yy;
					//xmlFree(attr);
				}
				attr = xmlGetProp(node, (const xmlChar *) "x2");
				if(attr != NULL) {
					x2=atof((const char *)attr);
					//xmlFree(attr);
				}
				attr = xmlGetProp(node, (const xmlChar *) "y2");
				if(attr != NULL) {
					y2=atof((const char *)attr);
					//xmlFree(attr);
				}

				/* Let's put something in the 'cmd' variable.. '|' for line */

				cmd='|';
				cx=x1; cy=y1;
				scale_and_shift();
				move_to (x,y);
				oldx=x; oldy=y;
				line_to (x,y,oldx,oldy);

				cx=x2; cy=y2;
				scale_and_shift();
				line_to (x,y,oldx,oldy);
				oldx=x; oldy=y;

				if (pathdetails>0) printf("\n");

				close_area();

				/* keep track of absolute margins */
				if (alm>lm) alm=lm;
				if (arm<rm) arm=rm;
				if (atm>tm) atm=tm;
				if (abm<bm) abm=bm;

				inipath=0;
			}


			/*           */
			/* Rectangle */
			/*           */
			if(xmlStrcmp(node->name, (const xmlChar *) "rect") == 0) {

				inipath=0;
				elementcnt=0;

				if (verbose==1) fprintf(stderr,"\nObject: 'rect'.");

				chkstyle (node);
				
				x1=y1=x2=y2=0;
				oldx=oldy=0;
				svcx=svcy=0;
				
				attr = xmlGetProp(node, (const xmlChar *) "x");
				if(attr != NULL) {
					x1=atof((const char *)attr)-xx;
					//xmlFree(attr);
				}
				attr = xmlGetProp(node, (const xmlChar *) "y");
				if(attr != NULL) {
					y1=atof((const char *)attr)-yy;
					//xmlFree(attr);
				}
				attr = xmlGetProp(node, (const xmlChar *) "width");
				if(attr != NULL) {
					x2=x1+atof((const char *)attr);
					//xmlFree(attr);
				}
				attr = xmlGetProp(node, (const xmlChar *) "height");
				if(attr != NULL) {
					y2=y1+atof((const char *)attr);
					//xmlFree(attr);
				}

				/* Let's put something in the 'cmd' variable,
				 * this will be shown if 'details' are printed out. '[...]'*/

				/* first corner: '[' */
				cmd='[';
				cx=x1; cy=y1;
				scale_and_shift();
				cmd='|';
				move_to (x,y);
				oldx=x; oldy=y;
				line_to (x,y,oldx,oldy);

				/* segment 1 */
				cx=x2; cy=y1;
				scale_and_shift();
				line_to (x,y,oldx,oldy);
				oldx=x; oldy=y;

				/* segment 2 */
				cx=x2; cy=y2;
				scale_and_shift();
				line_to (x,y,oldx,oldy);
				oldx=x; oldy=y;

				/* segment 3 */
				cx=x1; cy=y2;
				scale_and_shift();
				line_to (x,y,oldx,oldy);
				oldx=x; oldy=y;

				/* segment 4 */
				cmd=']';
				cx=x1; cy=y1;
				scale_and_shift();
				line_to (x,y,oldx,oldy);
				oldx=x; oldy=y;

				if (pathdetails>0) printf("\n");

				close_area();

				/* keep track of absolute margins */
				if (alm>lm) alm=lm;
				if (arm<rm) arm=rm;
				if (atm>tm) atm=tm;
				if (abm<bm) abm=bm;

				inipath=0;
			}


			/*         */
			/* Polygon */
			/*         */
			if(xmlStrcmp(node->name, (const xmlChar *) "polygon") == 0) {

				inipath=0;
				elementcnt=0;

				if (verbose==1) fprintf(stderr,"\nObject: 'polygon'.");

				chkstyle (node);
				
				x1=y1=x2=y2=0;
				oldx=oldy=0;
				svcx=svcy=0;
				
				cmd='[';

				attr = xmlGetProp(node, (const xmlChar *) "points");
				if(attr != NULL) {
					sprintf(Dummy,"%s",(const char *)attr);
					//xmlFree(attr);

/*
					cx=x1; cy=y1;
					scale_and_shift();
					move_to (x,y);
					oldx=x; oldy=y;
					line_to (x,y,oldx,oldy);

					cx=x2; cy=y2;
					scale_and_shift();
					line_to (x,y,oldx,oldy);
					oldx=x; oldy=y;

					if (pathdetails>0) printf("\n");

					close_area();
*/
//					/* keep track of absolute margins */
//					if (alm>lm) alm=lm;
//					if (arm<rm) arm=rm;
//					if (atm>tm) atm=tm;
//					if (abm<bm) abm=bm;
				}
				inipath=0;
			}

			/* PATHS (a whole world!) */
			if(xmlStrcmp(node->name, (const xmlChar *) "path") == 0) {
				pathcnt++;
				attr = xmlGetProp(node, (const xmlChar *) "id");
				if (attr == NULL)
					strcpy(Dummy,"(no name)");
				else {
					sprintf(Dummy,"%s",(const char *)attr);
					//xmlFree(attr);
				}
				if (verbose==1) fprintf(stderr,"\n  Processing path group #%u, id: %s",pathcnt,Dummy);

				chkstyle(node);

				attr = xmlGetProp(node, (const xmlChar *) "d");

				nodecnt=0; skipcnt=0;
				fprintf(dest,"\n\n\t// Group #%u - %s\n", pathcnt,Dummy);

				// Init rel margin limits (inverted)
				lm = width;
				rm = 0;
				tm = height;
				bm = 0;
				
				elementcnt = 0;

				if(attr != NULL) {
					
					/* ************************* */
					/* MAIN PATH CONVERSION LOOP */
					/* ************************* */
					//spath=strdup((char *)attr);
					sprintf (spath,"%s",(const char *)attr);
					path=spath;
					curves_cnt=0;
					oldx=oldy=0;
					svcx=svcy=0;

					while (strlen(path)>0) {
						path=skip_spc(path);
						cmd=*path;
						if ((isdigit(cmd))||(cmd=='-'))
							switch (oldcmd) {
								case 'm':
									cmd = 'l';
									break;
								case 'M':
									cmd = 'L';
									break;
								default:
									cmd=oldcmd;
							}
						else {
							curves_cnt=0;
							oldcmd=cmd;
							path++;
							skip_spc(path);
						}
/*
		  The <path> Tag - The following commands are available for path data:

			* M = moveto
			* L = lineto
			* H = horizontal lineto
			* V = vertical lineto
			* C = curveto
			* S = smooth curveto
			* Q = quadratic Belzier curve
			* T = smooth quadratic Belzier curveto
			* A = elliptical Arc
			* Z = closepath
*/
						if ((cmd == 'Z')||(cmd == 'z')) {
							if ((x != inix) || (y != iniy))
								line_to (inix,iniy,oldx,oldy);

							if (pathdetails>0) printf("\n%c", cmd);
							if (strlen(path)>0) {
								//oldcmd=*path;
								path++;
								skip_spc(path);
							}
						} else {
							nodecnt++;
							/* skip 5 parameters if cmd is 'arc'*/
							if ((cmd == 'A')||(cmd == 'a')) {
								path=skip_num(path);
								path=skip_num(path);
								path=skip_num(path);
								path=skip_num(path);
								path=skip_num(path);
							}
							/* Vertical and Horizontal lines take 1 parameter only */
							if (toupper(cmd) != 'V') {
								cx=atof(path)-xx;
								path=skip_num(path);
							}
							if (toupper(cmd) != 'H') {
								cy=atof(path)-yy;
								path=skip_num(path);
							}
							////fprintf(stderr,"\n%s",path);
							/* don't consider the second parameter of a relative curve*/
							if ((cmd == 'c')||(cmd == 'q')||(cmd == 't')) {
								curves_cnt++;
								if ((curves_cnt % 3)==1) {
									path=skip_num(path);
									path=skip_num(path);
									curves_cnt++;
									}
							} else curves_cnt=0;
							/* Lower case commands take relative coordinates */
							if (toupper(cmd)!=cmd) {
								if (cmd != 'v') cx=cx+svcx;
								if (cmd != 'h') cy=cy+svcy;
								cmd=toupper(cmd);
							}
							svcx=cx; svcy=cy;
							
							/* Scale and shift the picture */
							scale_and_shift();
							
							switch (cmd) {
								case 'M':
								case 'm':
									move_to (x,y);
									break;
								default:
									if ((oldx!=0) && (oldy!=0))
									line_to (x,y,oldx,oldy);

									if (expanded == 0) {
										if (elementcnt >= maxelements) {
											if ((area==1)||(line==1))
												fprintf(dest,"\t0x%2X,0x%02X, %s\n\t", REPEAT_COMMAND, elementcnt, destline);
											elementcnt=0;
											//sprintf(destline,"");
											destline[0]='\0';
										}
									} else {
										if (elementcnt>maxelements) {
											fprintf(dest,"\n\t");
											elementcnt=0;
										}
									}
									break;
							}
							oldx=x; oldy=y;
						}
						
						path=skip_spc(path);
					}

					close_area();
					
					if (pathdetails>0) printf("\n");
					
					inipath=0;
				}
				//xmlFree(attr);
				//free(spath);
				if (verbose==1) fprintf(stderr,"\n    Extracted %u nodes, (%u overlapping coordinates skipped)\n\n",nodecnt-skipcnt, skipcnt);

				/* keep track of absolute margins */
				if (alm>lm) alm=lm;
				if (arm<rm) arm=rm;
				if (atm>tm) atm=tm;
				if (abm<bm) abm=bm;

				if (verbose==1) fprintf(stderr,"    --Coordinate limits--");
				if (verbose==1) fprintf(stderr,"\n    left : %f",lm);
				if (verbose==1) fprintf(stderr,"\n    right : %f",rm);
				if (verbose==1) fprintf(stderr,"\n    top : %f",tm);
				if (verbose==1) fprintf(stderr,"\n    bottom : %f\n",bm);
			} /* path */

/*
			pen=nodecolor[pathcnt-1];
			fill=nodecolor[pathcnt-1];
			area=nodearea[pathcnt-1];
			line=nodeline[pathcnt-1];
*/
			node = node->next;
		
			if ((node == NULL) && (gcount>0)) {
				gcount--;
				node=gnode[gcount];
				node = node->next;
			}
		} /* node */

    fprintf(dest,"\n\n\t0x00 };\n\n\n");

	if (pathcnt > 1) {
		fprintf(stderr,"\n\nAbsolute coordinate limits:");
		fprintf(stderr,"\nleft : %f",alm);
		fprintf(stderr,"\nright : %f",arm);
		fprintf(stderr,"\ntop : %f",atm);
		fprintf(stderr,"\nbottom : %f",abm);
	}

    //(void)fcloseall();

	fprintf(stderr,"\n\n");
	if (autosize==1) {
		fclose(dest);
		autosize=2;
		fprintf(stderr,"\n------\n------\n");
		if ((arm-alm)>(abm-atm)) {
			scale=100*251/(arm-alm)/scale_divisor;
			fprintf(stderr,"Autosizing in landscape mode");
		} else {
			scale=100*251/(abm-atm)/scale_divisor;
			fprintf(stderr,"Autosizing in portrait mode");
		}
		
		//fprintf(stderr,"\n--alm: %f, atm: %f ----\n",alm,atm);
		xshift=2+scale*(xshift-alm)/100;
		yshift=2+scale*(yshift-atm)/100;
		fprintf(stderr,", SECOND PASS\n------\n------\n");

		//free (destline);
		goto autoloop;
	}

	if (excluded_nodes > 0) fprintf(stderr,"\nHidden nodes found, use '-i' to include them.\n");

	if (autosize==2) {
		fprintf(stderr,"\n------\n");
		fprintf(stderr,"Autosize summary:\n");
		fprintf(stderr,"X shift: %i\n", xshift);
		fprintf(stderr,"Y shift: %i\n", yshift);
		fprintf(stderr,"Scale factor: %f%%\n", scale);
		fprintf(stderr,"------");
	}

	fprintf(stderr,"\n\nConversion done.\n");

	xmlFreeDoc(doc);
	//(void)fcloseall();
	return(0);
}

//#endif

