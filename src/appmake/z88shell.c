/*
 *      Short program to create a z88 shell program
 *
 *      This simply adds in the length of the program
 *      
 *      
 *      $Id: z88shell.c,v 1.1 2003-03-13 14:50:30 dom Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              truncate     = 0;
static char              help         = 0;

static unsigned char    *memory;      /* Pointer to Z80 memory */
static long              zorg;        /* Origin of compiler program */
static int               truncat = 0; /* Do we want to truncate pages? */

/* Options that are available for this module */
option_t z88shell_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* Prototypes for our functions */
void save_block(long filesize, char *base, char *ext);


/*
 * Execution starts here
 */

int z88shell_exec(char *target)
{
    int     pages;          /* size of card in banks */       
    FILE    *binfile;        /* Read in bin file */
    long    filesize;
    long    readlen;
    long    header_start;    /* Start of file */
    long    shell_length;    /* Where we dump the length */
    long    start;           /* Where we start working from */
    long    length;
    unsigned char *ptr;

    if ( help )
        return -1;

    if ( binname == NULL || crtfile == NULL ) {
        return -1;
    }

    if ( outfile == NULL )
        outfile = binname;


    header_start = parameter_search(crtfile,".map","HEADER_START");
    if      ( header_start == -1) 
        myexit("Could not find parameter HEADER_START (not a Shell Compile?)\n",1);
    shell_length = parameter_search(crtfile,".map","SHELL_LENGTH");
    if      ( shell_length == -1) 
        myexit("Could not find parameter SHELL_LENGTH (not a Shell Compile?)\n",1);

    start = parameter_search(crtfile,".map","START");
    if      ( shell_length == -1) 
        myexit("Could not find parameter START (not a Shell Compile?)\n",1);

    /* allocate some memory */        
    memory=calloc( 65536 - header_start,1);
    if (memory == NULL)
        myexit("Can't allocate memory\n",1);

    binfile=fopen(binname, "rb");
    if (binfile == NULL)
        myexit("Can't open binary file\n",1);

    if (fseek(binfile, 0, SEEK_END)) {
        fclose(binfile);
        myexit("Couldn't determine the size of the file\n",1);
    }

    filesize=ftell(binfile);
    if (filesize > 65536L ) {
        fclose(binfile);
        myexit("The source binary is over 65,536 bytes in length.\n",1);
    }

    fseek(binfile, 0, SEEK_SET);


    readlen = fread(memory,1,filesize,binfile);        

    if ( filesize != readlen ) {
        fclose(binfile);
        myexit("Couldn't read in binary file\n",1);
    }

    fclose(binfile);

    /* Get the length as required by the shell (i.e. minus the header */
    length = filesize - ( start - header_start );

    shell_length -= header_start;

    /* Write the length */
    ptr = memory + shell_length;
    *ptr++ = ( length & 255 );
    *ptr   = ( (length >> 8 ) & 255 );

    /* Save the file once more */

    save_block(filesize,outfile,".com");


    myexit(0,0);
}

void save_block(long filesize, char *base, char *ext)
{
    char    name[FILENAME_MAX+1];
    char    buffer[LINEMAX+1];
    int     length;
    FILE    *fp;

    strcpy(name,base);
    suffix_change(name,ext);

    if      ( (fp=fopen(name,"wb"))==NULL) {
        sprintf(buffer,"Can't open output file %s\n",name);
        myexit(buffer,1);
    }

    if (fwrite(memory,1,filesize,fp) != filesize ) {
        sprintf(buffer,"Can't write to output file %s\n",name);
        myexit(buffer,1);
    }
    fclose(fp);
}

