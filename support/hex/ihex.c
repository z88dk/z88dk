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
 * $Id: ihex.c,v 1.1 2001-06-26 10:36:55 dom Exp $
 */

#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#define RECSIZE 16

static void ChangeSuffix(char *name, char *suffix)
{
        int     j;
        j=strlen(name)+1;
        while (j && name[j-1] != '.' ) { j--; }

        if ( j)
               name[j-1]='\0';

        strcat(name,suffix);
}


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


int main(int argc, char *argv[])
{
    FILE *input, *output;
    char  buffer[FILENAME_MAX];
    int   address;

    if ( argc < 2 ) {
	fprintf(stderr, "Usage: %s (bin file) [org]\n" \
		"Reads in a binary file and outputs an Intel Hex Record",
		argv[0]);
	exit(1);
    }
 
    if ( argc == 3 )
	address = atoi(argv[2]);
    else
	address = 0;

    printf("%s %d\n",argv[2],address);

    if ( (input = fopen(argv[1],"rb") ) == NULL ) {
	perror("Error opening input file");
	exit(1);
    }


    strcpy(buffer,argv[1]);
    ChangeSuffix(buffer,".ihx");

    if ( (output = fopen(buffer,"w") ) == NULL ) {
	perror("Error opening output file");
	exit(1);
    } 

    bin2hex(input, output,address); 

    fclose(input); 
    fclose(output);
    exit(0);
}


