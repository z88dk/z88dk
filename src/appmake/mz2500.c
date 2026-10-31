/*
 *      Create a 320KB boot disk image compatible to the Sharp MZ2500 computer family
 *
 *      $Id: mz2500.c $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char              help         = 0;
#define STUB_SPACE  32
static char              lowprog      = 0;
static uint8_t           stub[STUB_SPACE + 1];
static size_t            stublen      = 0;


/* Options that are available for this module */
option_t mz2500_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name for the code block",   OPT_STR,   &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

static disc_spec spec = {
    .name = "MZ2500",
    .sectors_per_track = 16,
    .tracks = 40,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .first_sector_offset = 1,
    .alternate_sides = 1
};

static uint8_t    sectorbuf[256];

#define PAGE_SIZE   8192
#define FIRST_PAGE  12          /* the first RAM page of the program: the initial map shows it at $8000 */
#define MAX_BANKS   15         /* pages in the directory's list (offsets 32-46, ended by $FF) */
#define LOW_PAGE    16          /* the program's pages ($0000-$3FFF); the first bank (pages 18 and 19) is in windows 2 and 3 at the start.  The IPL does not run a program whose list has pages below 8 */

/* a BOOTSTRAP stub: the page at $8000 starts with a stub from the crt (lib/target/mz2500/classic/bootstrap.asm, the BOOTSTRAP section, which the crt0 emits when
   CRT_MZ2500_IPL_DISABLED is defined) that maps RAM pages 16 to 19 into windows 0 to 3 (the program, then the first bank) and starts the program at $0000;
   the program's own code for that page (section BANK_12) must leave STUB_SPACE bytes free for it.  Finding <name>_BOOTSTRAP.bin selects this mode. */


void write_sector(disc_handle *h, int track, int sector, int head) 
{
    int  i;

    for ( i = 0; i < sizeof(sectorbuf);i++ ) {
        sectorbuf[i] ^= 0xff;
    }
    disc_write_sector(h, track, sector, head, sectorbuf);

}


/*
 * Execution starts here
 */

int mz2500_exec(char* target)
{
    char   filename[FILENAME_MAX + 1];
    FILE*  fpin;
    int    len;
    int    i;
    int    track, sector, head;
    size_t bytes_read;
    int    bytes_to_write;
    disc_handle *h;
    uint8_t *image;
    uint8_t  bank_list[MAX_BANKS];
    int      npages;
    char     basename_buf[FILENAME_MAX + 1];
    char     bankname[FILENAME_MAX + 1];
    char    *p;

    if (help)
        return -1;

    if (binname == NULL ) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
    } else {
        strcpy(filename, outfile);
    }


    suffix_change(filename, ".dsk");


    if (strcmp(binname, filename) == 0) {
        exit_log(1, "Input and output file names must be different\n");
    }

    if (blockname == NULL)
        blockname = zbasename(binname);

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }

    suffix_change(blockname, "");

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    len = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);

    /* the crt's stub (a BOOTSTRAP section) means a program linked at $0000 */
    {
        char  bootname[FILENAME_MAX + 1];
        FILE *fb;

        strcpy(bootname, binname);
        suffix_change(bootname, "_BOOTSTRAP.bin");
        if ((fb = fopen(bootname, "rb")) != NULL) {
            stublen = fread(stub, 1, sizeof(stub), fb);
            fclose(fb);
            if (stublen == 0 || stublen > STUB_SPACE) {
                exit_log(1, "%s must be 1 to %d bytes\n", bootname, STUB_SPACE);
            }
            lowprog = 1;
        }
    }

    /* The disk file is a stream of 8 KB pages. The IPL loads the n-th page of the stream into the RAM page named by the n-th byte of the bank
       list in the directory entry: the program's pages first (RAM pages 12... which the initial map shows at $8000...), then each extra bank
       (the linker's <name>_BANK_<n>.bin, linked at (n << 16) | the address the program maps it at) into RAM page n. */
    image = calloc(MAX_BANKS, PAGE_SIZE);
    if (image == NULL || len > (lowprog ? 2 : 4) * PAGE_SIZE) {
        fclose(fpin);
        if (lowprog) {
            exit_log(1, "The program is %d bytes: linked at $0000 it must fit the two pages at $0000-$3FFF (16384 bytes)\n", len);
        }
        exit_log(1, "The program is %d bytes: it must fit the four pages at $8000-$FFFF (32768 bytes)\n", len);
    }
    npages = 0;
    if (lowprog) {
        /* the stub's page comes first, at $8000; the program's two pages after it */
        /* the page at $8000 (RAM page 12): code linked into the section BANK_12 at $8000 (the first 32 bytes left for the stub: `defs 32`), then the stub on top of them */
        snprintf(bankname, sizeof(bankname), "%s.bin", binname);
        if ((p = strrchr(binname, '.')) != NULL && strcmp(p, ".bin") == 0) {
            strcpy(basename_buf, binname);
            basename_buf[p - binname] = 0;
        } else {
            strcpy(basename_buf, binname);
        }
        snprintf(bankname, sizeof(bankname), "%s_BANK_12.bin", basename_buf);
        {
            FILE *fb = fopen(bankname, "rb");

            if (fb != NULL) {
                size_t n = fread(image, 1, PAGE_SIZE + 1, fb);

                fclose(fb);
                if (n > PAGE_SIZE) {
                    exit_log(1, "%s is bigger than one 8 KB page\n", bankname);
                }
            }
        }
        memcpy(image, stub, stublen);
        bank_list[npages++] = FIRST_PAGE;
        if (fread(image + PAGE_SIZE, 1, len, fpin) != (size_t)len) {
            fclose(fpin);
            exit_log(1, "Could not read the program from <%s>\n", binname);
        }
        bank_list[npages++] = LOW_PAGE;
        bank_list[npages++] = LOW_PAGE + 1;
        npages = 3;
    } else {
        if (fread(image, 1, len, fpin) != (size_t)len) {
            fclose(fpin);
            exit_log(1, "Could not read the program from <%s>\n", binname);
        }
        npages = (len + PAGE_SIZE - 1) / PAGE_SIZE;
        for (i = 0; i < npages; i++) {
            bank_list[i] = FIRST_PAGE + i;
        }
    }

    strcpy(basename_buf, binname);
    if ((p = strrchr(basename_buf, '.')) != NULL && strcmp(p, ".bin") == 0) {
        *p = 0;
    }
    for (i = 1; i < 32; i++) {
        FILE *fb;

        if (i >= FIRST_PAGE && i < FIRST_PAGE + 4) {
            continue;
        }
        if (lowprog && i >= LOW_PAGE && i < LOW_PAGE + 2) {
            continue;
        }
        snprintf(bankname, sizeof(bankname), "%s_BANK_%d.bin", basename_buf, i);
        if ((fb = fopen(bankname, "rb")) == NULL) {
            continue;
        }
        if (npages >= MAX_BANKS) {
            fclose(fb);
            exit_log(1, "Too many pages: the directory holds %d\n", MAX_BANKS);
        }
        /* a bank of more than 8 KB goes on into the next pages (a 16 KB one linked at $4000 fills windows 2 and 3) */
        bytes_read = fread(image + npages * PAGE_SIZE, 1, (MAX_BANKS - npages) * PAGE_SIZE + 1, fb);
        fclose(fb);
        if (bytes_read == 0) {
            continue;
        }
        {
            int n = (bytes_read + PAGE_SIZE - 1) / PAGE_SIZE, k;

            if (npages + n > MAX_BANKS) {
                exit_log(1, "%s: too many pages: the directory holds %d\n", bankname, MAX_BANKS);
            }
            for (k = 0; k < n; k++) {
                bank_list[npages++] = i + k;
            }
            i += n - 1;     /* (the pages it covers are not looked for again) */
        }
    }

    h = disc_create(&spec);

    /* Disk block #2 (directory) */
    memset(sectorbuf, 0, sizeof(sectorbuf));
    sectorbuf[0] = 1;    /* OBJ (machine language program) */
    memcpy(sectorbuf + 1,"IPLPRO", 6);

    /* Now the filename from offset 8 */
    for ( i = 7 ; i < 20; i++ ) {
        int slen = i - 7;
        sectorbuf[i] = strlen(blockname) > slen ? blockname[slen] : ' ';
    }
    sectorbuf[20] = 0x0d;    // Terminate name
    // sectorbuf[22] = 0;	 	// 
    // sectorbuf[23] = 0x80;
    sectorbuf[24] = 0;		// Load address
    sectorbuf[25] = 0x80;
    sectorbuf[30] = 0x30;		// Start sector
    sectorbuf[31] = 0x00;

    /* The RAM pages the stream is loaded into, in order, ended by $FF */
    for (i = 0; i < npages; i++) {
        sectorbuf[32 + i] = bank_list[i];
    }
    sectorbuf[32 + npages] = 0xff;

    // Banking at start of execution
    sectorbuf[48] = 8;		// for $000
    sectorbuf[49] = 9;
    sectorbuf[50] = 10;
    sectorbuf[51] = 11;
    sectorbuf[52] = 12;
    sectorbuf[53] = 13;
    sectorbuf[54] = 14;
    sectorbuf[55] = 15;
    write_sector(h, 0, 0, 1);

    // Write the pages to the dsk per sector (in blocks of 256), starting on track 1, first sector (block 0x30)
    track = 1; sector = 0; head = 0;
    bytes_to_write = npages * PAGE_SIZE;
    for (i = 0; i < bytes_to_write; i += 256) {
       if (track >= spec.tracks) {
           fclose(fpin);
           exit_log(1, "The program and its banks do not fit on the disk\n");
       }
       memcpy(sectorbuf, image + i, 256);
       write_sector(h, track, sector, head);               // Write sector buffer to sector on dsk

       sector++;                                           // Adjust track, sector, head to write next
       if ( sector == 16 ) {
          sector = 0;
          head ^= 1;
          if ( head == 1 ) track++;
       }
    }

    fclose(fpin);
    disc_write_edsk(h, filename);
    disc_free(h);

    return 0;
}
