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

static void object_dump(FILE *fp, unsigned long start, char flags);

enum { showlocal = 1, showexpr = 2 };

static void usage(char *name)
{
    fprintf(stderr,"Usage %s [-l] library\n",name);
    fprintf(stderr,"Display the contents of a z80asm library file\n");
    fprintf(stderr,"\n-l\tShow local symbols\n");
    fprintf(stderr,"-e\tShow expression patches\n");
    fprintf(stderr,"-h\tDisplay this help\n");
    exit(1);
}
    


int main(int argc, char *argv[])
{
    char    *file;
    unsigned long next,len,start;
    FILE  *fp;
    char    flags = 0;
    int     opt;

    while ((opt = getopt(argc,argv,"hle")) != -1 ) {
	switch (opt ) {
	case 'l':
	    flags |= showlocal;
	    break;
	case 'e':
	    flags |= showexpr;
	    break;
	default:
	    usage(argv[0]);
	}
    }

    if ( optind == argc ) {
	usage(argv[0]);
    }

    file = argv[optind++];
    if ( ( fp = open_library(file) ) == NULL ) {
	if ( ( fp = fopen(file,"rb")  ) != NULL ) {	   
	    object_dump(fp,0,flags);
	    exit(0);
	} else {
	    exit(1);
	}
    }


    next = 8;

    do {
	start = next + 8;
	fseek(fp,next,SEEK_SET);
	next = read_intel32(fp,NULL);
	len  = read_intel32(fp,NULL);
	if ( len == 0xFFFFFFFF ) 
	    break;
	object_dump(fp,start,flags);
    } while ( next != 0xFFFFFFFF );

    fclose(fp);
}

void object_dump(FILE *fp, unsigned long start, char flags)
{
    char     buf[8];
    unsigned long modname,expr,name,libname,code,red;
    unsigned int  org;
    char          c;
    int           len,i;

    fread(buf,8,1,fp);

    if ( strncmp(buf,"Z80RMF01",8) != 0 ) {
	return;
    }

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
	    if ( type == 'A' && ( ( flags & showlocal) || scope != 'L' ) )
		printf("  %c  ",scope);
	    for ( i = 0; i < len; i++ ) {
		c = fgetc(fp);
		if ( type == 'A' && ( (flags & showlocal) || scope != 'L' ) )
		    fputc(c,stdout);
		red++;
	    }
	    if ( type == 'A' && ( (flags & showlocal) || scope != 'L' ) ) 
		printf("\t+%04x\n",temp);
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

    if ( expr != 0xFFFFFFFF && (flags | showexpr ) ) {
	char type;
	int  patch;
	unsigned long end;
	fseek(fp,start+expr,SEEK_SET);
	red = 0;
	end = name;
	if (end == 0xFFFFFFFF )
	    end = code;
	while ( red < ( end - expr) ) {
	    type = fgetc(fp); red++;
	    patch = read_intel16(fp,&red);
	    len = fgetc(fp); red++;
	    printf("  E  ");
	    for ( i = 0; i < len; i++ ) {
		c = fgetc(fp);
		fputc(c,stdout);
		red++;
	    }
	    printf(" %c @ %04x\n",type,patch);
	    c = fgetc(fp); red++;
	    if ( c != 0 )
		break;
	}
    }

}

FILE *open_library(char *name)
{
    char    buf[9];
    FILE   *fp;

    if ( ( fp = fopen(name,"rb") ) == NULL ) {
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

    if ( offs )
	*offs += 4;

    return ( buf[3] << 24  | buf[2] << 16 | buf[1] << 8 | buf[0] );
}


static unsigned int  read_intel16(FILE *fp, unsigned long *offs)
{
    unsigned char     buf[2];

    fread(buf,1,2,fp);

    if ( offs )
	*offs += 2;

    return ( buf[1] << 8 | buf[0] );
}
