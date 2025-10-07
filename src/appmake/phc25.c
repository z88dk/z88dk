#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


static void write_header(FILE *fpout, char *name);

/* Options that are available for this module */
option_t phc25_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


// BASIC token numbers
typedef enum {
    TOK_END = 0x80,
    TOK_FOR,
    TOK_NEXT,
    TOK_DATA,
    TOK_INPUT,
    TOK_DIM,
    TOK_READ,
    TOK_LET,
    TOK_GOTO,
    TOK_RUN,
    TOK_IF,
    TOK_RESTORE,
    TOK_GOSUB,
    TOK_RETURN,
    TOK_REM,
    TOK_STOP,
    TOK_OUT,
    TOK_ON,
    TOK_LPRINT,
    TOK_DEF,
    TOK_POKE,
    TOK_PRINT,
    TOK_CONT,
    TOK_LIST,
    TOK_LLIST,
    TOK_CLEAR,
    TOK_COLOR,
    TOK_PSET,
    TOK_PRESET,
    TOK_LINE,
    TOK_PAINT,
    TOK_SCREEN,
    TOK_CLS,
    TOK_LOCATE,
    TOK_CONSOLE,
    TOK_CLOAD,
    TOK_CSAVE,
    TOK_EXEC,
    TOK_SOUND,
    TOK_PLAY,
    TOK_KEY,
    TOK_LCOPY,
    TOK_NEW,
    TOK_CTON,
    TOK_CTOFF,
    TOK_SLOAD,
    TOK_SSAVE,
    TOK_ELSE,
    TOK_undoc1,
    TOK_undoc2,
    TOK_undoc3,
    TOK_undoc4,
    TOK_undoc5,
    TOK_undoc6,
    TOK_undoc7,
    TOK_undoc8,
    TOK_undoc9,
    TOK_undoc10,
    TOK_undoc11,
    TOK_undoc12,
    TOK_undoc13,
    TOK_undoc14,
    TOK_undoc15,
    TOK_undoc16,
    TOK_undoc17,
    TOK_undoc18,
    TOK_TAB,
    TOK_TO,
    TOK_FN,
    TOK_SPC,
    TOK_INKEY,
    TOK_THEN,
    TOK_NOT,
    TOK_STEP,
    TOK_PLUS,
    TOK_MINUS,
    TOK_MULT,
    TOK_DIV,
    TOK_XOR,
    TOK_AND,
    TOK_OR,
    TOK_GT,
    TOK_EQ,
    TOK_LT,
    TOK_SGN,
    TOK_INT,
    TOK_ABS,
    TOK_USR,
    TOK_FRE,
    TOK_INP,
    TOK_Lorg,
    TOK_org,
    TOK_SQR,
    TOK_RND,
    TOK_LOG,
    TOK_EXP,
    TOK_COS,
    TOK_SIN,
    TOK_TAN,
    TOK_PEEK,
    TOK_LEN,
    TOK_SCRIN,
    TOK_STR,
    TOK_VAL,
    TOK_ASC,
    TOK_CHR,
    TOK_LEFT,
    TOK_RIGHT,
    TOK_MID,
    TOK_POINT,
    TOK_CSRLIN,
    TOK_STICK,
    TOK_STRIG,
    TOK_TIME
} basictoken;


static uint8_t simple_footer[] = {
            // Pointer and number of the BASIC line code in memory
            0x00, 0x00, 0x01, 0xc0, 0x0a, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

int phc25_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    long     org;
    int      c, i;

    if ( help )
        return -1;

    if ( binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".phc");
    } else {
        strcpy(filename,outfile);
    }

    if ( origin != -1 ) {
        org = origin;
    } else {
        if ( (org = get_org_addr(crtfile)) == -1 ) {
            exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
        }
    }
    if ( org != 0xc009 ) {
        fprintf(stderr, "Origin is $%04x - expected $c009\n", (int)org);
    }

    if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",binname);
    }

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        exit_log(1,"Can't open output file\n");
    }

    write_header(fpout, binname);
    
    // Alternate approach, it's in one basic program



    fprintf(fpout, "%c&H%04X%c", TOK_EXEC, (int)org, 0); 
    i = 0;
    while ( ( c = fgetc(fpin)) != EOF ) {
        if ( i < 0x1f ) {       // Magic number
            fputc(c,fpout);
        } else if ( c == 0xff ) {
            fputc(c,fpout);
            fputc(c,fpout);
        } else if ( c == 0x00 ) {
            fputc(0xff,fpout);
            fputc(c,fpout);
        } else {
            fputc(c, fpout);
        }
        i++;
    }
    fputc(0x00,fpout);  // End marker...

    // File length must be a multiple of 2
    if ( (ftell(fpout) + sizeof(simple_footer)) %2 ) {
        fputc(0xff, fpout);
    }

    // And write the simple_footer
    fwrite(simple_footer, 1, sizeof(simple_footer), fpout);          

    

    fclose(fpin);
    fclose(fpout);

    return 0;
}


static void write_header(FILE *fpout, char *name)
{
    fprintf(fpout, "%c%c%c%c%c%c%c%c%c%c%6s", 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5,name);
}


// Example of how to write a bootstrap file as a data statement
#if 0
#define RECORD_LENGTH 32
static void write_bootstrap(FILE *fpout, int bootstrap_org, FILE *bootstrap, int bootstrap_len)
{
    uint8_t  *linebuf, *ptr;
    int linelengths[20]; // Should be enough lines
    int num_lines = 0, offset = 0;

    // CLEAR 100,&H(loader_address-1)
    linelengths[num_lines++] = fprintf(fpout, "%c100,&H%04X%c", TOK_CLEAR, bootstrap_org - 1, 0);  
    // A=laoder_address
    linelengths[num_lines++] = fprintf(fpout, "A%c&H%04X%c", TOK_EQ, bootstrap_org, 0);
    int recordCount =  (bootstrap_len + RECORD_LENGTH - 1) / RECORD_LENGTH;
    // FOR I=1 TO (bootstrap_len+32-1)/32
    linelengths[num_lines++] = fprintf(fpout, "%cI%c1%c%d%c", TOK_FOR, TOK_EQ, TOK_TO, recordCount,0);
    // READ L$
    linelengths[num_lines++] = fprintf(fpout, "%cL$%c", TOK_READ, 0);
    // FOR J=1 TO LEN(L$) STEP 2
    linelengths[num_lines++] = fprintf(fpout, "%cJ%c1%c%c(L$)%c2%c", TOK_FOR, TOK_EQ, TOK_TO, TOK_LEN,TOK_STEP,0);
    // POKE A, VAL("&H" + MID(L$,J,2))
    linelengths[num_lines++] = fprintf(fpout, "%c A,%c(\"&H\"%c%c(L$,J,2))%c", TOK_POKE, TOK_VAL, TOK_PLUS, TOK_MID,0);
    // A=A+1
    linelengths[num_lines++] = fprintf(fpout, "A%cA%c1%c", TOK_EQ, TOK_PLUS, 0);
    // NEXT
    linelengths[num_lines++] = fprintf(fpout, "%c%c",TOK_NEXT, 0);
    // NEXT
    linelengths[num_lines++] = fprintf(fpout, "%c%c",TOK_NEXT, 0);
    // CLS:EXEC &Hloader_address
    linelengths[num_lines++] = fprintf(fpout, "%c:%c&H%04X%c",TOK_CLS, TOK_EXEC, bootstrap_org, 0);

    for ( int i = 0; i < bootstrap_len ; i+= RECORD_LENGTH) {
        linelengths[num_lines] = fprintf(fpout,"%c\"",TOK_DATA);
        for ( int  j = i; j < bootstrap_len && j - i < RECORD_LENGTH; j++ ) {
             linelengths[num_lines] += fprintf(fpout,"%02X", fgetc(bootstrap));
        }
        linelengths[num_lines++] += fprintf(fpout, "\"%c", 0x00);
    }


    fprintf(fpout, "%c", 0x00); // BASIC line end marker


    // Now move onto the offsets

    // Line numbers seem to be in reverse order...fab
    linebuf = calloc(num_lines, 4);
    ptr = linebuf + (num_lines-1) * 4;
    offset = 1;
    for ( int  i = 0, linenum = 10 ; i < num_lines; i++, linenum+=10 ) {
        ptr[0] = (offset) & 0xff;
        ptr[1] = ((offset >> 8 ) & 0xff) | 0xc0;
        ptr[2] = (linenum ) & 0xff;
        ptr[3] = (linenum >> 8 ) & 0xff;
        offset += linelengths[i];
        ptr -= 4;
    }
    fwrite(linebuf, 4, num_lines, fpout);
    fprintf(fpout,"%c", 0x00); // End marker
    fprintf(fpout,"%c%c%c%c", 0xff, 0xff, 0xff, 0xff); // End of tape

    for ( int  i = 0; i < 18; i++ ) {
        fputc(0, fpout);
    }
}
#endif


// phc images consist of 5 sections
//1. 10 A5 bytes
//2. 6  name of the program
//3. The basic program file. Each line is delimited by null. This
//   section is terminated by 3 nulls (1 of them for the preceeding
//   line, the other 2 indicate the end).
//4. The line numbers and pointers to them. It ends at the image size-1
//5. A 1-byte trailer of FF which we do not pass on
//
//Each byte after conversion becomes a start bit, bit 0,1,etc to 7,
//then 4 stop bits.
//
//An actual tape consists of 6 sections
//a. 2.656secs of silence
//b. 4.862secs of high bits
//c. The header which is parts 1 and 2 above
//d. 0.652secs of high bits
//e. The main program which is parts 3 and 4 above
//f. 1.771secs of silenc

