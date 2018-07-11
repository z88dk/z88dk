/*
 *      Create a 320KB boot disk image compatible to the Sharp MZ2500 computer family
 *
 *      $Id: mz2500.c $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t mz2500_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name for the code block",   OPT_STR,   &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* Writing routines */
void writebyte_xor(unsigned char c, FILE *fp)
{
	writebyte(c^0xff,fp);
}

void writestring_xor(char *mystring, FILE *fp)
{
    size_t c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_xor(mystring[c],fp);
    }
}

void writeword_xor(unsigned int i, FILE *fp)
{
    writebyte_xor(i%256,fp);
    writebyte_xor(i/256,fp);
}


/*
 * Execution starts here
 */

int mz2500_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    name[14];
    FILE   *fpin;
    FILE   *fpout;
    int     len,namelen;
    int     i,j,c;
    int     pos;

    if ( help )
        return -1;
	
    if ( binname == NULL || ( crtfile == NULL && origin == -1 )) {
        return -1;
    }
	
	if ( origin != -1 ) {
		pos = origin;
	} else {
		if ( (pos = get_org_addr(crtfile)) == -1 ) {
			myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
		}
	}

    if ( outfile == NULL ) {
        strcpy(filename,binname);
    } else {
        strcpy(filename,outfile);
    }
	
    //for (p = filename; *p !='\0'; ++p)
    //   *p = toupper(*p);

    suffix_change(filename,".2D");

    namelen=strlen(filename)-1;

    if ( strcmp(binname,filename) == 0 ) {
        fprintf(stderr,"Input and output file names must be different\n");
        myexit(NULL,1);
    }

	if ( blockname == NULL )
		blockname = binname;
	
	if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }
	
	suffix_change(blockname,"");

    if (fseek(fpin,0,SEEK_END)) {
        fprintf(stderr,"Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL,1);
    }

    len=ftell(fpin);
	
	fseek(fpin,0L,SEEK_SET);
	
    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        myexit("Can't open output file\n",1);
    }


	/* Disk block #0 */
	for	(i=1;i<=0x800;i++)
		writebyte_xor(0,fpout);

	/* Disk block #1 (side 1?) */
	for	(i=1;i<=0x800;i++)
		writebyte_xor(0xbf,fpout);

	/* Disk block #2 (directory) */

	writebyte_xor(1,fpout);						/* OBJ (machine language program) */
	writestring_xor("IPLPRO",fpout);			/* Boot file marker */

	if (strlen(blockname) >= 10 )			/* startup label (JIS X 0201 encoding) */
	{
		strncpy(name,blockname,10);
	} else {
		strcpy(name,blockname);
		strncat(name,"          ",10-strlen(blockname));
	}
	writestring_xor(name,fpout);
	writebyte_xor(0x0d,fpout);						/* File name termination */

	writebyte_xor(0,fpout);						/* "normal file" attribute (no protection) */
	writebyte_xor(0,fpout);						/* unused */
	
	writeword_xor(len,fpout);					/* file size */
	writeword_xor(pos,fpout);					/* load address */
	writeword_xor(pos,fpout);					/* exec address */
	
	
	writebyte_xor(0,fpout);						/* year */
	writebyte_xor(0,fpout);						/* month/day */
	writebyte_xor(0,fpout);						/* day/time */
	writebyte_xor(0,fpout);						/* time/minute */
	
	writeword_xor(0x30,fpout);					/* start sector ? */

	
	writebyte_xor(12,fpout);					/* Memory bank: 11..13 for $6000, $8000 or $A000 */
	
	writebyte_xor(0xff,fpout);
	for	(i=1;i<=14;i++)
		writebyte_xor(0,fpout);
	
	/* memory bank organization at boot */
	writebyte_xor(8,fpout);
	writebyte_xor(9,fpout);
	writebyte_xor(10,fpout);
	writebyte_xor(11,fpout);
	writebyte_xor(12,fpout);
	writebyte_xor(13,fpout);
	writebyte_xor(14,fpout);
	writebyte_xor(15,fpout);
	
	
	for	(i=1;i<=200;i++)
		writebyte_xor(0,fpout);

	/* filler */
	for	(i=1;i<=0x700+0x800;i++)
		writebyte_xor(0xbf,fpout);

	
	/* Program block */
	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte_xor(c,fpout);
	}

	/* filler */
	for	(i=1;i<=(0x50000-len-0x2000);i++)
		writebyte_xor(0,fpout);


    fclose(fpin);
    fclose(fpout);
    
    return 0;
}

