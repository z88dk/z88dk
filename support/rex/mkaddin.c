/*
 *  Support program to produce Rex Addins
 *
 *  djm 21/6/2001 after Damjan Marion
 *
 *  $Id: mkaddin.c,v 1.1 2001-06-21 09:56:29 dom Exp $
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


static char  icon[5*32];

/* Yes, this icon is stolen from the other Rex SDK */

static char  icon_default [5*32] = {
    0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0xfe,0x60,0x00,
    0x00,0x03,0xf7,0xe0,0x00,
    0x00,0x0f,0xc1,0xc0,0x00,
    0x00,0x1f,0x80,0xc0,0x00,
    0x00,0x3f,0x00,0xc0,0x00,
    0x00,0x3e,0x00,0xc0,0x00,
    0x00,0x7e,0x00,0x00,0x00,
    0x00,0x7c,0x00,0x00,0x00,
    0x00,0xfc,0x00,0x00,0x00,
    0x00,0xfc,0x00,0x00,0x00,
    0x00,0xf8,0x00,0x00,0x00,
    0x00,0xf8,0x00,0x0c,0x00,
    0x00,0xf8,0x00,0x10,0x00,
    0x00,0xf8,0x00,0x38,0x00,
    0x00,0x7c,0x03,0x13,0x2c,
    0x00,0x7c,0x06,0x14,0xb0,
    0x00,0x3f,0x3c,0x14,0xa0,
    0x00,0x1f,0xf8,0x14,0xa0,
    0x00,0x07,0xe0,0x13,0x20,
    0x00,0x00,0x00,0x00,0x00,
    0x0f,0xe0,0x7f,0xfc,0x7c,
    0x0f,0xfc,0x7f,0xbe,0xf8,
    0x0f,0xfc,0xff,0x9e,0xf0,
    0x1f,0x3c,0xf0,0x1f,0xe0,
    0x1f,0x3c,0x0f,0x0b,0xc0,
    0x1e,0x00,0x1f,0x01,0x80,
    0x1e,0xf1,0xe0,0x1b,0xc0,
    0x3e,0xf1,0xff,0x3f,0xe0,
    0x3c,0x7b,0xfe,0x7d,0xf0,
    0x3c,0x7b,0xfe,0xf8,0xf8,
    0x00,0x00,0x00,0x00,0x00 };


  


static char *application_name = "z88dkapp";

static char *comment = "Made with z88dk";

static int truncate = 0;

static void ChangeSuffix(char *name, char *suffix);
static void icon_form(char *name);
static char *cleanup_string(char *orig);

/* We get called with [outputfilename] [where the file is for info etc] [-nt]
 * If -nt is supplied then we don't pad out to 8k boundary 
 */

int main(int argc, char *argv[])
{
    char output_name[FILENAME_MAX];
    FILE *fp;
    FILE *binfile;
    long filesize;
    int  rem;
    int  i,c;

    truncate = 0;

    if      (argc == 4 && ( strcmp(argv[3],"-nt") == 0 ) ) {
#ifndef MSDOS
	truncate=1;
#else
	fputs("-nt option not supported under MSDOS..continuing\n",stderr);
#endif
	--argc;
    }

    if ( argc != 3 ) {
	fprintf(stderr,"mkaddin [bin file] [ignored] [-nt]\n");
	fprintf(stderr,"(C) 21.6.2001 djm/dm - part of z88dk\n");
	fprintf(stderr,"This program should be called via zcc\n");
	exit(1);
    }
	

    /* First thing, read in resource file which contains name, comment
     * and icon etc
     */
    icon_form(argv[1]);
    


    if ( (binfile = fopen(argv[1],"rb")) == NULL ) {
	fprintf(stderr,"Couldn't open binary file: %s\n",argv[1]);
	exit(1);
    }

    /* Now we have to do the program length */
    if (fseek(binfile, 0, SEEK_END)) {
	fclose(binfile);
	fprintf(stderr,"Couldn't determine the size of binary file\n");
	exit(1);
    }
    filesize = ftell(binfile);

    if ( filesize > 65536L ) {
	fclose(binfile);
	fprintf(stderr,"The source binary is over 65,536 bytes in length\n");
	exit(1);
    }

    fseek(binfile, 0, SEEK_SET);

    strcpy(output_name,argv[1]);

    ChangeSuffix(output_name,".rex");


    if ( (fp = fopen(output_name,"wb")) == NULL ) {
	fprintf(stderr,"Couldn't open output file: %s\n",output_name);
	fclose(binfile);
	exit(1);
    }
    fprintf(fp,"ApplicationName:Addin\r\n");
    fprintf(fp,"%s\r\n",application_name);
    fprintf(fp,"%s",comment);
    fputc( 0, fp);
    /* Now write out the program length, little endian */
    fputc( filesize%256, fp);
    fputc( filesize/256, fp);
    /* Now two bytes that I'm not sure what they do.. */
    fputc( 0, fp);
    fputc( 0, fp);
    /* Now write the icon out */
    for (i=0; i<sizeof(icon); i++ ) {
	fputc( icon[i], fp );
    }
    /* Yawn, copy the file byte by byte, slow, but sure! */
    for (i=0; i<filesize; i++ ) {
	c = fgetc(binfile);
	fputc (c, fp);
    }

    if ( truncate == 0 ) {  /* i.e. we've been supplied with -nt, pad out to 8k  */
	rem = 8192 - (filesize % 8192);
	for (i = 0; i < rem ; i++ ) {
	    fputc( 0, fp );
	}
    }
    fclose(binfile);
    fclose(fp);
    exit(0);
}
			  

/* Form an icon, put at buffer, if filename not exist then use default */

static void icon_form(char *filen)
{
    char name[FILENAME_MAX];
    char buffer[160];
    char *ptr;
    int i,b,r,c,j;
    FILE *fp;


    strcpy(name,filen);
    ChangeSuffix(name,".res");
    fp = fopen(name,"r");
    if ( fp == NULL ) {
	memcpy(icon,icon_default,sizeof(icon));
	return;
    }

    while  ( 1 ) {
	if ( fgets(buffer,sizeof(buffer),fp) == NULL ) {
	    fclose(fp);
	    return;
	}
	if ( strncmp(buffer,"APPNAME",7) == 0 ) {
	    ptr = buffer+8;
	    while ( *ptr && isspace(*ptr) )
		ptr++;
	    printf(ptr);
	    if ( strlen(ptr) ) {
		application_name = cleanup_string(ptr);
	    }
	} else if ( strncmp(buffer,"COMMENT",7) == 0 ) {
	    ptr = buffer+8;
	    while ( *ptr && isspace(*ptr) )
		ptr++;
	    printf(ptr);
	    if ( strlen(ptr) ) {
		comment = cleanup_string(ptr);
	    }
	} else if ( strncmp(buffer,"ICON",4) == 0 ) {
	    break;
	}
    }
    for (i=0; i<sizeof(icon); i++) {
	b = 128;
	r = 0;
	j = 0;
	while ( j < 8 ) {
	    c = fgetc(fp);

	    if ( c == EOF ) {
		fprintf(stderr,"Icon file short\n");
		exit(1);
	    }
	    if ( c == '\n' || c=='\r')
		continue;
	    if ( c == 'X' ) 
		r += b;
	    b /= 2;
	    j++;
	}
	icon[i] = r;
    }
    fclose(fp);
}

char *cleanup_string(char *orig)
{
    char  *copy;
    char  *ptr;

    copy = strdup(orig);

    if ( ptr = strchr(copy,'\n') )
	*ptr = 0;

    if ( ptr = strchr(copy,'\r') )
	*ptr = 0;

    return(copy);
}





/*
 * Generic change suffix routine - make sure name is long enough to
 * hold the suffix
 */

static void ChangeSuffix(char *name, char *suffix)
{
        int     j;
        j=strlen(name)+1;
        while (j && name[j-1] != '.' ) { j--; }

        if ( j)
               name[j-1]='\0';

        strcat(name,suffix);
}
