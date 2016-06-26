/*
-------------------------------------------------------------------------------
This version of bin2var has been adapted to work with the Z88DK's appmake tool.
It has been fixed to be endian-independent by Dominic Morris / Stefano Bodrato
-------------------------------------------------------------------------------

Bin2Var by David Phillips <david@acz.org>
Converts binary images to TI Graph Link format files

1.00 -- 08/22/00
* first release
* support for 83P, 8XP
strcasecmp
1.10 -- 08/23/00
* made code more modular
* added support for 82P, 86P, 86S
* fixed __MSDOS__ macro spelling to be correct

1.20 -- 08/24/00
* added suport for 85S
* corrected header for 8XP
* changed error message printing to use stderr

Edited by Jeremy Drake to create unsquished 83P and 8XP files
with correct "End" and "AsmPrgm" symbols

Edited by Thibault Duponchelle (z88dk version not bin2var) because it
was buggy at least for 8xp (due to the port to z88dk probably or maybe
the bin2var  which was used was simply an old bin2var ressource).
I'm not sure if I haven't added some other issues but I tested it and
now it works for 8xp (so it's better than before).
In fact I just have used vimdiff to correct the bugs, and not checked 
the real meaning of each written byte/word but only checked some of them).
- Tested for ti84.
- Tested for ti83 regular (squished and unsquished).
*/

#include "appmake.h"

#if !defined(__MSDOS__) && !defined(__TURBOC__)
#ifndef _WIN32
#define stricmp strcasecmp
#endif
#endif

static char             *conf_comment = NULL;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;

/* Options that are available for this module */
option_t tixx_options[] = {
{ 'h', "help",     "Display this help",          OPT_BOOL,  &help},
{ 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
{ 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
{  0,  "comment",  "File comment (42 chars)",    OPT_STR,   &conf_comment },
{  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

enum EXT { E_82P, E_83P, E_8XP, E_85S, E_86P, E_86S };

void die(const char *fmt, ...)
{
    va_list argptr;

    if (fmt)
    {
        va_start(argptr, fmt);
        vfprintf(stderr, fmt, argptr);
        va_end(argptr);
    }
    myexit(NULL,1);
}

int fsize(FILE *fp)
{
    int p, size;

    p = ftell(fp);
    fseek(fp, 0L, SEEK_END);
    size = ftell(fp);
    fseek(fp, p, SEEK_SET);

    return size;
}

void cfwritebyte(int i, FILE *fp, unsigned short *chk)
{
    writebyte((i%256),fp);
    *chk += ( i % 256 );
}


void cfwriteword(int i, FILE *fp, unsigned short *chk)
{
    writeword(i,fp);
    *chk += ( i % 256 );
    *chk += ( i / 256 );
}

void cfwrite(const void *buf, int len, FILE *fp, unsigned short *chk)
{
    int i;
    
    fwrite(buf, len, 1, fp);
    for(i = 0; i < len; i++)
        *chk += ((unsigned char *)buf)[i];
}

void writecomment(FILE *fp, const char *comment)
{
    char str[50];

    fwrite(comment, strlen(comment), 1, fp);
    memset(str, 0, 42);
    fwrite(str, 42 - strlen(comment), 1, fp);
}

void genname(const char *fname, char *name)
{
    char str[256], *c;

    strcpy(str, fname);
    c = strchr(str, '.');
    if ((c - str) > 8)
        c[8] = 0;
    else
        *c = 0;
    c = str - 1;
    do {
        c++;
        *c = toupper(*c);
        if (!isalnum(*c))
            *c = 0;
    } while (*c != 0);
    if (!strlen(str))
        die("A valid variable name could not be generated!\n");
    strcpy(name, str);
}

int tixx_exec(char *target)
{
    char  filename[FILENAME_MAX+1];
    char  comment[45];
    FILE *fp;
    char *buf, str[256];
    char *suffix;
    int i, n, ext, n2;
    unsigned short chk;

    if ( help || binname == NULL ) {
        return -1;
    }
    

    if (!stricmp(target, "ti82")) {
        ext = E_82P;
        suffix = ".82p";
    } else if (!stricmp(target, "ti83")) {
        ext = E_83P;
        suffix = ".83p";
    } else if (!stricmp(target, "ti8x")) {
        ext = E_8XP;
        suffix = ".8xp";
    } else if (!stricmp(target, "ti85")) {
        ext = E_85S;
        suffix = ".85s";
    } else if (!stricmp(target, "ti86")) {
        ext = E_86P;
        suffix = ".86p";
    } else if (!stricmp(target, "ti86s")) {
        ext = E_86S;
        suffix = ".86s";
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        /* printf("Filename : %s\n", filename); */
        suffix_change(filename,suffix);
        /* printf("Filename with suffix : %s\n", filename); */
    } else {
        strcpy(filename,outfile);
        /*printf("Filename : %s\n", filename);*/
    }

    genname(filename, str);

    if ( conf_comment != NULL ) {
        strncpy(comment,conf_comment,42);
        comment[42] = 0;
    /*printf("Commentaire : %s\n", comment); */
    } else {
        strcpy(comment, "Z88DK - bin2var v1.20");
    /*printf("Commentaire : %s\n", comment); */
    }

    fp = fopen_bin(binname, NULL);
    if (!fp)
        die("Failed to open input file: %s\n", binname);
    n = fsize(fp);
    buf = (char *)malloc(n);
    fread(buf, n, 1, fp);
    if (ferror(fp))
        die("Error reading input file: %s\n", binname);
    fclose(fp);
    fp = fopen(filename, "wb");
    if (!fp)
        die("Failed to open output file: %s\n", filename);
    chk = 0;

    if (ext == E_82P)
        fwrite("**TI82**\x1a\x0a\x00", 11, 1, fp);
    else if (ext == E_83P)
        fwrite("**TI83**\x1a\x0a\x00", 11, 1, fp);
    else if (ext == E_8XP)
        fwrite("**TI83F*\x1a\x0a\x00", 11, 1, fp);
    else if (ext == E_85S)
        fwrite("**TI85**\x1a\x0c\x00", 11, 1, fp);
    else if ((ext == E_86P) || (ext == E_86S))
        fwrite("**TI86**\x1a\x0a\x00", 11, 1, fp);

    /* COMMENT */
    writecomment(fp, comment);

    /* DATA SECTION LENGTH */
    if ((ext == E_82P) || (ext == E_83P) || (ext == E_8XP))
        i = n + 17;
    else if (ext == E_85S)
        i = n + 10 + strlen(str);
    else
        i = n + 18;
    writeword(i, fp);
    /* printf("Data Length: %04X\n", i); */


    /****************/
    /* DATA SECTION */
    /****************/

    /* VARIABLE TYPE MARKER */
    if ((ext == E_82P) || (ext == E_83P) || (ext == E_8XP))
        cfwrite("\x0b\0x00", 2, fp, &chk);
    else if (ext == E_85S)
    {
        i = 4 + strlen(str);
        cfwritebyte(i, fp, &chk);
        cfwrite("\0x00", 1, fp, &chk);
    }
    else
        cfwrite("\x0c\0x00", 2, fp, &chk);
    
    /* VARIABLE LENGTH */
    i = n + 2;    
    cfwriteword(i, fp, &chk);

    /* VARIABLE TYPE ID BYTE */
    if ((ext == E_82P) || (ext == E_83P) || (ext == E_8XP))
        cfwrite("\x06", 1, fp, &chk);
    else if (ext == E_86P)
        cfwrite("\x12", 1, fp, &chk);
    else if ((ext == E_85S) || (ext == E_86S))
        cfwrite("\x0c", 1, fp, &chk);

    /* VARIABLE NAME */
    i = strlen(str);
    if ((ext == E_85S) || (ext == E_86P) || (ext == E_86S))
        cfwritebyte(i, fp, &chk);
    cfwrite(str, i, fp, &chk);
    memset(str, 0, 8);
    if (ext != E_85S)
        cfwrite(str, 8 - i, fp, &chk);

    /* VARIABLE LENGTH */
    i = n + 2;
    n2 = n;
    cfwriteword(i, fp, &chk);
    cfwriteword(n2, fp, &chk);
    /*printf("Var Length (i) : %04X\n", i);
    printf("Var Length (n2) : %04X\n", n2); */

    cfwrite(buf, n, fp, &chk);
    writeword(chk, fp);

    if (ferror(fp))
        die("Failed writing output file: %s\n", filename);
    fclose(fp);
    free(buf);
    printf("'%s' successfully converted to '%s'\n", binname, filename);

    return 0;
}
