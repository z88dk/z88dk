/*
 *      Simplified CP/M disk image creation with a single program file on it
 *      
 *      $Id: cpm.c $
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *dformat      = NULL;
static char              help         = 0;


char cpm_longhelp[] = "" \
    "Supported disk formats: DMV = NCR DecisionMate V\n";

/* Options that are available for this module */
option_t cpm_options[] = {
    { 'h', "help",      "Display this help",              OPT_BOOL,  &help},
    { 'b', "binfile",   "File to insert into disk",       OPT_STR|OPT_INPUT,  &binname },
    { 'o', "output",    "Name of output disk image file", OPT_STR|OPT_OUTPUT,  &outfile },
    { 'f', "format",    "Disk format",                    OPT_STR,   &dformat },
    {  0,  NULL,       NULL,                              OPT_NONE,  NULL }
};


/* modes */
enum {
  NONE,
  DMV
};


/*
 * Execution starts here
 */

int cpm_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
	long   len,len2;
    FILE   *fpin;
    FILE   *fpout;
    long	i,j,k;
	int		c,b;
	int		format;
	
	int		blocksize;
	int		trackpos;	/* first track # for the dst file */
    
	/* TODO: check the values for the file extent */
	char   entry_skeleton[] = {0, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'C', 'O', 'M', 1, 0, 0, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


    if ( help || binname == NULL )
        return -1;
	
	if (!dformat)
        exit_log(1,"Disk format must be specified (e.g. -f DMV).\n");
		
	format = NONE;
	if ( strncmp(dformat,"DMV",3)) {
        exit_log(1,"Invalid format.\nThe only supported format at the moment is 'DMV'.\n");
	} else {
		format = DMV;
		blocksize = 2048;
		trackpos = 2;
	}

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".raw");
    } else {
        strcpy(filename,outfile);
    }

	if ( (fpin=fopen_bin(binname, "rb") ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",binname);
	}	
    
    if ( ( fpout = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Can't open output file %s\n", filename);
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

    /* Boot area */
	if (format == DMV) {
		for (i=0; i<10; i++)
			writebyte(0xe5,fpout);
		writestring("NCR F3",fpout);
		for (i=0; i<0x6000-16; i++)
			writebyte(0xe5,fpout);
	}

    /* Directory entry */
	i=0;
	while ((i<8) && (binname[i]) && (binname[i] != '.')) {
        entry_skeleton[i+1]=toupper(binname[i]);
		i++;
    }

	/* block allocation for inserted file */
	b=0;
	for (i=0; i<len; i += blocksize)
		entry_skeleton[b+16]=(trackpos + b++);
	
	/* copy the directory */
	for (i=0; i<32; i++)
		writebyte(entry_skeleton[i],fpout);
		
    /* First gap after the directory */
	for (i=0; i<(0x2000-32); i++)
		writebyte(0xe5,fpout);

	
	len2=((len+0x1000-1)/0x1000)*0x1000;
	
	k=0;
	for (i=0; i<len2; i++) {
		for (j=0; j<0x1000; j++) {
		   c = getc(fpin);
			writebyte(c,fpout);
			i++;
			k++;
		}
		/* gap */
		for (j=0; j<0x1000; j++) {
			writebyte(0xe5,fpout);
			k++;
		}
	}
	
		
	for (i=0; i<(0x50000-0x6000-0x2000-k); i++) {
		writebyte(0xe5,fpout);
	}
	
    fclose(fpin);
    fclose(fpout);
    
    
    return 0;
}

