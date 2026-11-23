/*
 * Philips P2000T cassette image.
 *
 * A tape record is a 32-byte header and 1024 data bytes. M2000, MAME and
 * the cassette archive store that header at offset 48 of a 256-byte
 * preamble and use the suffix .cas. The other 224 bytes are unused.
 * A name ending in .p2000t stores the same 32 bytes at offset 0.
 *
 * Bytes 0-1 are the load address. The file length is stored at bytes
 * 2-3, 4-5 and 19-20 of every block. Byte 31 counts down to 1 and
 * includes the current block. The name is 16 SAA5050 characters, the
 * first 8 then the last 8.
 *
 * Stefano Bodrato - April 2014
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              p2000t       = 0;
static char              help         = 0;

option_t p2000_options[] = {
    { 'h', "help",      "Display this help",                 OPT_BOOL, &help },
    { 'b', "binfile",   "Linked binary file",                OPT_STR,  &binname },
    { 'c', "crt0file",  "crt0 file used in linking",         OPT_STR,  &crtfile },
    { 'o', "output",    "Name of output file",               OPT_STR,  &outfile },
    {  0 , "blockname", "Name of the code block",            OPT_STR,  &blockname },
    {  0 , "org",       "Origin of the binary",              OPT_INT,  &origin },
    {  0 , "p2000t",    "Write a .p2000t file (32-byte header)", OPT_BOOL, &p2000t },
    {  0 , NULL,        NULL,                                OPT_NONE, NULL }
};

/* SAA5050 codes 0x20-0x7A match Unicode, apart from the six glyphs below. */
static int saa5050_byte(unsigned cp)
{
    if (cp == 0x23)
        return 0x5F; /* # */
    if (cp >= 0x20 && cp <= 0x5A)
        return (int)cp;
    if (cp >= 0x61 && cp <= 0x7A)
        return (int)cp;

    switch (cp) {
    case 0x00A3: return 0x23; /* £ */
    case 0x2190: return 0x5B; /* ← */
    case 0x00F7: return 0x5C; /* ÷ */
    case 0x2192: return 0x5D; /* → */
    case 0x2191: return 0x5E; /* ↑ */
    case 0x2014: return 0x60; /* — */
    case 0x00BC: return 0x7B; /* ¼ */
    case 0x00BE: return 0x7C; /* ¾ */
    case 0x2016: return 0x7D; /* ‖ */
    case 0x00BD: return 0x7E; /* ½ */
    case 0x2588: return 0x7F; /* █ */
    default:     return 0x20;
    }
}

/* One Unicode scalar. A broken sequence becomes U+FFFD and consumes one byte. */
static unsigned utf8_take(const unsigned char **pp)
{
    const unsigned char *p = *pp;
    unsigned c, cp;
    int need, i;

    if (*p == 0)
        return 0;

    c = *p++;
    if (c < 0x80) {
        *pp = p;
        return c;
    }
    if ((c & 0xE0) == 0xC0)      { cp = c & 0x1F; need = 1; }
    else if ((c & 0xF0) == 0xE0) { cp = c & 0x0F; need = 2; }
    else if ((c & 0xF8) == 0xF0) { cp = c & 0x07; need = 3; }
    else {
        *pp = p;
        return 0xFFFD;
    }

    for (i = 0; i < need; i++) {
        if ((p[i] & 0xC0) != 0x80) {
            *pp = p;
            return 0xFFFD;
        }
        cp = (cp << 6) | (p[i] & 0x3F);
    }
    *pp = p + need;
    return cp;
}

static void map_name(const char *text, unsigned char name[16])
{
    const unsigned char *p = (const unsigned char *)(text ? text : "");
    unsigned char head[8];
    unsigned char tail[8];
    int count = 0;
    int tail_at = 0;
    unsigned cp;

    memset(name, 0x20, 16);
    while ((cp = utf8_take(&p)) != 0) {
        unsigned char b = (unsigned char)saa5050_byte(cp);

        if (count < 8)
            head[count] = b;
        if (count < 16)
            name[count] = b;
        tail[tail_at] = b;
        tail_at = (tail_at + 1) & 7;
        count++;
    }
    if (count > 16) {
        int i;

        memcpy(name, head, 8);
        for (i = 0; i < 8; i++)
            name[8 + i] = tail[(tail_at + i) & 7];
    }
}

static int ends_with(const char *name, const char *suffix)
{
    size_t n = strlen(name);
    size_t s = strlen(suffix);
    size_t i;

    if (n < s)
        return 0;
    for (i = 0; i < s; i++) {
        unsigned char a = (unsigned char)name[n - s + i];
        unsigned char b = (unsigned char)suffix[i];

        if (a >= 'A' && a <= 'Z')
            a = (unsigned char)(a - 'A' + 'a');
        if (a != b)
            return 0;
    }
    return 1;
}

static void write_header(FILE *fp, int where, int len,
                         const unsigned char name[16], int left, int cas)
{
    unsigned char hdr[32];
    int i;

    memset(hdr, 0, sizeof(hdr));
    hdr[0] = (unsigned char)where;
    hdr[1] = (unsigned char)(where >> 8);
    hdr[2] = hdr[4] = hdr[19] = (unsigned char)len;
    hdr[3] = hdr[5] = hdr[20] = (unsigned char)(len >> 8);
    memcpy(hdr + 6, name, 8);
    hdr[14] = 'B';
    hdr[15] = 'A';
    hdr[16] = 'S';
    hdr[17] = 'B';
    hdr[18] = 'N';
    memcpy(hdr + 23, name + 8, 8);
    hdr[31] = (unsigned char)left;

    if (cas) {
        for (i = 0; i < 48; i++)
            writebyte(0, fp);
    }
    for (i = 0; i < 32; i++)
        writebyte(hdr[i], fp);
    if (cas) {
        for (i = 0; i < 256 - 80; i++)
            writebyte(0, fp);
    }
}

int p2000_exec(char *target)
{
    char filename[FILENAME_MAX + 1];
    unsigned char name[16];
    FILE *fpin, *fpout;
    int len, blocks, left, remaining, cas;
    long pos;

    if (help || binname == NULL)
        return -1;

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, p2000t ? ".p2000t" : ".cas");
    } else {
        strcpy(filename, outfile);
    }
    cas = !ends_with(filename, ".p2000t");

    if ((fpin = fopen_bin(binname, NULL)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file\n");
    }

    len = (int)ftell(fpin);
    if (len < 0) {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file\n");
    }

    blocks = (len == 0) ? 1 : (len + 1023) / 1024;
    if (len > 65535 || blocks > 255) {
        fclose(fpin);
        exit_log(1, "File is too long for a P2000 cassette header\n");
    }

    fseek(fpin, 0L, SEEK_SET);

    if (origin == -1) {
        pos = (crtfile != NULL) ? get_org_addr(crtfile) : -1;
        origin = (pos < 0) ? 0x6547 : (int)pos;
    }

    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1, "Can't open output file\n");
    }

    if (blockname == NULL)
        blockname = zbasename(binname);
    map_name(blockname, name);

    remaining = len;
    for (left = blocks; left > 0; left--) {
        int n = (remaining > 1024) ? 1024 : remaining;
        int i;

        write_header(fpout, origin, len, name, left, cas);
        for (i = 0; i < n; i++) {
            int c = getc(fpin);

            writebyte((c == EOF) ? 0 : c, fpout);
        }
        for (i = n; i < 1024; i++)
            writebyte(0, fpout);
        remaining -= n;
    }

    fclose(fpin);
    fclose(fpout);
    return 0;
}
