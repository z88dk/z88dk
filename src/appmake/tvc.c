/*
 *      Short program to create a Videoton TV Computer .cas file
 *
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *extfile      = ".cas";
static char              help         = 0;
static char              version      = 0;

/* Options that are available for this module */
option_t tvc_options[] = {
    { 'h', "help",     "Display this help",               OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",              OPT_STR,   &binname },
    { 'o', "output",   "Name of output file (input name)",OPT_STR,   &outfile },
    { 'e', "ext",      "Extension of output file (.cas)", OPT_STR,   &extfile },
    { 'v', "version",  "Version of output file (0x00)",   OPT_INT,   &version },
    {  0,  NULL,       NULL,                              OPT_NONE,  NULL }
};

/* Executable CAS FILE header
 * 00    filetype    file type, 01h/11h: buffered/unbuffered   
 * 01    copyprotect 00h is not protected
 * 02-03 blocknumber lo/hi 	
 *           Number of 80h sized blocks occupied by the program
 * 04    lastblockbytes
 *           Number of useful bytes in the last block (1-128)
 * 05-7F 00h         Always 0x00
 *  *** 16bytes header of non-buffered files ***
 * 80    00h         Always 0x00
 * 81    type        01 - program file, 00 - data file
 * 82-83 prgsize     lo/hi Size of the program
 * 84    autorun     0xff: autostart of the program
 * 85-8E 00h         Always 0x00
 * 8F    versionnumber
 *           version (most of the cases it is not used)
 * 90-n  databytes   payload
 */

/*
 * The BASIC jumpstart program:
 * 10 PRINT USR(6659)
 */
 int basic_hdr_len = 20;
 int basic_hdr[]  = {0x0f, 0x0a, 0x00, 0xdd, 0x20, 0x55, 0x53, 0x52,
					 0x96, 0x36, 0x36, 0x35, 0x39, 0x95, 0xff, 0x00,
					 0x00, 0x00, 0x00, 0x00};
/* 19EF   0F 0A 00 DD         DB   0FH,0AH,0,0DDH   
19F3   20 55 53 52            DB   " USR"   
19F7   96 36 36 35 39         DB   96H,"6659"   
19FC   95 FF 00 00 00 00 00   DB   95H,0FFH,0,0,0,0,0   ; 20 byte program header
 */

/*
 * Execution starts here
 */

int tvc_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    int     c,i;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename, extfile);
    } else {
        strcpy(filename,outfile);
    }

	if ( (fpin=fopen_bin(binname, NULL) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",binname);
    }
 

    if (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }
    
    writebyte(0x11,fpout); // buffered file
    writebyte(0x00,fpout); // not protected
    writeword(((len - 1) / 0x80) + 1, fpout); // num of blocks
    writebyte(((len - 1) % 0x80) + 1, fpout);  // num of valid bytes in the last block
    for(int i=0x05; i<0x80; i++) { // padding to 0x7f (inclusive)
		writebyte(0x00, fpout);
	}
	writebyte(0x00, fpout); // always 0x00
	writebyte(0x01, fpout); // program file
	writeword(len, fpout);  // length of program
	writebyte(0x00, fpout); // autorun? No.
	for(int i=0x85; i<0x8f; i++) { // padding to 0x8e (inclusive)
		writebyte(0x00, fpout);
	}
	writebyte(version,fpout); // version, by default it is 0
	
	for (i=0; i<basic_hdr_len; i++) { // writing the basic jumpstart
		writebyte(basic_hdr[i], fpout);
	}

    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}


