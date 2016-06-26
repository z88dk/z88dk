/*
 *      Short program to create a residos package
 *
 *      This simply adds in the length of the program
 *      
 *      
 *      $Id: residos.c,v 1.4 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"


#define HEADER_SIZE    16

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;

static unsigned char    *memory;      /* Pointer to Z80 memory */

/* Options that are available for this module */
option_t residos_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* Prototypes for our functions */
static void save_block(long filesize, char *base, char *ext);


/*
 * Execution starts here
 */

int residos_exec(char *target)
{ 
    FILE    *binfile;        /* Read in bin file */
    long    filesize;
    long    readlen;
    long    table_start;
    long    table_end;
    long    package_id;
    
    if ( help ) {
        return -1;
    }

    if ( binname == NULL || crtfile == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        outfile = binname;
    }

    table_start = parameter_search(crtfile,".map","package_call_table");
    table_end = parameter_search(crtfile,".map","package_call_end");
    package_id = parameter_search(crtfile,".map","residos_package_id");

    if ( table_start == -1 ) {
        myexit("Could not find parameter package_call_table (not a Residos package compile?)\n",1);
    }
    if ( table_end == -1 ) {
        myexit("Could not find parameter package_call_end (not a Residos package compile?)\n",1);
    }
     if ( package_id == -1 ) {
        myexit("Could not find parameter residos_package_id (not a Residos package compile?)\n",1);
    }   

    if ( (binfile=fopen_bin(binname, crtfile) ) == NULL ) {
        myexit("Can't open binary file\n",1);
    }

    if (fseek(binfile, 0, SEEK_END)) {
        fclose(binfile);
        myexit("Couldn't determine the size of the file\n",1);
    }

    filesize=ftell(binfile);
    
    if (filesize > 0x3fc0 ) {
        fclose(binfile);
        myexit("The source binary is over 16,320 bytes in length.\n",1);
    }
    
    if ( ( memory = calloc(16384, 1) ) == NULL ) {
        myexit("Can't allocate memory\n",1);
    }
    
    
    /* Basic header size is 16:
        
    defm    "ZXPKG"                 ; magic identifier
    defb    TESTPKG_CAPS            ; capabilities bitmask
    defb    TESTPKG_ID              ; package ID
    defw    TESTPKG_MIN_RESIDOS     ; minimum ResiDOS version required
    defb    TESTPKG_MAX_CALL_ID     ; highest call ID provided
    defw    TESTPKG_CALL_TABLE      ; address of package call table
        
    defb    0  ; Hook code terminator
    defb    0  ; channel name terminator
    defb    0  ; end of syntax table
    defb    0  ; end of function table
        
    // Binary blob
    */
    
    strcpy(memory,"ZXPKG");
    memory[5] = 0;  /* Capabilities */
    memory[6] = package_id;
    memory[7] = 0x23;    /* Minimum Residos version is v2.23 */
    memory[8] = 0x02;
    memory[9] = (table_end - table_start) / 2;
    memory[10] = table_start % 256;
    memory[11] = table_start / 256;
    memory[12] = 0; /* Hook code terminator */
    memory[13] = 0; /* Channel name terminator */
    memory[14] = 0; /* Syntax table terminator */
    memory[15] = 0; /* Function table terminator */
    fseek(binfile, 0, SEEK_SET);
    readlen = fread(memory + HEADER_SIZE,1,filesize,binfile);        

    if ( filesize != readlen ) {
        fclose(binfile);
        myexit("Couldn't read in binary file\n",1);
    }

    fclose(binfile);

    save_block(filesize + HEADER_SIZE,outfile,".com");

    myexit(0,0);
	return 0;
}

void save_block(long filesize, char *base, char *ext)
{
    char    name[FILENAME_MAX+1];
    char    buffer[LINEMAX+1];
    FILE    *fp;

    strcpy(name,base);
    suffix_change(name,ext);

    if ( (fp=fopen(name,"wb"))==NULL) {
        snprintf(buffer,sizeof(buffer),"Can't open output file %s\n",name);
        myexit(buffer,1);
    }

    if (fwrite(memory,1,filesize,fp) != filesize ) {
        snprintf(buffer,sizeof(buffer),"Can't write to output file %s\n",name);
        myexit(buffer,1);
    }
    fclose(fp);
}

