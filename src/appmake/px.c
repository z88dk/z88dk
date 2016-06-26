/*
 *      Create a 32K eprom compatible to the Epson PX/HC computer family
 *      This tool handles only the compact format (similar to the one used by BASIC)
 *      to reduce the directory size at most and leave space for our executable.
 *
 *      $Id: px.c,v 1.7 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;
static char              fullsize     = 0;


/* Options that are available for this module */
option_t px_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "32k",     "Force the 32K ROM format",  OPT_BOOL,  &fullsize},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int px_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    char    romimg[32768];
    int     len,len2,namelen;
    int     c,i;
	int     b,blk;
    char   *p;
	char   entry_skeleton[] = {0, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'C', 'O', 'M', 0, 0, 0, 1};
	char   header[] = "H80Z88DK         xV01010188";

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
    } else {
        strcpy(filename,outfile);
    }
	
    for (p = filename; *p !='\0'; ++p)
       *p = toupper(*p);

    suffix_change(filename,".ROM");

    namelen=strlen(filename)-1;

    if ( strcmp(binname,filename) == 0 ) {
        fprintf(stderr,"Input and output file names must be different\n");
        myexit(NULL,1);
    }

	if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }

    if (fseek(fpin,0,SEEK_END)) {
        fprintf(stderr,"Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL,1);
    }

    len=ftell(fpin);
	
	fseek(fpin,0L,SEEK_SET);
	
    if (len>(32768-180)) {
        fprintf(stderr,"Program is too big\n");
        fclose(fpin);
        myexit(NULL,1);
    }

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        myexit("Can't open output file\n",1);
    }

	/* init blank areas */
    for ( i = 0; i < 0x8000; i++) {
        romimg[i]=0xff;
    }
    for ( i = 0x4000; i < 0x4080; i++) {
        romimg[i]=0xe5;	/* E5 = invalid directory entry */
    }
	
	b=0x4000;
	
	/* PROM header */
	romimg[b++]=0xe5;
	romimg[b++]=0x37;	/* Identify the MAPLE format */
	romimg[b++]=32;  	/* 32K ROM capacity */

	romimg[b++]=0;  	/* checksum (system does not need it!) */
	romimg[b++]=0;

	memcpy (romimg+b, header, 27);
	
	b=0x4000+0x21;
	
    suffix_change(filename,"");
	i=0;
	while ((i<8) && (filename[i])) {
		romimg[i+0x400e]=toupper(filename[i]);
        romimg[b++]=toupper(filename[i]);
		i++;
    }
	
	/* set the number of directory entries */
	/* the count progression for entries is: ((entries/4)+1)*4    */
	romimg[0x4000+22]=4;
	
	/* Create the directory entry */
	b=0x4000+0x20;
	memcpy (romimg+b, entry_skeleton, 16);
	romimg[b++]=0;
	
	i=0;
	while ((i<8) && (filename[i])) {
        romimg[b++]=toupper(filename[i]);
		i++;
    }
	b=0x4030;
	romimg[b]=1;
    for ( i = b+1; i < b+16; i++) {
        romimg[i]=0;
    }
	
	len2=len;
	romimg[b-1]=0;
	blk=0;
	while (len2 > 0) {
		if (blk==16) {
			b=0x4040;
			memcpy (romimg+b, entry_skeleton, 16);
			romimg[b++]=0;
			i=0;
			while ((i<8) && (filename[i])) {
				romimg[b++]=toupper(filename[i]);
				i++;
			}

			b=0x4050;
			romimg[b-1]=0;
			romimg[b-4]=1;
			for ( i = b+1; i < b+16; i++) {
				romimg[i]=0;
			}
		}
		romimg[b+(blk%16)]=blk+1;
		len2-=1024;
		romimg[b-1]+=8;
		blk++;
	}
	
	/* Load program data.. on the Epson PX the 27256 eprom halves are inverted, 
	   so let's begin at 0x4000 + the rom header and directory */
	b=0x4080;
    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        romimg[b++]=c;
		if (b>=0x8000) b=0;
    }

	if ( (len > 16256) || (fullsize) ) {
		printf ("\nPreaparing a 32K ROM image (27256 EPROM)\n\n");
		for ( i = 0; i < 0x8000; i++) {
			writebyte(romimg[i],fpout);
		}
	} else {
		if (len > 8064) {
			printf ("\nProgram fits in a 16K EPROM (27128)\n\n");
			romimg[0x4002]=16;
			for ( i = 0x4000; i < 0x8000; i++) {
				writebyte(romimg[i],fpout);
			}
		} else {
			printf ("\nProgram fits in an 8K EPROM (2764)\n\n");
			romimg[0x4002]=8;
			for ( i = 0x4000; i < 0x6000; i++) {
				writebyte(romimg[i],fpout);
			}
		}
	}


    fclose(fpin);
    fclose(fpout);
    
    return 0;
}

