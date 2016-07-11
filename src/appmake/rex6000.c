/*
 *  Support program to produce Rex Addins
 *
 *  djm 21/6/2001 after Damjan Marion
 *
 *  $Id: rex6000.c,v 1.8 2016-07-11 20:34:58 dom Exp $
 */

#include "appmake.h"



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


static char             *application_name    = NULL;
static char             *application_comment = NULL;
static char             *binname             = NULL;
static char             *crtfile             = NULL;
static char             *outfile             = NULL;
static char              help                = 0;
static char              do_truncate         = 0;

static char             *application_name_file    = NULL;
static char             *application_comment_file = NULL;


/* Options that are available for this module */
option_t rex_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'n', "appname",  "Application Name",           OPT_STR,   &application_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    {  0, "comment",  "Application Comment",        OPT_STR,   &application_comment },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "nt",       "Don't pad out to 8k addin",  OPT_BOOL,  &do_truncate },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};
  


static void icon_form(char *name);
static char *cleanup_string(char *orig);

/* We get called with [outputfilename] [where the file is for info etc] [-nt]
 * If -nt is supplied then we don't pad out to 8k boundary 
 */

int rex_exec(char *target)
{
    char output_name[FILENAME_MAX];
    FILE *fp;
    FILE *binfile;
    long filesize;
    int  rem;
    int  i,c;

    if ( help || binname == NULL )
        return -1;


    if ( outfile == NULL ) {
        strcpy(output_name,binname);
        suffix_change(output_name,".rex");
    } else {
        strcpy(output_name,outfile);
    }
	

    icon_form(binname);

    if ( application_name == NULL ) {
        if ( application_name_file == NULL ) {
            application_name = "z88dkapp";
        } else {
            application_name = application_name_file;
        }
    }

    if ( application_comment == NULL ) {
        if ( application_comment_file == NULL ) {
            application_comment = "Made with z88dk";
        } else {
            application_comment = application_comment_file;
        }
    }

	if ( (binfile=fopen_bin(binname, crtfile) ) == NULL ) {
        fprintf(stderr,"Couldn't open binary file: %s\n",binname);
        myexit(NULL,1);
    }

    /* Now we have to do the program length */
    if (fseek(binfile, 0, SEEK_END)) {
        fclose(binfile);
        myexit("Couldn't determine the size of binary file\n",1);
    }
    filesize = ftell(binfile);

    if ( filesize > 65536L ) {
        fclose(binfile);
        myexit("The source binary is over 65,536 bytes in length\n",1);
    }

    fseek(binfile, 0, SEEK_SET);


    if ( (fp = fopen(output_name,"wb")) == NULL ) {
        fclose(binfile);
        fprintf(stderr,"Couldn't open output file: %s\n",output_name);
        myexit(NULL,1);
    }
    fprintf(fp,"ApplicationName:Addin\r\n");
    fprintf(fp,"%s\r\n",application_name);
    fprintf(fp,"%s",application_comment);
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

    if ( do_truncate == 0 ) {  /* i.e. we've been supplied with -nt, pad out to 8k  */
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
    suffix_change(name,".res");
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
            if ( strlen(ptr) ) {
                application_name_file = cleanup_string(ptr);
            }
        } else if ( strncmp(buffer,"COMMENT",7) == 0 ) {
            ptr = buffer+8;
            while ( *ptr && isspace(*ptr) )
                ptr++;
            if ( strlen(ptr) ) {
                application_comment_file = cleanup_string(ptr);
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
                myexit("Icon file too short\n",1);
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

    if ( (ptr = strchr(copy,'\n')) )
	*ptr = 0;

    if ( (ptr = strchr(copy,'\r')) )
	*ptr = 0;

    return(copy);
}




