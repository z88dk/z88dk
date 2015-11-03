/*
 *      Create a 32K eprom compatible to the Epson PX/HC computer family
 *      This tool handles only the compact format (similar to the one used by BASIC)
 *      to reduce the directory size at most and leave space for our executable.
 *
 *      $Id: px.c,v 1.1 2015-11-03 20:30:04 stefano Exp $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t px_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
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
    char    mybuf[20];
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


    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
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
        romimg[i]=0xe5;
    }
	
	b=0x4000;
	
	/* PROM header */
	romimg[b++]=0xe5;
	romimg[b++]=0x37;
	romimg[b++]=0x20;

	romimg[b++]=0x0F;
	romimg[b++]=0xFF;
	
	memcpy (romimg+b, header, 27);
	
	b=0x4000+0x21;
	
    suffix_change(filename,"");
	i=0;
	while ((i<8) && (filename[i])) {
        romimg[b++]=toupper(filename[i]);
		i++;
    }
	
	romimg[0x4000+22]=4;		/* directory type (4 = 0x80 bytes, 8 = 0x200 bytes) */
	
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
	romimg[b-1]=7;
	blk=0;
	while (len2 > 0) {
		if (blk==16) {
			romimg[b-1]=128;
			blk=0;
			b=0x4040;
			memcpy (romimg+b, entry_skeleton, 16);
			romimg[b++]=0;
			i=0;
			while ((i<8) && (filename[i])) {
				romimg[b++]=toupper(filename[i]);
				i++;
			}
			b=0x4050;
			for ( i = b+1; i < b+16; i++) {
				romimg[i]=0;
			}
		}
		romimg[b+blk]=blk+1;
		if (len2==0)
			len2-=896;
		else
			len2-=1024;
		blk++;
		romimg[b-1]+=8;
	}
	

		
/*	
1430:4000  E5 37 20 0F FF 48 38 30-42 41 53 49 43 20 20 20   .7 ..H80BASIC
1430:4010  20 20 20 20 20 20 04 56-31 30 30 39 31 36 38 33         .V10091683
1430:4020  00 42 41 53 49 43 20 20-20 43 4F 4D 00 00 00 80   .BASIC   COM....
1430:4030  01 02 03 04 05 06 07 08-09 0A 0B 0C 0D 0E 0F 10   ................
1430:4040  00 42 41 53 49 43 20 20-20 43 4F 4D 01 00 00 78   .BASIC   COM...x
1430:4050  11 12 13 14 15 16 17 18-19 1A 1B 1C 1D 1E 1F 00   ................
1430:4060  E5 E5 E5 E5 E5 E5 E5 E5-E5 E5 E5 E5 E5 E5 E5 E5   ................
1430:4070  E5 E5 E5 E5 E5 E5 E5 E5-E5 E5 E5 E5 E5 E5 E5 E5   ................
*/
	
	/* Load program data.. on the Epson PX the 27256 eprom halves are inverted, 
	   so let's begin at 0x4000 + the rom header and directory */
	b=0x4080;
    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        romimg[b++]=c;
		if (b>0x8000) b=0;
    }


    for ( i = 0; i < 0x8000; i++) {
        writebyte(romimg[i],fpout);
    }

    fclose(fpin);
    fclose(fpout);
    
    return 0;
}

