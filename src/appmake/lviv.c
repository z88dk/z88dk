/*
 * LVT (Livi PK-01) generator 
 */


#include "appmake.h"

static char             *tapename     = NULL;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static int               exec         = -1;
static char              snapshot     = 0;
static char              help         = 0;


/* Options that are available for this module */
option_t lviv_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0,  "tapename",   "Name of the file in the LVT",      OPT_STR,   &tapename },
    {  0,  "snapshot",   "Generate a snapshot",              OPT_BOOL,  &snapshot },
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};

int lviv_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    struct  stat binname_sb;
    FILE   *fpin;
    FILE   *fpout;
    int     i,c;
    int     size;
    
    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,snapshot ? ".dump" : ".lvt");
    } else {
        strcpy(filename,outfile);
    }

    if ( tapename == NULL ) {
         tapename = zbasename(binname);
    }

    if ((origin == -1) && ((crtfile == NULL) || ((origin = get_org_addr(crtfile)) == -1))) {
        origin = 0;
    }
    if ( exec == -1 ) {
        exec = origin;
    }
    
    if ( stat(binname, &binname_sb) < 0 ||
         ( (fpin=fopen_bin(binname, NULL) ) == NULL )) {
        exit_log(1,"Can't open input file %s\n",binname);
    }
    
    if ( ( fpout = fopen(binname, "rb")) == NULL ) {
        exit_log(1,"Can't open input file %s\n", binname);
    }
    
    if ( ( fpout = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Can't open output file %s\n", filename);
    }

    size = binname_sb.st_size;

    if ( snapshot ) {
        // Snapshots are only good for programs compiled without a ROM dependency
        unsigned char *ram = calloc(1,sizeof(49152));
        // Mame understands v2 of the snapshot format, so that's what we'll generate
        /*
        +0x00	16	"LVOV/DUMP/2.0/H+"	.SAV Dump signature
        +0x10	1	0x00	.SAV signature delimiter
        +0x11	0xC000	0x??, ...	RAM
        +0xC011	0x4000	0x??, ...	ROM
        +0x10011	0x4000	0x??, ...	VRAM
        +0x14011	0x100	0x??, ...	Ports
        +0x14111	1	0x??	B
        +0x14112	1	0x??	C
        +0x14113	1	0x??	D
        +0x14114	1	0x??	E
        +0x14115	1	0x??	H
        +0x14116	1	0x??	L
        +0x14117	1	0x??	A
        +0x14118	1	0x??	F
        +0x14119	2	0x????	SP
        +0x1411B	2	0x????	PC
        +0x1411D	14	0x??, ...	Binding to BIOS, i.e. entry points and values of some variables
        */
       writestring("LVOV/DUMP/2.0/H+", fpout);
       writebyte(0x00, fpout); // .SAV indicator
       // Now we write RAM
       for ( i = 0; i < size; i++ ) {
           c = fgetc(fpin);
           ram[i + origin] = c;
       }
       fwrite(ram, 1, 0xc000, fpout);
       // And now we write the ROM
       fwrite(ram, 1, 0x4000, fpout);
       // And now the VRAM
       memset(ram, 0, 0xc000);
       fwrite(ram, 1, 0x4000, fpout);
       // Onto the ports now - TODO, we should set some of them?
       fwrite(ram, 1, 0x100, fpout);
       // And now registers
       writebyte(0, fpout); // B
       writebyte(0, fpout); // C
       writebyte(0, fpout); // D
       writebyte(0, fpout); // E
       writebyte(0, fpout); // H
       writebyte(0, fpout); // L
       writebyte(0, fpout); // A
       writebyte(0, fpout); // F
       writeword(0, fpout); // SP
       writeword(exec, fpout); // PC
       // And now it's binding to bios, Mame ignores it, so will we
       fwrite(ram, 1, 14, fpout);
    } else {
        /*
        CODE .LVT
            +0x00	9	"LVOV/2.0/"	Primary .LVT tape signature
            +0x09	1	0xD0	Secondary .LVT signature (Binary)
            +0x0A	6	"......"	Name of the tape in KOI7 (aligned with spaces)
            +0x10	2	0x????	Program start address
            +0x12	2	0x????	Program end address
            +0x14	2	0x????	Program entry point address
            +0x16	upto EOF	0x??, ...	Program body
        */
        writebyte('L', fpout);
        writebyte('V', fpout);
        writebyte('O', fpout);
        writebyte('V', fpout);
        writebyte('/', fpout);
        writebyte('2', fpout);
        writebyte('.', fpout);
        writebyte('0', fpout);
        writebyte('/', fpout);
        writebyte(0xd0, fpout);	// CODE type
        for ( i = 0 ; i < 6 ; i++ ) {
            writebyte(i < strlen(tapename) ? tapename[i] : ' ', fpout);
        }
        writeword(origin, fpout);
        writeword(origin+size-1, fpout);
        writeword(exec, fpout);
        for ( i = 0; i < size; i++ ) {
            c = fgetc(fpin);
            writebyte(c,fpout);
        }
    }
  
    fclose(fpin);
    fclose(fpout);
    
    return 0;
}



