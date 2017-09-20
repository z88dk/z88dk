/*
*        ZX NEXT Application Generator
*        See also zx.c
*
*        Alvin Albrecht  - 09/2017
*/

#include "appmake.h"
#include "zx-util.h"

static struct zx_common zxc = {
    0,          // help
    NULL,       // binname
    NULL,       // crtfile
    NULL,       // outfile
    -1,         // origin
    NULL,       // excluded_banks
    NULL,       // excluded_sections
    0           // clean
};

static struct zx_tape zxt = {
    NULL,       // blockname
    NULL,       // merge
    -1,         // patchpos
    -1,         // clear_address
    NULL,       // patchdata
    NULL,       // screen
    0,          // audio
    0,          // ts2068
    0,          // turbo
    0,          // extreme
    0,          // fast
    0,          // dumb
    0,          // noloader
    0,          // noheader
    0           // parity
};

static struct zx_sna zxs = {
    -1,         // stackloc
    -1          // intstate
};

static char tap = 0;
static char sna = 0;
static char dot = 0;
static char zxn = 0;
static char bin = 0;

/* Options that are available for this module */
option_t zxn_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &zxc.help },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &zxc.crtfile },
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &zxc.binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &zxc.origin },
    { 'o', "output",   "Name of output file\n",      OPT_STR,   &zxc.outfile },

    {  0,  "sna",      "Make .sna instead of .tap",  OPT_BOOL, &sna },
    {  0,  "org",      "Start address of .sna",      OPT_INT,   &zxc.origin },
    {  0,  "sna-sp",   "Stack location in .sna",     OPT_INT,   &zxs.stackloc },
    {  0,  "sna-di",   "Di on start if non-zero (default = 0)", OPT_INT, &zxs.intstate },
    {  0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    {  0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    {  0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    {  0,  "dot",      "Make esxdos dot command instead of .tap\n", OPT_BOOL, &dot },

    {  0,  "audio",     "Create also a WAV file",    OPT_BOOL,  &zxt.audio },
    {  0,  "ts2068",    "TS2068 BASIC relocation (if possible)",  OPT_BOOL,  &zxt.ts2068 },
    {  0,  "turbo",     "Turbo tape loader",         OPT_BOOL,  &zxt.turbo },
    {  0,  "extreme",   "Extremely fast save (RLE)", OPT_BOOL,  &zxt.extreme },
    {  0,  "patchpos",  "Turbo tape patch position", OPT_INT,   &zxt.patchpos },
    {  0,  "patchdata", "Turbo tape patch (i.e. cd7fff..)", OPT_STR, &zxt.patchdata },
    {  0,  "screen",    "Title screen file name",    OPT_STR,   &zxt.screen },
    {  0,  "fast",      "Create a fast loading WAV", OPT_BOOL,  &zxt.fast },
    {  0,  "dumb",      "Just convert to WAV a tape file", OPT_BOOL, &zxt.dumb },
    {  0,  "noloader",  "Don't create the loader block", OPT_BOOL, &zxt.noloader },
    {  0,  "noheader",  "Don't create the header",   OPT_BOOL,  &zxt.noheader },
    {  0 , "merge",     "Merge a custom loader from external TAP file", OPT_STR, &zxt.merge },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &zxt.blockname },
    {  0,  "clearaddr", "Address to CLEAR at",       OPT_INT,   &zxt.clear_address },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


int zxn_exec(char *target)
{
    if (zxc.help)
        return -1;

    if (sna)
        return zx_sna(&zxc, &zxs, 0);

    if (dot)
        return zx_dot_command(&zxc);

    return zx_tape(&zxc, &zxt);
}
