/*
 *      Short program to pad a binary block and get a fixed size ROM
 *      Stefano Bodrato - Apr 2014
 *      
 *      $Id: rom.c,v 1.5 2014-05-05 07:26:37 stefano Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static char              help         = 0;
static int               filler       = 255;
static int               size         = -1;
static int               origin       = -1;
static char              ihex         = 0;


/* Options that are available for this module */
option_t rom_options[] = {
    { 'h', "help",      "Display this help",              OPT_BOOL,  &help},
    { 'b', "binfile",   "Linked binary file",             OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",    "Name of output file",            OPT_STR,   &outfile },
    { 'f', "filler",    "Filler byte (default: 0xFF)",    OPT_INT,   &filler },
    { 's', "blocksize", "ROM size to be reached",         OPT_INT,   &size },
    {  0 , "org",       "Origin of the binary",           OPT_INT,   &origin },
    {  0,  "ihex",      "Get also an iHEX version",       OPT_BOOL,  &ihex },
    {  0,  NULL,       NULL,                              OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int rom_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    int     fillsize;
    int     c,i;

    if ( help )
        return -1;

    if ( size != -1 ) {
        fillsize = size;
    } else {
        myexit("ROM block size not specified (use -s)\n",1);
    }

	if ( (ihex) && (origin == -1 )) {
		if ( ( origin = parameter_search(crtfile,".sym","myzorg") ) == -1 ) {
			fprintf(stderr,"Warning: could not get the 'myzorg' value, ORG defaults to 0\n");
			origin = 0;
		}
	}

    if ( outfile == NULL )
    {
       if ( binname == NULL )
       {
          myexit("No destination file specified\n", 1);
       }
       else
       {
          strcpy(filename,binname);
          suffix_change(filename,".rom");
       }
    }
    else
    {
        strcpy(filename,outfile);
    }

    if ( binname == NULL)
    {
       len = 0;
       fpin = NULL;
    }
    else if ( (fpin=fopen(binname,"rb") ) == NULL )
    {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }
    else if (fseek(fpin,0,SEEK_END))
    {
        fprintf(stderr,"Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL,1);
    }
    else
    {
       len=ftell(fpin);
       fseek(fpin,0L,SEEK_SET);
    }
    
    if (len > fillsize) {
        fclose(fpin);
        myexit("Your binary block does not fit in the specified ROM size\n",1);
    }

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        if (fpin != NULL) fclose(fpin);
        myexit("Can't open output file\n",1);
    }

    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }
    
    fillsize -= len;

    for ( i = 0; i < fillsize; i++)
        writebyte(filler,fpout);

    if (fpin != NULL) fclose(fpin);
    fclose(fpout);

	if (ihex) {
	  if ( (fpin=fopen(filename,"rb") ) == NULL ) {
        fprintf(stderr,"Can't open file for hex conversion  %s\n",filename);
        myexit(NULL,1);
      }
	  suffix_change(filename,".ihx");
      if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fprintf(stderr,"Can't open file for hex conversion  %s\n",filename);
        myexit(NULL,1);
      }
      bin2hex(fpin, fpout, origin); 
      fclose(fpin);
      fclose(fpout);
	}

    return 0;
}
