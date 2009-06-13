/*
 *    Convert an outfile into a padded 32k file
 *
 *    Harold O. Pinheiro - 2006 - pascal
 *    Dominic Morris - 02/06/2007 - rewritten and placed into appmake
 *
 *    $Id: sms.c,v 1.3 2009-06-13 19:16:42 dom Exp $
 *
 *    Figure out what this does exactly!
 */

#include "appmake.h"


#define OFFSET 0x7ff0

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;
static char              noop         = 0;

static unsigned char     memory[32768];
static char              signature[] = "TMR SEGA";

/* Options that are available for this module */
option_t sms_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    { 'n', "noop",     "Don't actually do anything", OPT_BOOL,  &noop },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int sms_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE        *fpin, *fpout;
    int          i;
    unsigned short checksum;
    int        len;

    if ( noop ) {
        return 0;
    }

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".tmr");
    } else {
        strcpy(filename,outfile);
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

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        myexit("Can't open output file\n",1);
    }

    memcpy(memory + OFFSET,&signature,8);
    memory[OFFSET + 8] = 0xFF;   /* Unknown */
    memory[OFFSET + 9] = 0xff;
    memory[OFFSET + 10] = 0x00;  /* Checksum */
    memory[OFFSET + 11] = 0x00;
    memory[OFFSET + 12] = 0xff;  /* Part number */
    memory[OFFSET + 13] = 0x42;
    memory[OFFSET + 14] = 0x20;  /* Version */
    memory[OFFSET + 15] = 0x4c;  /* Checksum range */

    fread(&memory[0], sizeof(memory[0]), len, fpin);

    for ( checksum = 0, i = 0; i < len; i++ ) {
        checksum += memory[i];
    }

    memory[OFFSET + 8] = checksum & 0xFF;
    memory[OFFSET + 9] = (checksum >> 8) & 0xFF;

    fwrite(&memory, sizeof(memory[0]), 32768, fpout);

    fclose(fpin);
    fclose(fpout);
    return 0;
}





