
/*
   Z80SVG
   by Stefano Bodrato

   This program translates an SVG vector file 
   in a C source data declaration to be used
   in z88dk with the "draw_profile" function.

   $Id: z80svg.c,v 1.8 2010-01-13 14:15:06 stefano Exp $
*/


#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <math.h>
#include <libxml/parser.h>

#include "../include/gfxprofile.h"
//#include "gfxprofile.h"

//#ifdef LIBXML_READER_ENABLED

#ifdef __MINGW32__
#define fcloseall _fcloseall
#endif

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
char *destline;
FILE *source,*dest;


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
	if(!strncmp(style, "url",3))
		return(3);
	if(!strcmp(style, "black"))
		return(DITHER_BLACK);
	else if(!strcmp(style, "white"))
		return(DITHER_WHITE);
	else if (style[0] == '#') {
		color = color_balance+(11-11*(16*gethex(style[1])+gethex(style[2])+
		  16*gethex(style[3])+gethex(style[4])+
		  16*gethex(style[5])+gethex(style[6]))/(255*3));
		if (color > 11) color=11;
		if (color < 0) color=0;
		return (color);
	  }
	else return (-1);  /* "none" */
}

/* Pick pen and area style */
void chkstyle (xmlNodePtr node)
{
	xmlChar *attr;
	int retcode;
	float opacity;
	char *style;

	  opacity = 0.6;
	  attr = xmlGetProp(node, (const xmlChar *) "fill-opacity");
	  if(attr != NULL) {
			opacity=atof((const char *)attr);
	  }
	  //xmlFree(attr);
	  attr = xmlGetProp(node, (const xmlChar *) "fill");
	  if(attr != NULL) {
			style=strdup((const char *)attr);
			retcode=get_color(style);
			free(style);
			if (retcode == -1) {
				if (area == 1) fprintf(stderr,"\n  Disabling area mode");
				area=0;
				}
			else if (opacity > 0.5) {
				area=1;
				fill=(unsigned char)retcode;
				fprintf(stderr,"\n  Area mode enabled, dither level: %i",fill);
			} else {
				if (area == 1) fprintf(stderr,"\n  Disabling area mode (too transparent)");
				area=0;
			}
	  }
	  //xmlFree(attr);
	  
	  /* Now the line properties */
	  attr = xmlGetProp(node, (const xmlChar *) "stroke-opacity");
	  if(attr != NULL) {
			opacity=atof((const char *)attr);
	  } else opacity=0;
	  //xmlFree(attr);

	  attr = xmlGetProp(node, (const xmlChar *) "stroke");
	  if(attr != NULL) {
			style=strdup((const char *)attr);
			retcode=get_color(style);
			free(style);
			
			if (opacity > 0.9) retcode=DITHER_BLACK;
			if (retcode == -1) {
				if (line == 1) fprintf(stderr,"\n  Disabling line mode");
				line=0;
				}
			else {
				line=1;
				pen=(unsigned char)retcode;
				fprintf(stderr,"\n  Line mode enabled, dither level: %i",fill);
			}
	  }
	  //xmlFree(attr);
	  if (line == 1) {
		  attr = xmlGetProp(node, (const xmlChar *) "stroke-width");
		  if(attr != NULL) {
			  pen=atoi((unsigned char *)attr);
			  if ((pen>1)&&(pen!=0)) {
				pen=DITHER_BLACK+(pen)/2;
				if (pen>15) pen=15;
				fprintf(stderr,"\n  Extra pen width: %i", pen);
			  } else pen = color;
		  } //else pen = color;
		  //xmlFree(attr);
	  }
}


void chkstyle2(xmlNodePtr node)
{
	xmlChar *attr;
	char *myattr;
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
					if (area == 1) fprintf(stderr,"\n  Disabling area mode");
					area=0;
					}
				else {
					area=1;
					fill=(unsigned char)retcode;
					fprintf(stderr,"\n  Area mode enabled, dither level: %i",fill);
				}
			}

			if (!strcmp(style,"fill-opacity")) {
				style=strtok(NULL,";:");
				opacity=atof(style);
				if (opacity <= 0.5) {
					if (area == 1) fprintf(stderr,"\n  Disabling area mode (too transparent)");
					area=0;
				}
			}

			if (!strcmp(style,"stroke-opacity")) {
				style=strtok(NULL,";:");
				stroke_opacity=atof(style);
				if ((retcode == -1) && (stroke_opacity > 0.6)) {
					fprintf(stderr,"\n  Restoring line mode");
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
					fprintf(stderr,"\n  Line mode enabled, dither level: %i",fill);
					}
				else {
					if (line == 1) fprintf(stderr,"\n  Disabling line mode");
					line=0;
				}
			}
			
			if (!strcmp(style,"stroke-width")) {
				style=strtok(NULL,";:");
				if (line == 1) {
					pen=atoi((unsigned char *)attr);
					  if ((pen>1)&&(pen!=0)) {
						pen=DITHER_BLACK+(pen)/2;
						if (pen>15) pen=15;
						fprintf(stderr,"\n  Extra pen width: %i", pen);
					  } else pen = color;
				}
			}

			style=strtok(NULL,";:");
		}
	  }
	//free(sstyle);
	//xmlFree(attr);
}



void line_to (unsigned char x,unsigned char y,unsigned char oldx,unsigned char oldy,int expanded) {
	if (expanded == 0) {
		if ((x != oldx) || (y != oldy)) {
		  if ((area==1) && (line==0))
			if (elementcnt == 0)
				sprintf(destline,"%s 0x%2X,0x%02X,0x%02X,", destline, CMD_AREA_LINETO, x, y);
			else
				sprintf(destline,"%s 0x%02X,0x%02X,", destline, x, y);
		  else if ((area==1)||(line==1))
			if (elementcnt == 0)
				sprintf(destline,"%s 0x%2X,0x%02X,0x%02X,", destline, CMD_LINETO|pen, x, y);
			else
				sprintf(destline,"%s 0x%02X,0x%02X,", destline, x, y);
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



int main( int argc, char *argv[] )
{
    unsigned char Dummy[300];
    int i,c;
    char** p = argv+1;
	char *arg;

	char stname[50]="svg_picture";
	char sname[255]="";
	char dname[255]="";
	float scale=100;
	int xshift=0;
	int yshift=0;
	int pathdetails=0;
	int wireframe=0;
	int autosize=0;
	int grouping=0;
	int rotate=0;
	int forcedmode=0;
	int expanded=0;
	int maxelements=0;
	char hexval[3]="00";
	int inipath;
	int curves_cnt;

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
	char tmpstr[10];
	unsigned char cmd, oldcmd;
	unsigned char x,y,inix,iniy;
	unsigned char oldx, oldy;
	float svcx,svcy;

	float width, height;
	float xx,yy,cx,cy,fx,fy,ax;
	float lm,rm,tm,bm;
	float alm,arm,atm,abm;
	
    if ( (argc < 2) ) {
      fprintf(stderr,"\nParameter error, use 'z80svg -h' for help.\n\n");
      exit(1);
    }

	color=DITHER_BLACK;  /* 11 (black thin pen) is default */
	color_balance=0;
    
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
			fprintf(stderr,"\n   -a: run twice and resize the picture automatically.");
			fprintf(stderr,"\n   -sSCALE: optional percentage to resize the picture size.");
			fprintf(stderr,"\n   -xXSHIFT: optional top-left corner shifting, X coordinate.");
			fprintf(stderr,"\n      Negative values are allowed.");
			fprintf(stderr,"\n   -yYSHIFT: optional top-left corner shifting, Y coordinate.");
			fprintf(stderr,"\n      Negative values are allowed.");
			fprintf(stderr,"\n   -cCOLOR: Change pen color, default is black (11).");
			fprintf(stderr,"\n      (0-11) white to black, (12-15) thicker gray to black.");
			fprintf(stderr,"\n   -bSHIFT: Adjust 'color' brightness, +/- 10.");
			fprintf(stderr,"\n   -r: Rotate the picture.");
			fprintf(stderr,"\n   -w: Enable wireframe mode.");
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
				exit(1);
			}
			sprintf(stname,"%s", arg+2);
			break;
	   case 'o' :
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid output file name\n");
				exit(1);
			}
			sprintf(dname,"%s", arg+2);
			break;
	   case 's' :
			scale=atof(arg+2);
			if (scale < 1) {
				fprintf(stderr,"\nInvalid scale value\n");
				exit(1);
			}
			break;
	   case 'x' :
			xshift=atoi(arg+2);
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid X shifting value.\n");
				exit(1);
			}
			break;
	   case 'y' :
			yshift=atoi(arg+2);
			if (strlen(arg)==2) {
				fprintf(stderr,"\nInvalid Y shifting value.\n");
				exit(1);
			}
			break;
	   case 'c' :
			color=atoi(arg+2);
			if (color > 15) {
				fprintf(stderr,"\nInvalid color.\n");
				exit(1);
			}
			break;
	   case 'l' :
			maxelements=atoi(arg+2);
			if (maxelements > 255) {
				fprintf(stderr,"\nInvalid max. number of line elements per row.\n");
				exit(1);
			}
			break;
	   case 'b' :
			color_balance=atoi(arg+2);
			if ((color_balance > 10)||(color_balance < -10)) {
				fprintf(stderr,"\nInvalid color brightness shift.\n");
				exit(1);
			}
			break;
	   case 'w' :
			wireframe=1;
			break;
	   case 'r' :
			rotate=1;
			break;
	   case 'g' :
			grouping=1;
			break;
	   case 'p' :
			pathdetails=atoi(arg+2);
			if ((pathdetails==0)||(pathdetails>2)) {
				fprintf(stderr,"\nInvalid path detail listing option.\n");
				exit(1);
			}
			break;
	   case 'f' :
			forcedmode=atoi(arg+2);
			if ((forcedmode==0)||(forcedmode>7)) {
				fprintf(stderr,"\nInvalid 'force mode' option.\n");
				exit(1);
			}
			break;
	   case 'e' :
			expanded=atoi(arg+2);
			if (expanded>2) {
				fprintf(stderr,"\nInvalid option for expanded format.\n");
				exit(1);
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
	
	if (maxelements==0)
		if (expanded == 0)
			maxelements=64;
		else
			maxelements=30;

	sprintf(sname,"%s", arg);

    /* Initialize the XML library */
    /* (do we really need this?) */
    LIBXML_TEST_VERSION

	if (autosize==1)
		fprintf(stderr,"\n------\nAutosize mode, FIRST PASS\n------\n");
autoloop:

	doc = xmlParseFile(sname);
	
	if (doc == NULL ) {
		fprintf(stderr,"Error, can't parse the source SVG file   %s\n",sname);
		return;
	}
 
 	node = xmlDocGetRootElement(doc);
	if (node == NULL) {
		fprintf(stderr,"Error empty SVG document\n");
		xmlFreeDoc(doc);
		return;
	}

	if (strlen(dname)==0) sprintf(dname,"%s", sname);
    strcpy(Dummy,dname);
    strcat(Dummy,".h");               /* add suffix .h to target name */
    if( (dest=fopen( Dummy, "wb+" )) == NULL )
    {
		fprintf(stderr,"Error, can't open the destination file   %s\n", Dummy);
		(void)fcloseall();
		exit(2);
    }
	fprintf(stderr,"\nOutput file is %s\n", Dummy);

    fprintf( dest, "\n\n\nstatic unsigned char %s[] = {  ", stname );
	if (wireframe == 0) fprintf( dest,"\n\t0x%2X,", CMD_AREA_INIT );

	if( ferror( dest ) ) {
		fprintf(stderr, "Error writing on target file:  %s\n", dname );
		(void)fcloseall();
		exit(3);
    }

 		// Check if it is an svg file
		if(xmlStrcmp(node->name, (const xmlChar *) "svg") != 0)
		{
			fprintf(stderr, "Not an svg file\n");
			xmlFreeDoc(doc);
			return 1;
		}

		destline=malloc(5000);
		width = height = 255;
		x = y = inix = iniy = 0;
		pen=color;
		fill=color;

		// Width
		attr = xmlGetProp(node, (const xmlChar *) "width");
		if(attr != NULL)
			width = atoi((const char *)attr);
		//xmlFree(attr);

		// Height
		attr = xmlGetProp(node, (const xmlChar *) "height");
		if(attr != NULL)
			height = atoi((const char *)attr);
		//xmlFree(attr);
		// X
		attr = xmlGetProp(node, (const xmlChar *) "x");
		if(attr != NULL)
			xx = atoi((const char *)attr);
		//xmlFree(attr);
		// Y
		attr = xmlGetProp(node, (const xmlChar *) "y");
		if(attr != NULL)
			yy = atoi((const char *)attr);
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
		pathcnt=0;
		inipath=0;
		while(node != NULL) {

			if(xmlStrcmp(node->name, (const xmlChar *) "g") == 0) {

				gnode[gcount]=node;
				gcount++;

				attr = xmlGetProp(node, (const xmlChar *) "id");
				if (attr == NULL)
					strcpy(Dummy,"(missing)");
				else
					sprintf(Dummy,"%s",(const char *)attr);
				fprintf(stderr,"\nEntering subnode (%u), id: %s",gcount,Dummy);
				//xmlFree(attr);

				pen=color;
				fill=color;
				area=0;
				line=1;

				if (wireframe != 1) {
					chkstyle (node);
					chkstyle2 (node);
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
				if (node->xmlChildrenNode != NULL)
					node = node->xmlChildrenNode;
				else
					fprintf(stderr," -> (empty subnode)",gcount,Dummy);
			}

			if(xmlStrcmp(node->name, (const xmlChar *) "path") == 0) {

/*				nodecolor[pathcnt]=pen;
				nodecolor[pathcnt]=fill;
				nodearea[pathcnt]=area;
				nodeline[pathcnt]=line;
*/
				pathcnt++;
				attr = xmlGetProp(node, (const xmlChar *) "id");
				if (attr == NULL)
					strcpy(Dummy,"(no name)");
				else
					sprintf(Dummy,"%s",(const char *)attr);
				fprintf(stderr,"\n  Processing path group #%u, id: %s",pathcnt,Dummy);
				//xmlFree(attr);

				if (wireframe != 1) {
					chkstyle (node);
					chkstyle2 (node);
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
					oldx=0; oldy=0;
					svcx=0; svcy=0;

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
								line_to (inix,iniy,oldx,oldy,expanded);

							if (pathdetails>0) printf("\n%c", cmd);
							if (strlen(path)>0) {
								//oldcmd=*path;
								path++;
								skip_spc(path);
							}
						} else {
							nodecnt++;
							/* Vertical and Horizontal lines take 1 parameter only */
							if (toupper(cmd) != 'V') {
								cx=cy=atof(path)-xx;
								path=skip_num(path);
							}
							if (toupper(cmd) != 'H') {
								cy=atof(path)-yy;
								path=skip_num(path);
							}
							////fprintf(stderr,"\n%s",path);
							/* don't consider the second parameter of a relative curve*/
							if ((cmd == 'c')||(cmd == 's')||(cmd == 'q')||(cmd == 't')||(cmd == 'a')) {
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
							/* Now scale and shift the picture */
							cx=(scale*(cx-xx)/100);
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
							
							switch (cmd) {
								case 'M':
								case 'm':
									if ((expanded==0)&&(elementcnt > 0))
										if ((area==1)||(line==1))
											fprintf(dest,"\t0x%2X,0x%02X, %s\n", REPEAT_COMMAND, elementcnt, destline);
									elementcnt=0;
									sprintf(destline,"");
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
									break;
								default:
									if ((oldx!=0) && (oldy!=0))
									line_to (x,y,oldx,oldy,expanded);

									if (expanded == 0) {
										if (elementcnt >= maxelements) {
											if ((area==1)||(line==1))
												fprintf(dest,"\t0x%2X,0x%02X, %s\n\t", REPEAT_COMMAND, elementcnt, destline);
											elementcnt=0;
											sprintf(destline,"");
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

					if ((expanded == 0)&&(elementcnt>0))
						if ((area==1)||(line==1))
							fprintf(dest,"\t0x%2X,0x%02X, %s\n\t", REPEAT_COMMAND, elementcnt, destline);

					if ((area == 1) && (inipath==1)) {
						fprintf(dest,"\t0x%2X,\n", CMD_AREA_CLOSE|fill);
					}

					if (pathdetails>0) printf("\n");
						
					inipath=0;
				}
				//xmlFree(attr);
				//free(spath);
				fprintf(stderr,"\n    Extracted %u nodes, (%u ovelaps skipped)\n",nodecnt-skipcnt, skipcnt);

				/* keep track of absolute margins */
				if (alm>lm) alm=lm;
				if (arm<rm) arm=rm;
				if (atm>tm) atm=tm;
				if (abm<bm) abm=bm;

				fprintf(stderr,"    --Coordinate limits--");
				fprintf(stderr,"\n    left : %f",lm);
				fprintf(stderr,"\n    right : %f",rm);
				fprintf(stderr,"\n    top : %f",tm);
				fprintf(stderr,"\n    bottom : %f\n",bm);
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

    (void)fcloseall();

	if (autosize==1) {
		autosize=2;
		fprintf(stderr,"\n\n\n------\nAutosize mode, SECOND PASS\n------\n");
		if ((arm-alm)>(abm-atm)) {
			scale=100*255/(arm-alm);
			fprintf(stderr,"Autosizing in landscape mode (max x = 255)\n");
		} else {
			scale=100*255/(abm-atm);
			fprintf(stderr,"Autosizing in portrait mode (max y = 255)\n");
		}
		xshift=scale*(xshift-alm)/100;
		yshift=scale*(yshift-atm)/100;
		fprintf(stderr,"\n------\n------\n");

		free (destline);
		goto autoloop;
	}

	if (autosize==2) {
		fprintf(stderr,"\n------\n");
		fprintf(stderr,"Autosize summary:\n");
		fprintf(stderr,"X shift: %i\n", xshift);
		fprintf(stderr,"Y shift: %i\n", yshift);
		fprintf(stderr,"Scale factor: %f%%\n", scale);
		fprintf(stderr,"------");
	}

	fprintf(stderr,"\n\nConversion done.\n");
}

//#endif

