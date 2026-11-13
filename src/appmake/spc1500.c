/*
 *  Samsung SPC-1500 cassette generator
 *
 * The IPL's "C: cassette system" reads a header block and then 128 bytes to
 * $0000 and runs them.  Those are the bootstrap
 * (lib/target/spc1500/classic/bootstrap.asm), which
 * loads the program, packed with ZX0, with the ROM's own tape loader and
 * unpacks it.  The cassette is therefore three blocks in the ROM's tape format
 * (the one of the
 * SPC-1000): the header (a 128 byte FCB: type 1, the name, the size at $12),
 * the bootstrap and the packed program.
 *
 * Output: a .tap (the MAME cassette format: one byte, '0' or '1', for each bit)
 * and, with --wav, a .wav (44.1 kHz, 8 bit, mono) for a real machine.
 *
 * A block is a leader (zero bits, then ones, then as many zeros, then a one),
 * each byte as a one bit and its eight bits (most significant first), the count
 * of the one bits
 * of the data as two bytes (high, low) and a one bit.  There is one copy: the
 * IPL ROM's own save writes one and its loader reads one (the SPC-1000's ROM,
 * whose format this is,
 *  writes the block twice, but this ROM does not look at a second copy).
 */

#include "appmake.h"

/* How much space between the unpacked and the packed data */
#define SLACK 16

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *tapename     = NULL;
static char              wav          = 0;
static char              help         = 0;

/* Options that are available for this module */
option_t spc1500_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "name",     "Name shown by the IPL (up to 14 characters)", OPT_STR, &tapename },
    {  0 , "wav",      "Also write a .wav file",     OPT_BOOL,  &wav },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

/* The bits of the cassette, one byte each */
static uint8_t *bits = NULL;
static size_t   nbits = 0, capbits = 0;

static void put_bit(int b)
{
    if (nbits == capbits) {
        capbits = capbits ? capbits * 2 : 1 << 20;
        bits = must_realloc(bits, capbits);
    }
    bits[nbits++] = b ? 1 : 0;
}

static void put_byte(int v)
{
    int i;

    put_bit(1);
    for (i = 7; i >= 0; i--)
        put_bit((v >> i) & 1);
}

static void put_leader(int zeros, int ones)
{
    int i;

    for (i = 0; i < zeros; i++) put_bit(0);
    for (i = 0; i < ones; i++) put_bit(1);
    for (i = 0; i < ones; i++) put_bit(0);
    put_bit(1);
}

static void put_block(const uint8_t *data, int len)
{
    int i, ones = 0;

    for (i = 0; i < len; i++) {
        int v = data[i];
        while (v) { ones += v & 1; v >>= 1; }
    }
    for (i = 0; i < len; i++)
        put_byte(data[i]);
    put_byte(ones >> 8);
    put_byte(ones & 0xff);
    put_bit(1);
}

static void put_le32(FILE *f, uint32_t v)
{
    writebyte(v & 0xff, f); writebyte((v >> 8) & 0xff, f); writebyte((v >> 16) & 0xff, f); writebyte((v >> 24) & 0xff, f);
}

static void put_le16(FILE *f, uint16_t v)
{
    writebyte(v & 0xff, f); writebyte(v >> 8, f);
}

int spc1500_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    char tapfile[FILENAME_MAX + 1];
    char bootname[FILENAME_MAX + 1], utname[FILENAME_MAX + 1], ctname[FILENAME_MAX + 1], cmdline[2 * FILENAME_MAX + 32];
    FILE *fpin, *fpout, *temp;
    uint8_t *image, *boot, *packed, fcb[128];
    long len, boot_len, clen, i;
    long org, boot_org, reloc, top, clen_at, caddr_at, blen;

    if (help)
        return -1;

    if (binname == NULL || crtfile == NULL)
        return -1;

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".tap");
    } else {
        strcpy(filename, outfile);
    }

    if (parameter_search(crtfile, ".map", "__spc1500_bootstrap_built") <= 0)
        exit_log(1, "The program was not linked with the SPC-1500 bootstrap (no __spc1500_bootstrap_built in the map)\n");

    org = get_org_addr(crtfile);
    boot_org = parameter_search(crtfile, ".map", "__spc1500_bootstrap_org");
    reloc = parameter_search(crtfile, ".map", "__spc1500_bootstrap_reloc");
    top = parameter_search(crtfile, ".map", "__spc1500_bootstrap_top");
    blen = parameter_search(crtfile, ".map", "__spc1500_bootstrap_len");
    clen_at = parameter_search(crtfile, ".map", "__spc1500_bootstrap_clen");
    caddr_at = parameter_search(crtfile, ".map", "__spc1500_bootstrap_caddr");
    if (org < 0 || boot_org < 0 || reloc <= 0 || top <= 0 || blen <= 0 || clen_at <= 0 || caddr_at <= 0)
        exit_log(1, "Invalid SPC-1500 bootstrap symbols in the map\n");

    if ((fpin = fopen_bin(binname, crtfile)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);
    fseek(fpin, 0, SEEK_END);
    len = ftell(fpin);
    fseek(fpin, 0, SEEK_SET);
    image = must_malloc(len);
    if (fread(image, 1, len, fpin) != (size_t)len)
        exit_log(1, "Could not read %s\n", binname);
    fclose(fpin);

    /* CRT_TRIM_BSS (the pragma, default 1): the uninitialised data is at the
       end of the image and the start-up zeroes it, so it need not be on the
       tape (nor count against the room the unpacking needs) */
    {
        long bss_head = parameter_search(crtfile, ".map", "__BSS_head");
        long bss_trim = parameter_search(crtfile, ".map", "__spc1500_trim_bss");
        if (bss_trim == 1 && bss_head > org && bss_head - org < len) {
            fprintf(stderr, "SPC-1500: %ld bytes of uninitialised data left out of the image\n", len - (bss_head - org));
            len = bss_head - org;
        }
    }

    /* The bootstrap */
    strcpy(bootname, binname);
    suffix_change(bootname, "_BOOTSTRAP.bin");
    if ((temp = fopen_bin(bootname, crtfile)) == NULL)
        exit_log(1, "Can't open the bootstrap %s\n", bootname);
    fseek(temp, 0, SEEK_END);
    boot_len = ftell(temp);
    fseek(temp, 0, SEEK_SET);
    if (boot_len != blen)
        exit_log(1, "The bootstrap is %ld bytes, the IPL loads %ld\n", boot_len, blen);
    boot = must_malloc(boot_len);
    if (fread(boot, 1, boot_len, temp) != (size_t)boot_len)
        exit_log(1, "Could not read the bootstrap\n");
    fclose(temp);

    /* Pack the program */
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
    packed = must_malloc(clen);
    if (fread(packed, 1, clen, fpout) != (size_t)clen)
        exit_log(1, "Could not read the compressed program\n");
    fclose(fpout);
    remove(utname);
    remove(ctname);

    /* The packed program is loaded to end at the top.  The program grows up
       from org and the packed data starts at top - clen: the program is ahead
       of what has been read by at
       most what the packing saved, so the packed data must start at least that
       far above org. */
    if (top - clen - org < (len - clen) + SLACK)
        exit_log(1, "The program unpacks over its own packed data (%ld bytes of program, %ld packed, which end at %ld: the program must be %ld at most)\n",
                 len, clen, top, top - org - SLACK);

    /* The load address and the length go into the bootstrap's `ld hl` and `ld
       bc`: stage 2 is phased to run at reloc, so the symbols are addresses
       there (the block
       is moved to reloc whole, and starts at boot_org) */
    caddr_at -= reloc - boot_org;
    clen_at -= reloc - boot_org;
    if (caddr_at - boot_org < 0 || caddr_at - boot_org + 2 > boot_len || clen_at - boot_org < 0 || clen_at - boot_org + 2 > boot_len)
        exit_log(1, "The bootstrap's load address or packed length is outside the bootstrap\n");
    boot[caddr_at - boot_org] = (uint8_t)((top - clen) & 0xff);
    boot[caddr_at - boot_org + 1] = (uint8_t)((top - clen) >> 8);
    boot[clen_at - boot_org] = (uint8_t)(clen & 0xff);
    boot[clen_at - boot_org + 1] = (uint8_t)(clen >> 8);

    fprintf(stderr, "SPC-1500: %ld bytes packed to %ld, loaded at $%04lX to $%04lX\n", len, clen, top - clen, top - 1);

    /* The header block: the FCB */
    memset(fcb, 0, sizeof(fcb));
    fcb[0] = 1;
    {
        const char *name = tapename ? tapename : binname;
        const char *slash = strrchr(name, '/');
        if (slash) name = slash + 1;
        for (i = 0; i < 14 && name[i] && name[i] != '.'; i++)
            fcb[1 + i] = (uint8_t)toupper((unsigned char)name[i]);
    }
    fcb[0x12] = (uint8_t)(blen & 0xff);
    fcb[0x13] = (uint8_t)(blen >> 8);

    for (i = 0; i < 2000; i++) put_bit(0);
    put_leader(22000, 40);
    put_block(fcb, sizeof(fcb));
    put_leader(11000, 20);
    put_block(boot, boot_len);
    put_leader(3000, 20);
    put_block(packed, clen);
    for (i = 0; i < 2000; i++) put_bit(0);

    /* .tap */
    if ((fpout = fopen(filename, "wb")) == NULL)
        exit_log(1, "Can't open output file %s\n", filename);
    for (i = 0; i < (long)nbits; i++)
        writebyte(bits[i] ? '1' : '0', fpout);
    fclose(fpout);

    /* .wav: the pulses of the MAME cassette, at 44.1 kHz: a low phase and then
       a high one, of 10 samples for a zero bit and 23 for a one (0.23 and 0.52
       ms: the ROM
       tells them apart by the level 0.32 ms after the rising edge) */
    if (wav) {
        long samples = 0;
        strcpy(tapfile, filename);
        suffix_change(tapfile, ".wav");
        for (i = 0; i < (long)nbits; i++)
            samples += bits[i] ? 46 : 20;
        if ((fpout = fopen(tapfile, "wb")) == NULL)
            exit_log(1, "Can't open output file %s\n", tapfile);
        fwrite("RIFF", 1, 4, fpout); put_le32(fpout, 36 + samples); fwrite("WAVEfmt ", 1, 8, fpout);
        put_le32(fpout, 16); put_le16(fpout, 1); put_le16(fpout, 1); put_le32(fpout, 44100); put_le32(fpout, 44100); put_le16(fpout, 1); put_le16(fpout, 8);
        fwrite("data", 1, 4, fpout); put_le32(fpout, samples);
        for (i = 0; i < (long)nbits; i++) {
            int half = bits[i] ? 23 : 10, j;
            for (j = 0; j < half; j++) writebyte(0x20, fpout);
            for (j = 0; j < half; j++) writebyte(0xe0, fpout);
        }
        fclose(fpout);
    }

    free(bits);
    free(image);
    free(boot);
    free(packed);
    return 0;
}
