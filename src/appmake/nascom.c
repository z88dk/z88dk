/*
 *	BIN to NASCOM HEX FORMAT
 *	This file is part of the Z88DK project
 *
 *	Stefano Bodrato 30/5/2003
 *
 *	$Id: nascom.c,v 1.6 2016-08-05 07:04:10 stefano Exp $
 */


#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


option_t nascom_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



static void    writehex(unsigned int,FILE *);
static void    writehexword(unsigned int,FILE *);

int nascom_exec(char *target)
{
    char    filename[FILENAME_MAX+1];   
    FILE   *fpin, *fpout;
    int        c;
    int        i;
    int        len;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".nas");
    } else {
        strcpy(filename,outfile);
    }

    if ( crtfile == NULL && origin == -1) {
        origin = 0x1000;
    } else {
		if ( origin == -1 ) {
			if ( (origin = get_org_addr(crtfile)) == -1 ) {
				myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
			}
		}
	}


	if ( (fpin=fopen_bin(binname, NULL) ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }

/*
 *        Now we try to determine the size of the file
 *        to be converted
 */
    if (fseek(fpin,0,SEEK_END)) {
        fprintf(stderr,"Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL,1);
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);




    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        myexit("Can't open output file\n",1);
        exit(1);
    }

    writehexword(origin,fpout);

    for (i=0; i<len;i++) {
        if ((i>0) && ((i%8)==0)) {
            fprintf(fpout, "%c%c\n",8,8);
            writehexword(origin,fpout);
        }
        c=getc(fpin);
        fputc(' ',fpout);
        writehex(c,fpout);
        origin++;
    }

    /* Padding the last 8 bytes block*/
    if ( (i % 8) != 0 ) {
        while ( (i % 8) != 0 ) {
            fprintf(fpout, " 00");
            i++;
        }
        fprintf(fpout, "%c%c\n",8,8);
    }
    fprintf(fpout, ".\n");

    fclose(fpin);
    fclose(fpout);
    return 0;
}



void writehex(unsigned int i,FILE *fp)
{
    if (i/16>9)
        fputc ((i/16)+55,fp);
	else
        fputc ((i/16)+48,fp);

    if (i%16>9)
        fputc ((i%16)+55,fp);
    else
        fputc ((i%16)+48,fp);
}

void writehexword(unsigned int i,FILE *fp)
{
    writehex(i/256,fp);
    writehex(i%256,fp);
}
