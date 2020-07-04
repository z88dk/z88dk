/*
 *	PMD85 tape file generator
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t pmd85_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


int pmd85_exec(char *target)
{
    char    *buf;
    char    filename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    long    pos;
    int     i;
    unsigned long cksum;
    
    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    strcpy(filename, binname);

    if ( ( fpin = fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Cannot open binary file <%s>\n",binname);
    }

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    pos = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);
    buf = must_malloc(pos);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);

    // So in bootbuf/bootlen we've got the bootstrap and in buf/pos we have the binary file
    if ( outfile != NULL ) {
        strcpy(filename, outfile);
    } else {
        suffix_change(filename, ".ptp");
    }

    if ( ( fpout = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Could not open output file <%s>\n",filename);
    }
    suffix_change(filename, "");

    writeword(63, fpout);       // Length of block
    for ( i = 0; i < 16; i++ ) {
        writebyte(0xff, fpout);
    }
    for ( i = 0; i < 16; i++ ) {
        writebyte(0x00, fpout);
    }
    for ( i = 0; i < 16; i++ ) {
        writebyte(0x55, fpout);
    }
    cksum = 0;
    writebyte_cksum(0, fpout, &cksum);       // File number
    writebyte_cksum('?', fpout, &cksum);     // File type
    writeword_cksum(0, fpout, &cksum);  // Start address
    writeword_cksum(pos - 1, fpout, &cksum); // Length -1
    // And now 8 characters of name
    for ( i = 0; i < 8; i++ ) {
        writebyte_cksum( ( i < strlen(filename) ? filename[i] : ' '), fpout, &cksum);
    }
    writebyte(cksum & 0xff, fpout);

    // And now write the bootstrap code
    writeword(pos+1, fpout);
    for ( cksum = 0, i = 0; i < pos; i++ ) {
        writebyte_cksum(buf[i], fpout, &cksum);
    }
    writebyte(cksum & 0xff, fpout);

#if 0
    // And now write the main code block
    writeword(pos, fpout);
    for ( cksum = 0, i = 0; i < pos; i++ ) {
        writebyte_cksum(buf[i], fpout, &cksum);
    }
#endif

    fclose(fpout);
    free(buf);

    return 0;
}


/*
0	16	16 times 0FFh
16	16	16 times 00h
32	16	16 times 55h
48 (0)	1	file number 0 to 99 (usually 0)
49 mm (1)	1	file type:
? - Monitor Set ( MGSV / MGLD )
> - BASIC program ( SAVE / LOAD )
D - BASIC dataset ( DSAVE / DLOAD )
P - PASCAL program
: - continuation of PASCAL source text
A - source code of DAM assembler
M - MUSICA music file
T - text "document" from KASWORD and TEXTED
X - compressed text document from KASWORD
C - compressed image from the GRED graphics editor
S - a four-by-one image from the GRED graphics editor
W - window cutout from GRED graphics editor
G - animated sprite data from GREP
other file types depend on the specific program
50 mm (2)	2	starting address (BASIC program has 2401h here )
52 (3)	2	length - 1
54 (6)	8	program name (if shorter, space must be added)
62 (13)	1	CRC: sum (modulo 256) bytes from offset 48 (0) to 61 (13)
*/
