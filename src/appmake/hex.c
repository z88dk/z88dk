/*
 * Convert a .bin file into a Intex Hex Record
 *
 * This was based on a file with the original comment:
 *
 * This is a one-night hack with NO WARRANTY WHATSOEVER.  
 * Jeff Brown, 02/08/1999
 * (If you use this code without giving me credit, you suck.)
 *
 * So there we go..
 *
 * djm 26/6/2001
 *
 * $Id: hex.c,v 1.2 2009-06-13 19:16:42 dom Exp $
 */

#include "appmake.h"



#define RECSIZE 16

static char             *binname      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t hex_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


static int checksum(const unsigned char *data, int size)
{
    int sum;
    
    sum = 0;    
    while ( size-- ) {
        sum += *data++;
        sum &= 0xff;
    }

    if (sum > 0) {
        sum = 0x100 - sum;
    }

    return(sum);    
}


static int bin2hex(FILE *input, FILE *output, int address)
{
    unsigned char outbuf[5 + RECSIZE + 1];
    unsigned char *inbuf;
    int byte;
    int size;   
    int i;

    inbuf = outbuf + 5;
    outbuf[0] = ':';
  
    do {    printf("%d\n",address);

        size = 0;
        while (size < RECSIZE) {
            byte = fgetc(input);             
	    if ( byte == EOF ) {
		break;
	    }
            inbuf[size++] = byte;
        }

        outbuf[1] = size;
        if (size > 0) {
            outbuf[2] = address >> 8;
            outbuf[3] = address & 0xff;
            outbuf[4] = 0;
        } else {
            outbuf[2] = 0;
            outbuf[3] = 0;
            outbuf[4] = 1;
        }
        outbuf[5 + size] = checksum(outbuf + 1, size + 4);

        fputc(outbuf[0], output);
        for (i=1; i<(size+6); i++) {
            fprintf(output, "%02X", outbuf[i]);
        }

        fprintf(output, "\n");
        address += size;        
    } while (!feof(input) || (size > 0));

    return(0);
}


int hex_exec(char *target)
{
    FILE *input, *output;
    char  filename[FILENAME_MAX];
    int   address;

    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".ihx");
    } else {
        strcpy(filename,outfile);
    }


    if ( origin != -1 )
        address = origin;
    else
        address = 0;

 

    if ( (input = fopen(binname,"rb") ) == NULL ) {
        perror("Error opening input file");
        myexit(NULL,1);
    }


   
    if ( (output = fopen(filename,"w") ) == NULL ) {
        perror("Error opening output file");
        myexit(NULL,1);
    } 

    bin2hex(input, output,address); 

    fclose(input); 
    fclose(output);
    exit(0);
}


