/*
 *	Library file snooper
 * 
 *	(C) 17/11/2002 Dominic Morris
 *
 *	Prints the contents of a z80asm library file including local symbols
 *	and dependencies of a particular library
 *
 *  $Id: ar.c,v 1.12 2013-12-10 23:56:11 pauloscustodio Exp $
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>
#include <assert.h>

static FILE *open_library(char *filename);

static unsigned long read_intel32(FILE *fp, unsigned long *offs);
static unsigned int  read_intel16(FILE *fp, unsigned long *offs);
static void          read_name(FILE *fp, unsigned long *offs, FILE *out);

static void object_dump(FILE *fp, char *filename, unsigned long start, char flags);

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
	char	*file;
	unsigned long next,len,start;
	FILE  *fp;
	char	flags = 0;
	int 	opt;

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

	while ( optind < argc ) {
		file = argv[optind++];
		if ( ( fp = open_library(file) ) == NULL ) {
			if ( ( fp = fopen(file,"rb")  ) != NULL ) { 	   
				object_dump(fp,file,0,flags);
			} else {
				fprintf(stderr,"File %s: cannot open\n",file);
			}
		}
		else {
			next = 8;

			do {
				start = next + 8;
				fseek(fp,next,SEEK_SET);
				next = read_intel32(fp,NULL);
				len  = read_intel32(fp,NULL);
				if ( len == 0xFFFFFFFF ) 
					break;
				if ( len == 0x0 )
					printf("Deleted...");
				object_dump(fp,file,start,flags);
			} while ( next != 0xFFFFFFFF );

			fclose(fp);
		}
		printf("\n");
	}
}

static char *patch_type(int type)
{
	switch ( type ) {
	case 'U':
		return "8U";
	case 'S':
		return "8S";
	case 'C':
		return "16S";
	case 'L':
		return "32S";
		break;
	}
	return "??";
}

void object_dump(FILE *fp, char *filename, unsigned long start, char flags)
{
	char	 buf[9];
	unsigned long modname,expr,symbols,externsym,code,red;
	unsigned int  org;
	char		  c;
	int 		  len;

	fread(buf,8,1,fp); buf[8] = '\0';

	if ( strcmp(buf,"Z80RMF01") != 0 &&
	     strcmp(buf,"Z80RMF02") != 0 ) {
		fprintf(stderr,"File %s: not object file\n",filename);
		return;
	}

	org 	  = read_intel16(fp,&red);
	modname   = read_intel32(fp,&red);
	expr	  = read_intel32(fp,&red);
	symbols	  = read_intel32(fp,&red);
	externsym = read_intel32(fp,&red);
	code	  = read_intel32(fp,&red);

	fseek(fp,start+modname,SEEK_SET);
	read_name(fp,&red,stdout);

	if ( code != 0xFFFFFFFF ) {
		fseek(fp,start+code,SEEK_SET);
		len = read_intel16(fp,&red);
		if (len == 0)
			len = 0x1000;
	}
	else {
		len = 0;
	}

	printf("\t\t%s: %s @ %08x (%d bytes)\n",buf,filename,start,len);


	/* Now print any dependencies under that */
	if ( symbols != 0xFFFFFFFF ) {
		char   scope,type;
		unsigned long value;
		unsigned long end;

		if ( externsym == 0xFFFFFFFF ) {
			end = modname;
		} else {
			end = externsym;
		}
		
		fseek(fp,start+symbols,SEEK_SET);
		red = 0;
		while ( symbols + red < end ) {
			scope = fgetc(fp); red++;
			type = fgetc(fp); red++;
			value = read_intel32(fp,&red);
			if ( ( ( flags & showlocal) || scope != 'L' ) ) {
				printf("  %c%c ",scope, type == 'C' ? 'C' : ' ' );
				read_name(fp,&red,stdout);
				printf("\t+%04x\n",value);
			}
			else {
				read_name(fp,&red,NULL);
			}
		}
	}
		
	if ( externsym != 0xFFFFFFFF ) {
		fseek(fp,start+externsym,SEEK_SET);
		red = 0;
		while ( red < (modname - externsym) ) {
			printf("  U  ");
			read_name(fp,&red,stdout);
			printf("\n");
		}
	}

	if ( expr != 0xFFFFFFFF && (flags & showexpr ) ) {
		char type;
		int  patch;
		unsigned long end;
		fseek(fp,start+expr,SEEK_SET);
		red = 0;
		end = symbols   != 0xFFFFFFFF ? symbols   :
			  externsym != 0xFFFFFFFF ? externsym :
			  modname;
		while ( red < ( end - expr) ) {
			type = fgetc(fp); red++;
			patch = read_intel16(fp,&red);
			printf("  E  ");
			read_name(fp,&red,stdout);
			printf("\t%c(%s) @ %04x\n",type,patch_type(type),patch);
			c = fgetc(fp); red++;
			assert(c == 0);
		}
	}
}

FILE *open_library(char *filename)
{
	char	buf[9];
	FILE   *fp;

	if ( ( fp = fopen(filename,"rb") ) == NULL ) {
		return NULL;
	}

	fread(buf,8,1,fp); buf[8] = '\0';

	if ( strcmp(buf,"Z80LMF01") == 0 ||
	     strcmp(buf,"Z80LMF02") == 0 ) {
		printf("%s: %s\n",buf,filename);
		return fp;
	}

	fclose(fp);

	return NULL;
}
	
static unsigned long read_intel32(FILE *fp, unsigned long *offs)
{
	unsigned char	  buf[4];
	int 	 i;

	i = fread(buf,1,4,fp);

	if ( offs )
		*offs += 4;

	return ( buf[3] << 24  | buf[2] << 16 | buf[1] << 8 | buf[0] );
}


static unsigned int  read_intel16(FILE *fp, unsigned long *offs)
{
	unsigned char	  buf[2];

	fread(buf,1,2,fp);

	if ( offs )
		*offs += 2;

	return ( buf[1] << 8 | buf[0] );
}

static void read_name(FILE *fp, unsigned long *offs, FILE *out)
{
	int len, i, c;

	len = fgetc(fp); (*offs)++;
	for ( i = 0; i < len; i++ ) {
		c = fgetc(fp);
		if (out != NULL)
			fputc(c,out);
		(*offs)++;
	}
}

/*
 * $Log: ar.c,v $
 * Revision 1.12  2013-12-10 23:56:11  pauloscustodio
 * Update to new object file format Z80RMF02, Z80LMF02 (C-type expressions in z80asm).
 * Factor reading of names.
 * Show file name and file version in dump.
 * Accept more that one file in command line.
 * Buffer overrun reading file signature - solved.
 * Renamed variable names to match object file docs.
 * Handle special case: no code in file.
 * Handle special case: 64K code block.
 * Condition for printing symbols was wrong.
 * End condition for printing expressions was wrong.
 *
 *
 */