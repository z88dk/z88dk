/*
 *      Short program to create a z88 shell program
 *
 *      This simply adds in the length of the program
 *      
 *      
 *      $Id: shellmak.c,v 1.1 2002-02-12 22:29:01 dom Exp $
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>



#define LINEMAX         80




/* Pointer to Z80 memory */
unsigned char *memory;

/* Prototypes for our functions */
void save_block(long filesize, char *base, char *ext);
long SearchParameter(char *filen, char *ext,char *target);
void usage(void);
void ChangeSuffix(char *,char *);
int myexit(char *str,int code);


/*
 * Execution starts here
 */

int main(int argc, char *argv[])
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

	/* Ignore the -nt stuff */
	if 	(argc == 4 && ( strcmp(argv[3],"-nt") == 0 ) ) {
		--argc;
	}


        if      ( argc != 3 ) 
	    usage();

        header_start = SearchParameter(argv[2],".map","HEADER_START");
        if      ( header_start == -1) 
	    myexit("Could not find parameter HEADER_START (not a Shell Compile?)\n",1);
	shell_length = SearchParameter(argv[2],".map","SHELL_LENGTH");
        if      ( shell_length == -1) 
	    myexit("Could not find parameter SHELL_LENGTH (not a Shell Compile?)\n",1);

	start = SearchParameter(argv[2],".map","START");
        if      ( shell_length == -1) 
	    myexit("Could not find parameter START (not a Shell Compile?)\n",1);

	/* allocate some memory */	
	memory=calloc( 65536 - header_start,1);
        if (memory == NULL)
                myexit("Can't allocate memory\n",1);

        binfile=fopen(argv[1], "rb");
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

	save_block(filesize,argv[1],".com");


        myexit(0,0);
}

void save_block(long filesize, char *base, char *ext)
{
        char    name[FILENAME_MAX+1];
        char    buffer[LINEMAX+1];
        int     length;
        FILE    *fp;

        strcpy(name,base);
        ChangeSuffix(name,ext);

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

/*
 * Search through debris from z80asm for some important parameters
 */

long SearchParameter(char *filen, char *ext,char *target)
{
        char    name[FILENAME_MAX+1];
        char    buffer[LINEMAX+1];
        long    val=-1;
        FILE    *fp;
/*
 * Create the filename very quickly
 */
        strcpy(name,filen);
        strcat(name,ext);
        if      ( (fp=fopen(name,"r"))==NULL) {
                sprintf(name,"Cannot open %s%s\n",filen,ext);
                myexit(name,1);
        }
/*
 * Successfully opened the file so search through it..
 */
        while (fgets(buffer,LINEMAX,fp) != NULL ) {
                if      (strncmp(buffer,target,strlen(target)) == 0 ) {
                        sscanf(buffer,"%s%s%lx",name,name,&val);
                        break;
                }
        }
        fclose(fp);
        return(val);
}


void usage(void)
{
        fprintf(stderr,"shellmak [bin file] [crt0 file]\n");
        fprintf(stderr,"(C) 12.2.2002 D.J.Morris\n");
        myexit(0,1);
}


int myexit(char *str,int code)
{
        if      (str != 0 )
                fputs(str,stderr);
        if      (memory) free(memory);
        exit(code);
}

/*
 * Generic change suffix routine - make sure name is long enough to
 * hold the suffix
 */

void ChangeSuffix(char *name, char *suffix)
{
        int     j;
        j=strlen(name)+1;
        while (j && name[j-1] != '.' ) { j--; }

        if ( j)
               name[j-1]='\0';

        strcat(name,suffix);
}

