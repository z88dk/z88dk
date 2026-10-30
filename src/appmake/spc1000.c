/*
 *  SPC-1000 .spc1000 generator
 *
 */

#include "appmake.h"

/* -subtype=allram: the program is linked at its own address ($0000), packed with ZX0 and put after the CRT's bootstrap, which BASIC loads at
   $7CDD (lib/target/spc1000/classic/bootstrap.asm).  The bootstrap moves the packed data up to end at __spc1000_bootstrap_top and unpacks it in place,
   so the program must not catch up with the packed data there. */
#define ALLRAM_SLACK 16


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t spc1000_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

int spc1000_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE *fpin, *fpout;
    long pos;
    int c;
    int i;
    int len;
    int allram = 0;
    uint8_t *payload = NULL;
    long payload_len = 0;

    if (help)
        return -1;

    if (binname == NULL || (crtfile == NULL && origin == -1)) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".spc");
    } else {
        strcpy(filename, outfile);
    }

    if (!allram) {
        if (origin != -1) {
            pos = origin;
        } else {
            if ((pos = get_org_addr(crtfile)) == -1) {
                exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
            }
        }
    }

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }

    allram = crtfile != NULL && parameter_search(crtfile, ".map", "__spc1000_bootstrap_built") > 0;

    /* Determine size of input file */
    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    len = ftell(fpin);

    fseek(fpin, 0L, SEEK_SET);

    if (allram) {
        long org = get_org_addr(crtfile);
        long boot_org = parameter_search(crtfile, ".map", "__spc1000_bootstrap_org");
        long reloc = parameter_search(crtfile, ".map", "__spc1000_bootstrap_reloc");
        long top = parameter_search(crtfile, ".map", "__spc1000_bootstrap_top");
        long clen_at = parameter_search(crtfile, ".map", "__spc1000_bootstrap_clen");
        char bootname[FILENAME_MAX + 1], utname[FILENAME_MAX + 1], ctname[FILENAME_MAX + 1], cmdline[2 * FILENAME_MAX + 32];
        FILE *temp;
        uint8_t *image;
        long boot_len, clen;

        if (org < 0 || boot_org <= 0 || reloc <= 0 || top <= 0 || clen_at <= 0)
            exit_log(1, "Invalid SPC-1000 allram symbols in CRT\n");

        strcpy(bootname, binname);
        suffix_change(bootname, "_BOOTSTRAP.bin");
        if ((temp = fopen_bin(bootname, crtfile)) == NULL)
            exit_log(1, "Can't open the bootstrap %s\n", bootname);
        fseek(temp, 0, SEEK_END);
        boot_len = ftell(temp);
        fseek(temp, 0, SEEK_SET);

        image = must_malloc(len);
        if (fread(image, 1, len, fpin) != (size_t)len)
            exit_log(1, "Could not read %s\n", binname);

        get_temporary_filename(utname);
        get_temporary_filename(ctname);
        if ((fpout = fopen(utname, "wb")) == NULL)
            exit_log(1, "Could not create the compression input\n");
        fwrite(image, 1, len, fpout);
        fclose(fpout);
        snprintf(cmdline, sizeof(cmdline), "z88dk-zx0 -f %s %s", utname, ctname);
        if (system(cmdline) != 0)
            exit_log(1, "Unable to compress the program (is z88dk-zx0 on the PATH?)\n");
        if ((fpout = fopen(ctname, "rb")) == NULL)
            exit_log(1, "Could not open the compressed program\n");
        fseek(fpout, 0, SEEK_END);
        clen = ftell(fpout);
        fseek(fpout, 0, SEEK_SET);

        payload_len = boot_len + clen;
        payload = must_malloc(payload_len);
        if (fread(payload, 1, boot_len, temp) != (size_t)boot_len || fread(payload + boot_len, 1, clen, fpout) != (size_t)clen)
            exit_log(1, "Could not read the bootstrap or the compressed program\n");
        fclose(temp);
        fclose(fpout);
        remove(utname);
        remove(ctname);
        free(image);

        /* The packed length goes into the bootstrap's `ld bc`. */
        if (clen_at - boot_org < 0 || clen_at - boot_org + 2 > boot_len)
            exit_log(1, "The bootstrap's packed length is outside the bootstrap\n");
        payload[clen_at - boot_org] = (uint8_t)clen;
        payload[clen_at - boot_org + 1] = (uint8_t)(clen >> 8);

        /* The program grows up from org and the packed data starts at top - clen (the bootstrap moves it there): the program is ahead of what has been
           read by at most what the packing saved, so the packed data must start at least that far above org. */
        if (top - clen - org < (len - clen) + ALLRAM_SLACK)
            exit_log(1, "The program unpacks over its own packed data (%ld bytes of program, %ld packed, which end at %ld: the program must be %ld at most)\n",
                     (long)len, clen, top, top - org - ALLRAM_SLACK);
        if (boot_org + payload_len > reloc)
            exit_log(1, "The packed program (to %ld) runs into the unpacker at %ld\n", boot_org + payload_len, reloc);
        fprintf(stderr, "SPC-1000 allram: %d bytes packed to %ld, loaded at $%04lX to $%04lX\n", len, clen, boot_org, boot_org + payload_len - 1);

        pos = boot_org;
        len = (int)payload_len;
        fpout = NULL;
    }

    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    /* Offset 0x12 = size */
    /* OFfset 0x14 = address */

    writebyte(0x02, fpout);
    for (i = 0; i < 15; i++) {
        writebyte(i < strlen(binname) ? binname[i] : 0, fpout);
    }
    /* Offset 0x10 */
    writebyte(0x00, fpout);
    writebyte(0x00, fpout);
    /* Length of the file + headers */
    writebyte((len + 13) % 256, fpout);
    writebyte((len + 13) / 256, fpout);
    /* Loading address */
    writebyte(pos % 256, fpout);
    writebyte((pos / 256) % 256, fpout);
    writebyte(0x00, fpout);
    writebyte(0x00, fpout);
    writebyte(0x3a, fpout); // ??

    for (i = 25; i < 0x80; i++) {
        writebyte(0x00, fpout);
    }

    // Now write the payload file
    writebyte(0x09, fpout);
    writebyte(0x00, fpout);
    writebyte(0x0a, fpout);
    writebyte(0x00, fpout);
    writebyte(0xb9, fpout);
    writebyte(0x11, fpout);
    writebyte(pos % 256, fpout);
    writebyte((pos / 256) % 256, fpout);
#if 0
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
#else
    for (i = 0x88; i < 0xc0; i++) {
        writebyte(0x00, fpout);
    }
#endif
    if (payload) {
        fwrite(payload, 1, payload_len, fpout);
    } else {
        for (i = 0; i < len; i++) {
            c = getc(fpin);
            writebyte(c, fpout);
        }
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}
