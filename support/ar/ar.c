/*
 *  Library file snooper
 * 
 *  (C) 17/11/2002 Dominic Morris
 *
 *  Prints the contents of a z80asm library file including local symbols
 *  and dependencies of a particular library
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>


static FILE *open_library(char *name);

static unsigned long read_intel32(FILE *fp, unsigned long *offs);
static unsigned int  read_intel16(FILE *fp, unsigned long *offs);


static void usage(char *name)
{
    fprintf(stderr,"Usage %s [-l] library\n",name);
    fprintf(stderr,"Display the contents of a z80asm library file\n");
    fprintf(stderr,"\n-l\tShow local symbols\n");
    fprintf(stderr,"-h\tDisplay this help\n");
    exit(1);
}
    


int main(int argc, char *argv[])
{
    char     buf[8];
    unsigned long next,len,red,start;
    FILE  *fp;
    char    showlocal = 0;
    int     opt;

    while ((opt = getopt(argc,argv,"hl")) != -1 ) {
	switch (opt ) {
	case 'l':
	    showlocal = 1;
	    break;
	default:
	    usage(argv[0]);
	}
    }

    if ( optind == argc ) {
	usage(argv[0]);
    }


    if ( ( fp = open_library(argv[optind++]) ) == NULL ) {
	exit(1);
    }

    red = 0;
    next = 8;

    do {
	start = next + 8;
	fseek(fp,next,SEEK_SET);
	red = 0;
	next = read_intel32(fp,&red);
	len  = read_intel32(fp,&red);
	//	printf("%08x %08x\n",next,len);
	if ( len == 0xFFFFFFFF ) 
	    break;
	fread(buf,8,1,fp);
	red = 8;
	if ( strncmp(buf,"Z80RMF01",8) == 0 ) {
	    unsigned long modname,expr,name,libname,code;
	    unsigned int  org;
	    char          c;
	    int           len,i;
	    org     = read_intel16(fp,&red);
	    modname = read_intel32(fp,&red);
	    expr    = read_intel32(fp,&red);
	    name    = read_intel32(fp,&red);
	    libname = read_intel32(fp,&red);
	    code    = read_intel32(fp,&red);
	    fseek(fp,start+modname,SEEK_SET);
	    len = fgetc(fp);

	    for ( i = 0; i < len; i++ ) {
		c = fgetc(fp);
		fputc(c,stdout);
		red++;
	    }
	    fseek(fp,start+code,SEEK_SET);
	    len = read_intel16(fp,&red);
	    printf("\t\t@%08x (%d bytes)\n",start,len);
	    /* Now print any dependencies under that */
	    if ( name != 0 ) {
		char   scope,type;
		unsigned long temp;
		fseek(fp,start+name,SEEK_SET);
		red = 0;
		while ( red < ( modname - name ) ) {
		    scope = fgetc(fp); red++;
		    type = fgetc(fp); red++;
		    temp = read_intel32(fp,&red);
		    len = fgetc(fp); red++;
		    if ( type == 'A' && (showlocal || scope != 'L' ) )
			printf("  %c  ",scope);
		    for ( i = 0; i < len; i++ ) {
			c = fgetc(fp);
			if ( type == 'A' && (showlocal || scope != 'L' ) )
			    fputc(c,stdout);
			red++;
		    }
		    if ( type == 'A' && (showlocal || scope != 'L' ) ) 
			printf("\n");
		}
	    }
	    if ( libname != 0xFFFFFFFF ) {
		fseek(fp,start+libname,SEEK_SET);
		red = 0;
		while ( red < (modname - libname) ) {
		    len = fgetc(fp); red++;
		    printf("  U  ");
		    for ( i = 0; i < len; i++ ) {
			c = fgetc(fp);
			fputc(c,stdout);
			red++;
		    }
		    printf("\n");
		}

	    }	       		
	}   
    } while ( next != 0xFFFFFFFF );

    fclose(fp);
}


FILE *open_library(char *name)
{
    char    buf[9];
    FILE   *fp;

    if ( ( fp = fopen(name,"r") ) == NULL ) {
	return NULL;
    }

    fread(buf,8,1,fp);

    if ( strncmp(buf,"Z80LMF01",8) == 0 ) {
	return fp;
    }

    fclose(fp);

    return NULL;
}
    
static unsigned long read_intel32(FILE *fp, unsigned long *offs)
{
    unsigned char     buf[4];
    int      i;

    i = fread(buf,1,4,fp);


    *offs += 4;

    return ( buf[3] << 24  | buf[2] << 16 | buf[1] << 8 | buf[0] );
}


static unsigned int  read_intel16(FILE *fp, unsigned long *offs)
{
    unsigned char     buf[2];

    fread(buf,1,2,fp);

    *offs += 2;

    return ( buf[1] << 8 | buf[0] );
}
