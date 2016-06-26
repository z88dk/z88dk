/*
 *      Creates ZXVGS application
 *
 *      zxvgsapp [binary file] [startup file] [-nt]
 *
 *      Yarek 7/3/2003
 */


#include "appmake.h"


/* the MAX_CHUNK is 16383 or less */
#define MAX_CHUNK       16383

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


static unsigned char *memory;             /* Pointer to Z80 memory */
static long zorg;                         /* Origin of compiler program */

/* Options that are available for this module */
option_t zxvgs_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/*
 * Execution starts here
 */

int zxvgs_exec(char *target)
{
    FILE    *binfile;        /* Read in bin file */
    FILE    *fp;
    long    filesize;
    int        readlen;        /* Amount read in */
    unsigned int        chunk;                /* chunk size */
    char    name[FILENAME_MAX+1];
    char    buffer[LINEMAX+1];
    char        header[5];        /* header to save */
    unsigned char *position;        

    if ( help )
        return -1;

    if ( binname == NULL || crtfile == NULL ) {
        return -1;
    }

    if ( outfile == NULL )
        outfile = binname;


    zorg = get_org_addr(crtfile);
    if ( zorg == -1 ) 
        myexit("Could not find parameter ZORG (compiled as BASIC?)\n",1);

    memory = calloc(1,49152L);
    if (memory == NULL)
        myexit("Can't allocate memory\n",1);

    binfile = fopen_bin(binname, crtfile);
    if ( binfile == NULL )
        myexit("Can't open binary file\n",1);

    if ( fseek(binfile, 0, SEEK_END) ) {
        fclose(binfile);
        myexit("Couldn't determine the size of the file\n",1);
    }

    filesize=ftell(binfile);
    if ( filesize > 49152L ) {
        fclose(binfile);
        myexit("The source binary is over 49152 bytes in length.\n",1);
    }

    fseek(binfile, 0, SEEK_SET);

    readlen = fread(memory,1,filesize,binfile);
    if ( filesize != readlen ) {
        fclose(binfile);
        myexit("Couldn't read in binary file\n",1);
    }
    fclose(binfile);
    
    strcpy(name,outfile);
    suffix_change(name,".V00");

    if ( ( fp = fopen(name,"wb") ) == NULL ) {
        sprintf(buffer,"Can't open output file %s\n",name);
        myexit(buffer,1);
    }
    sprintf(buffer,"Can't write to output file %s\n",name);
    header[0]=1;
    header[1]=zorg/256;
    header[2]=zorg%256;
    if (fwrite(&header,1,3,fp)!=3) myexit(buffer,1);
    position=memory;
    while (filesize>0) {          /* Writing chunk with no compression */
        chunk = ( filesize > MAX_CHUNK ) ? MAX_CHUNK : filesize;
        header[0] = 0xC0 + chunk/256;
        header[1] = chunk%256;
        if ( fwrite (&header,1,2,fp) != 2 ) 
            myexit(buffer,1);
        if ( fwrite(position,1,chunk,fp) != chunk ) 
            myexit(buffer,1);
        position += chunk;
        filesize -= chunk;
    }
    header[0] = 0;
    header[1] = zorg/256;
    header[2] = zorg%256; 
    if ( fwrite(&header,1,3,fp) != 3 ) 
        myexit(buffer,1);
    fclose(fp);

    return 0;
}



