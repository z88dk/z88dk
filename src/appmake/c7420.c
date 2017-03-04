/*
 *   Philips Videopac C7420
 *   This tool creates a BASIC loader file and a binary block file
 *   If origin is set to 35055 a special mode is entered, creating a single block.
 *
 *   Stefano Bodrato - 2015
 *
 *   $Id: c7420.c,v 1.6 2016-06-26 00:46:54 aralbrec Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t c7420_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name for the code block",   OPT_STR,   &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



int c7420_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    ldr_name[FILENAME_MAX+1];
	char	mybuf[20];
	char	lsbbuf[5];
	char	msbbuf[5];
    char    name[7];
	FILE	*fpin, *fpout;
	int  c;
	int  i;
	int  len;
    long pos;
	unsigned int   location;
    unsigned long  checksum;

    strcpy(ldr_name,"_");

    if ( (binname == NULL) && (crtfile == NULL) ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".bas");
    } else {
        strcpy(filename,outfile);
    }

	if ( strcmp(binname,filename) == 0 ) {
		fprintf(stderr,"Input and output file names must be different\n");
		myexit(NULL,1);
	}

	if ( blockname == NULL )
		blockname = binname;

	if ( origin != -1 ) {
		pos = origin;
	} else {
		if ( (pos = get_org_addr(crtfile)) == -1 ) {
			myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
		}
	}

	if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
		printf("Can't open input file %s\n",binname);
		exit(1);
	}


/*
 *	Now we try to determine the size of the file
 *	to be converted
 */
 
	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}
	
	len=ftell(fpin);
	
	fseek(fpin,0L,SEEK_SET);


 if (pos == 35055) {
/****************************/
/* Single BASIC + M/C block */
/****************************/
	strcat(ldr_name,filename);
	
	if ( (fpout=fopen(ldr_name,"wb") ) == NULL ) {
		printf("Can't create the loader file\n");
		exit(1);
	}

/* Write out the loader header  */
	for	(i=1;i<=256;i++)
		writebyte(255,fpout);
	for	(i=1;i<=10;i++)
		writebyte(0xD3,fpout);
	writebyte(' ',fpout);		/* File type ' ', BASIC program. */
	if (strlen(blockname) >= 6 ) {
		strncpy(name,blockname,6);
	} else {
		strcpy(name,blockname);
		strncat(name,"      ",6-strlen(blockname));
	}
	writestring(name,fpout);
	writebyte(0,fpout);
	writebyte('1',fpout);        /* Autorun (line 10) */
	writebyte('0',fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);

	location=0x88c1;
	writeword(location,fpout);   /* BASIC program location */
	writeword(28+13+5+len,fpout);     /* block length */
	writeword(0,fpout);			 /* checksum, offset=286 ..we'll update it at the end */


/* BASIC code */
	checksum=0;
	for	(i=1;i<=128;i++)
		writebyte(255,fpout);
	writebyte(0,fpout);
	
	location+=28;
	writeword_cksum(location,fpout,&checksum);
	writeword_cksum(10,fpout,&checksum);     /* 10   */
	writebyte_cksum(0x93,fpout,&checksum);   /* POKE */
	writebyte_cksum(0xB6,fpout,&checksum);   /* '-' */
	writestring_cksum("30757,239:",fpout,&checksum);
	writebyte_cksum(0x93,fpout,&checksum);   /* POKE */
	writebyte_cksum(0xB6,fpout,&checksum);   /* '-' */
	writestring_cksum("30756,136",fpout,&checksum);
	writebyte_cksum(0,fpout,&checksum);
	
	location+=13;
	writeword_cksum(location,fpout,&checksum);
	writeword_cksum(20,fpout,&checksum);     /* 20  */
	writebyte_cksum('R',fpout,&checksum);    /* R   */
	writebyte_cksum(0xBD,fpout,&checksum);   /* '=' */
	writebyte_cksum(0xC2,fpout,&checksum);   /* USR */
	writestring_cksum("(0):",fpout,&checksum);
	writebyte_cksum(0x9D,fpout,&checksum);   /* SCREEN */
	writebyte_cksum(0,fpout,&checksum);
	
	location+=5+len;
	writeword_cksum(location,fpout,&checksum);
	writeword_cksum(30,fpout,&checksum);     /*  30  */
	writebyte_cksum(0x8E,fpout,&checksum);   /* REM  */
	
//	writebyte_cksum(0,fpout,&checksum);
	
	/* the code tail will append the binary block and update the checksum */

 } else {
 
/****************/
/* BASIC loader */
/****************/
	sprintf(lsbbuf,"%i",(int)pos%256);	/* no more than 3 characters long */
	sprintf(msbbuf,"%i",(int)pos/256);	/* no more than 3 characters long */

	strcat(ldr_name,filename);
	
	if ( (fpout=fopen(ldr_name,"wb") ) == NULL ) {
		printf("Can't create the loader file\n");
		exit(1);
	}

/* Write out the loader header  */
	for	(i=1;i<=256;i++)
		writebyte(255,fpout);
	for	(i=1;i<=10;i++)
		writebyte(0xD3,fpout);
	writebyte(' ',fpout);		/* File type ' ', BASIC program.  Other types: 'M' (Memory block), 'S' (Screen), 'X' (strings) */
	writestring("loader",fpout);
	writebyte(0,fpout);
	/* Autorun (line 10) */
/*	writebyte(0,fpout);
	writebyte(0,fpout); */
	writebyte('1',fpout);
	writebyte('0',fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);

	location=0x88c1;
	writeword(location,fpout);    /* BASIC program location */
	writeword(16+13+22+strlen(msbbuf)+strlen(lsbbuf),fpout);       /* block length */
	writeword(0,fpout);			/* checksum, offset=286 ..we'll update it in a next step */


/* Write out the loader program */
	checksum=0;
	for	(i=1;i<=128;i++)
		writebyte(255,fpout);
	writebyte(0,fpout);
	
	location+=16;
	writeword_cksum(location,fpout,&checksum);
	writeword_cksum(10,fpout,&checksum);       /*  10 CLEAR0,<pos>:CLOAD */
	writebyte_cksum(0x98,fpout,&checksum);
	writebyte_cksum('0',fpout,&checksum);
	writebyte_cksum(',',fpout,&checksum);
	writebyte_cksum(0xB6,fpout,&checksum);     /*  negative value ('-' sign) */
	sprintf(mybuf,"%i",(int)(0x10000-pos-2));	/* always 5 characters long */
	writestring_cksum(mybuf,fpout,&checksum);
	writebyte_cksum(':',fpout,&checksum);      /* : */
	writebyte_cksum(0x99,fpout,&checksum);   /* CLOAD */
	writebyte_cksum(0,fpout,&checksum);        /* prog line termination */

	location+=22+strlen(msbbuf)+strlen(lsbbuf);
	writeword_cksum(location,fpout,&checksum);
	writeword_cksum(20,fpout,&checksum);       /*  20 POKE-30756,<MSB>:POKE-30757,<LSB> */
	writebyte_cksum(0x93,fpout,&checksum);   /* POKE */
	writebyte_cksum(0xB6,fpout,&checksum);   /* '-' */
	writestring_cksum("30757,",fpout,&checksum);
	writestring_cksum(lsbbuf,fpout,&checksum);
	writebyte_cksum(':',fpout,&checksum);      /* : */	
	writebyte_cksum(0x93,fpout,&checksum);   /* POKE */
	writebyte_cksum(0xB6,fpout,&checksum);   /* '-' */
	writestring_cksum("30756,",fpout,&checksum);
	writestring_cksum(msbbuf,fpout,&checksum);
	writebyte_cksum(0,fpout,&checksum);        /* prog line termination */
	
	location+=13;
	writeword_cksum(location,fpout,&checksum);
	writeword_cksum(30,fpout,&checksum);       /*  30 R=USR(0):SCREEN */
	writebyte_cksum('R',fpout,&checksum);
	writebyte_cksum(0xBD,fpout,&checksum);     /* '=' */
	writebyte_cksum(0xC2,fpout,&checksum);     /* USR */
	writestring_cksum("(0):",fpout,&checksum);
	writebyte_cksum(0x9D,fpout,&checksum);     /* SCREEN */
	writebyte_cksum(0,fpout,&checksum);        /* prog line termination */

	for	(i=1;i<=12;i++)
		writebyte(0,fpout);
	
	fseek(fpout,286L,SEEK_SET);
	writeword((checksum%65536),fpout);

	fclose(fpout);


/*********************/
/* Binary block file */
/*********************/

	if ( (fpout=fopen(filename,"wb") ) == NULL ) {
		printf("Can't create the data file\n");
		exit(1);
	}


/* Write out the header  */

	for	(i=1;i<=256;i++)
		writebyte(255,fpout);
	for	(i=1;i<=10;i++)
		writebyte(0xD3,fpout);
	writebyte('M',fpout);           /* File type 'M' (Memory block) */
	if (strlen(blockname) >= 6 ) {
		strncpy(name,blockname,6);
	} else {
		strcpy(name,blockname);
		strncat(name,"      ",6-strlen(blockname));
	}
	writestring(name,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);
	writebyte(0,fpout);

	writeword(pos,fpout);           /* M/C program location */
	writeword(len,fpout);           /* M/C program length */
	writeword(0,fpout);             /* checksum, offset=286 ..we'll update it in a next step */


/* Write out the data block  */

	checksum=0;
	for	(i=1;i<=128;i++)
		writebyte(255,fpout);
	
 } /* Same ending for 'single block' and 'loader' modes */

 /* We append the binary file */

	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte_cksum(c,fpout,&checksum);
	}

/* Now let's append zeroes, update checksum and close */

//	for	(i=1;i<=12;i++)
//		writebyte(0,fpout);
	
	fseek(fpout,286L,SEEK_SET);
	writeword((checksum%65536),fpout);

	fclose(fpin);
	fclose(fpout);

    return 0;
}
		

