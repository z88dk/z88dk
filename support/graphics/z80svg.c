
/*
   Z80SVG

   This program translates an SVG vector file 
   in a C source data declaration to be used
   in z88dk with the "draw_profile" function.

   $Id: z80svg.c,v 1.1 2009-11-11 07:46:44 stefano Exp $
*/


#include <stdio.h>
#include <string.h>
#include <math.h>
#include <libxml/parser.h>

#include "gfxprofile.h"

//#ifdef LIBXML_READER_ENABLED

/* Global variables */
int wireframe;
unsigned char pen;
unsigned char area;


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

/* Pick pen and area style */
void chkstyle (xmlNodePtr node)
{
	xmlChar *attr;
	char *style;

	if (wireframe != 1) {
	  attr = xmlGetProp(node, (const xmlChar *) "fill");
	  if(attr != NULL) {
			if(xmlStrcmp(attr, (const xmlChar *) "none") == 0) {
				if (area == 1) {
					area=0;
					fprintf(stderr,"\n  Back to line mode");
				}
			}
			else if(xmlStrcmp(attr, (const xmlChar *) "black") == 0) {
				area=1;
				pen=DITHER_BLACK;
				fprintf(stderr,"\n  Black area mode selected");
			}
			else if(xmlStrcmp(attr, (const xmlChar *) "white") == 0) {
				area=1;
				pen=DITHER_WHITE;
				fprintf(stderr,"\n  White area mode selected");
			}
			else if ((unsigned char)attr[0] == '#') {
				area=1;
				//convert the RGB color to a value between 11 and 0
				pen=(unsigned char) (11-11*(16*gethex((const char)attr[1])+gethex((const char)attr[2])+
				  16*gethex((const char)attr[3])+gethex((const char)attr[4])+
				  16*gethex((const char)attr[5])+gethex((const char)attr[6]))/765);
				fprintf(stderr,"\n  Area mode selected, fill dither code: %i",pen);
			}
	  }
	  xmlFree(attr);
	  if (area == 0) {
		  attr = xmlGetProp(node, (const xmlChar *) "stroke-width");
		  if(attr != NULL) {
			  pen=DITHER_BLACK+atoi((unsigned char *)attr);
		  	  fprintf(stderr,"\n  Extra pen width: %i", pen);
		  }
		  xmlFree(attr);
	  }
	}
}


int main( int argc, char *argv[] )
{
    FILE *source,*dest;
    unsigned char Dummy[100];
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
	unsigned char color=DITHER_BLACK;  /* 11 (black thin pen) is default */
	char hexval[3]="00";
	int inipath;

	xmlDocPtr doc;
	xmlNodePtr node;
	xmlChar *attr;
	xmlNodePtr gnode[100];
	unsigned int gcount=0;

	char *path;
	char *spath;
	char tmpstr[10];
	unsigned char cmd, oldcmd;
	unsigned char x,y,inix,iniy;
	unsigned char oldx, oldy;
	float svcx,svcy;

	float width, height;
	float xx,yy,cx,cy,fx,fy;
	float lm,rm,tm,bm;
	float alm,arm,atm,abm;
	unsigned int pathcnt,nodecnt,skipcnt;
	
    if ( (argc < 2) ) {
      fprintf(stderr,"\nParameter error, use 'z80svg -h' for help.\n\n");
      exit(1);
    }
    
	for (i = 1; i < argc; i++) {
	 arg = argv[i];
	 if (arg && *arg == '-') {
	   switch (arg[1]) {
	   case 'h' :
			fprintf(stderr,"\nz80svg - SVG vector format conversion tool for z88dk \n");
			fprintf(stderr,"USAGE: z80svg  [opts] <SVG file>\n");
			fprintf(stderr,"\nopts:");
			fprintf(stderr,"\n   -nSTRUCTNAME: name of the C structure being created.");
			fprintf(stderr,"\n      The default name is 'svg_picture'");
			fprintf(stderr,"\n   -oTARGET: output file name. '.h' is always added.");
			fprintf(stderr,"\n      Default is the source SVG file name with trailing '.h'.");
			fprintf(stderr,"\n   -sSCALE: optional percentage to resize the picture size.");
			fprintf(stderr,"\n   -xXSHIFT: optional top-left corner shifting, X coordinate.");
			fprintf(stderr,"\n      Negative values are allowed.");
			fprintf(stderr,"\n   -yYSHIFT: optional top-left corner shifting, Y coordinate.");
			fprintf(stderr,"\n      Negative values are allowed.");
			fprintf(stderr,"\n   -cCOLOR: Change pen color, default is black (11).");
			fprintf(stderr,"\n      (0-11) white to black, (12-15) thicker gray to black.");
			fprintf(stderr,"\n   -w: Enable wireframe mode.");
			fprintf(stderr,"\n   -p1: List path details to stdout (original float values).");
			fprintf(stderr,"\n   -p2: List path details to stdout (converted int values).");
			fprintf(stderr,"\n\n");
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
	   case 'w' :
			wireframe=1;
			break;
	   case 'p' :
			pathdetails=atoi(arg+2);
			if ((pathdetails==0)||(pathdetails>2)) {
				fprintf(stderr,"\nInvalid path detail listing option.\n");
				exit(1);
			}
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
	
	sprintf(sname,"%s", arg);

    /* Initialize the XML library */
    /* (do we really need this?) */
    LIBXML_TEST_VERSION

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

		wireframe = 0;
		width = height = 255;
		x = y = inix = iniy = 0;

		// Width
		attr = xmlGetProp(node, (const xmlChar *) "width");
		if(attr != NULL)
			width = atoi((const char *)attr);
		xmlFree(attr);
		// Height
		attr = xmlGetProp(node, (const xmlChar *) "height");
		if(attr != NULL)
			height = atoi((const char *)attr);
		xmlFree(attr);
		// X
		attr = xmlGetProp(node, (const xmlChar *) "x");
		if(attr != NULL)
			xx = atoi((const char *)attr);
		xmlFree(attr);
		// Y
		attr = xmlGetProp(node, (const xmlChar *) "y");
		if(attr != NULL)
			yy = atoi((const char *)attr);
		xmlFree(attr);

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
		node = node->xmlChildrenNode;
		// Show all nodes in the current pos
		pathcnt=0;
		while(node != NULL) {
			if(xmlStrcmp(node->name, (const xmlChar *) "g") == 0) {

				gnode[gcount]=node;
				gcount++;

				attr = xmlGetProp(node, (const xmlChar *) "id");
				fprintf(stderr,"\nEntering subnode (%u), id: %s",gcount,(const char *)attr);
				xmlFree(attr);

				pen=color;
				area=0;

				chkstyle (node);

				node = node->xmlChildrenNode;
			}
			if(xmlStrcmp(node->name, (const xmlChar *) "path") == 0) {

				pathcnt++;
				attr = xmlGetProp(node, (const xmlChar *) "id");
				fprintf(stderr,"\n  Processing path group #%u, id: %s",pathcnt,(const char *)attr);
				xmlFree(attr);

				chkstyle (node);

				attr = xmlGetProp(node, (const xmlChar *) "d");

				nodecnt=0; skipcnt=0;
				fprintf(dest,"\n\n\t/* Group #%u */\t", pathcnt);

				// Init rel margin limits (inverted)
				lm = width;
				rm = 0;
				tm = height;
				bm = 0;

				if(attr != NULL) {
					
					/* ************************* */
					/* MAIN PATH CONVERSION LOOP */
					/* ************************* */
					spath=strdup((const char *)attr);
					path=spath;
					//strtok(path," ,");
					oldx=0; oldy=0;
					svcx=0; svcy=0;

					while (strlen(path)>0) {
						path=skip_spc(path);
						cmd=*path;
						if ((isdigit(cmd))||(cmd=='-'))
							cmd=oldcmd;
						else {
							oldcmd=cmd;
							path++;
							skip_spc(path);
						}
						/* End of path block */
						if ((cmd == 'Z')||(cmd == 'z')) {
							if ( (x != inix) || (y != iniy) )
							  if (area==1)
								fprintf(dest," 0x%2X,0x%02X,0x%02X,", CMD_AREA_LINETO, inix, iniy);
							  else
								fprintf(dest," 0x%2X,0x%02X,0x%02X,", CMD_LINETO|pen, inix, iniy);
							if ((area == 1) && (inipath==1)) {
								fprintf(dest,"\n\t0x%2X,", CMD_AREA_CLOSE|pen);
							}
							inipath=0;
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
								cx=scale*(atof(path)-xx)/100;
								path=skip_num(path);
							}
							if (toupper(cmd) != 'H') {
								cy=scale*(atof(path)-yy)/100;
								path=skip_num(path);
							}
							/* don't consider the second parameter of a relative curve*/
							if ((cmd == 'c')||(cmd == 's')||(cmd == 'q')||(cmd == 't')||(cmd == 'a')) {
								path=skip_num(path);
								path=skip_num(path);
							}
							/* Lower case commands take relative coordinates */
							if (toupper(cmd)!=cmd) {
								cmd=toupper(cmd);
								if (cmd != 'V') cx=cx+svcx;
								if (cmd != 'H') cy=cy+svcy;
							}
							svcx=cx; svcy=cy;
							
							if (pathdetails==1) printf("\n%c %f %f",cmd,cx,cy);
							
							sprintf (tmpstr,"%0.f",(255*cx/width));
							fx=atof(tmpstr)+xshift;
							x=atoi(tmpstr)+xshift;
							sprintf (tmpstr,"%0.f",(255*cy/height));
							fy=atof(tmpstr)+yshift;	
							y=atoi(tmpstr)+yshift;							

							/* keep track of margins */
							if (lm>fx) lm=fx;
							if (rm<fx) rm=fx;
							if (tm>fy) tm=fy;
							if (bm<fy) bm=fy;

							//printf("|%c| 0x%02X 0x%02X",cmd, x, y);
							if (pathdetails==2) printf("\n%c %03u %03u",cmd, x, y);
							
/*
  The <path> Tag

The <path> tag is used to define a path.

The following commands are available for path data:

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

							switch (cmd) {
								case 'M':
									inipath=1;
									inix=x;
									iniy=y;
									if (area==1)
									  fprintf(dest,"\n\t0x%2X,0x%02X,0x%02X,", CMD_AREA_PLOT, x, y);
									else
									  fprintf(dest,"\n\t0x%2X,0x%02X,0x%02X,", CMD_PLOT|pen, x, y);
									break;
								default:
									if ( (x != oldx) || (y != oldy) )
									  if (area==1)
										fprintf(dest," 0x%2X,0x%02X,0x%02X,", CMD_AREA_LINETO, x, y);
									  else
									    fprintf(dest," 0x%2X,0x%02X,0x%02X,", CMD_LINETO|pen, x, y);
									else
									skipcnt++;
									//	printf (" (skipping)");
									break;
							}
							//printf ("\n");
							oldx=x; oldy=y;
						}
						
						path=skip_spc(path);
						//path=strtok(NULL," ,");
					}
					if (pathdetails>0) printf("\n");
					if ((area == 1) && (inipath==1)) {
						fprintf(dest,"\n\t0x%2X,", CMD_AREA_CLOSE|pen);
					}
					inipath=0;
				}
				xmlFree(attr);
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

	fprintf(stderr,"\n\nConversion done.\n");
}

//#endif

