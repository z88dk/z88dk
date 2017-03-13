/*
 *      Short program to create a C128 header
 *
 *      This tool adds the location of the program at the beginning of the binary block
 *      and creates a BASIC loader; the two files must be put in a disk image
 *      
 *      $Id: c128.c,v 1.7 2016/06/26 aralbrec Exp, 03/2017 Stefano Exp $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              disk         = 0;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t c128_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'd', "disk",     "Create files for Disk",      OPT_BOOL,  &disk    },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin  },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int c128_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    ldrfile[FILENAME_MAX+1];
    char    tapfile[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    long    pos;
    char    mybuf[20];
    int     len,namelen;
    int     c,i;
    char   *p;
	int diskgap;

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
	
    /* strupr(filename);
       not available on all platforms */
    
    for (p = filename; *p !='\0'; ++p)
       *p = toupper(*p);

    suffix_change(filename,"");

    strcpy(ldrfile,filename);
    suffix_change(ldrfile,".LDR");

    namelen=strlen(filename)-1;

    if ( strcmp(binname,filename) == 0 ) {
        fprintf(stderr,"Input and output file names must be different\n");
        myexit(NULL,1);
    }


    if ( origin != -1 ) {
        pos = origin;
    } else {
		if ( (pos = get_org_addr(crtfile)) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
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


	if (disk) {

		/* Open binary block for disk, put start addr on top */
		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			fclose(fpin);
			myexit("Can't open output file\n",1);
		}
		writeword(pos,fpout);
		
	} else {
		
		/* Open tape file and create directory */
		strcpy(tapfile,filename);
		suffix_change(tapfile,".T64");
		if ( (fpout=fopen(tapfile,"wb") ) == NULL ) {
			myexit("Can't open output 'tape' file\n",1);
		}
		
		/* First 32 bytes, signature of the T64 file padded with $00 */
		fprintf(fpout,"C64S tape file appmake generated");
		
		writeword(0x0100,fpout);	/* tape version */
		writeword(2,fpout);			/* Maximum  number  of  entries  in  the  directory */
		writeword(2,fpout);			/* Used entries */
		writeword(0,fpout);			/* not used */
		
		/* Tape container name, padded with SPACE (24 bytes in PETSCII, no lowercase) */
		fprintf(fpout,"Z88DK COMPILED PROGRAM  ");

		/* 1st directory entry: compiled program block */
		writebyte(1,fpout);		/* normal file type */
		writebyte(2,fpout);		/* 1541 file type */
		writeword(pos,fpout);		/* start address */
		writeword(pos+len,fpout);	/* end address */
		writeword(0,fpout);		/* not used */
		writeword(0x80,fpout);	/* position in the TAP file (from the beginning) */
		writeword(0,fpout);		/* MSW for the position above */
		writeword(0,fpout);		/* not used */
		writeword(0,fpout);		/* not used */
		/* 1st directory entry name */
		for (i=0;i<16;i++)
			if (i<=namelen)
				writebyte(filename[i],fpout);
			else
					writebyte(0x20,fpout);	/* SPACEs */

		
		/* 2nd directory entry: loader block */
		writebyte(1,fpout);		/* normal file type */
		writebyte(0x82,fpout);	/* 1541 file type = PRG */
		writeword(0x1C01,fpout);     /* start address of the BASIC program */
		writeword(0x1C09+16,fpout);  /* end address of the BASIC program (line 20 omitted) */
		writeword(0,fpout);		/* not used */
		writeword(0x80+len,fpout);	/* position in the TAP file (from the beginning) */
		writeword(0,fpout);		/* MSW for the position above */
		writeword(0,fpout);		/* not used */
		writeword(0,fpout);		/* not used */
		/* 2nd directory entry name */
		for (i=0;i<16;i++)
			if (i<=namelen)
				writebyte(filename[i],fpout);
			else
				writebyte(0xA0,fpout);	/* PRG name padding */
	}
	
	/* Program block */

    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }

    fclose(fpin);
    

    /* Now let's create a loader block */
	if (disk) {
		fclose(fpout);
		if ( (fpout=fopen(ldrfile,"wb") ) == NULL ) {
			myexit("Can't create the loader file\n",1);
		}
		/* start address of the first line of the BASIC program */
		writeword(0x1C01,fpout);
	}

    /* address of the next BASIC program line */
    writeword(0x1C09,fpout);    
    /* 10 */
    writebyte(10,fpout);
    writebyte(0,fpout);
    /* BANK */
    writebyte(0xfe,fpout);
    writebyte(0x02,fpout);
    /* 0 */
    writebyte('0',fpout);
    /* end of line */
    writebyte(0,fpout);

	if (disk) {
		diskgap=12;
		/* start address of the next line of the BASIC program */
		writeword(0x1C09+diskgap+namelen,fpout);
		/* 20 */
		writebyte(20,fpout);
		writebyte(0,fpout);
		/* BLOAD */
		writebyte(0xfe,fpout);
		writebyte(0x11,fpout);
		/* "<prgname>",B0 */
		writebyte('"',fpout);
		for (i=0;i<=namelen;i++)
			writebyte(filename[i],fpout);
		writebyte('"',fpout);
		writebyte(',',fpout);
		writebyte('B',fpout);
		writebyte('0',fpout);
		/* end of line */
		writebyte(0,fpout);
	} else {
		diskgap=0;
		namelen=0;
	}
	
    /* address of the current line of the BASIC program */
    /* (it means we are in the last line)               */
    writeword(0x1C09+diskgap+namelen,fpout);
    /* 50 */
    writebyte(50,fpout);
    writebyte(0,fpout);
    writebyte(0x9e,fpout);    /* SYS */
    fprintf(fpout,"%05i",(int)pos);      /* Location for SYS */
    writebyte(':',fpout);
    writebyte(0x80,fpout);    /* END */
    writebyte(0,fpout);
    writebyte(0,fpout);
    writebyte(0,fpout);
    writebyte(0,fpout);

    fclose(fpout);


    return 0;
}



