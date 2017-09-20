/*
 *        Quick 'n' dirty mym to tap converter
 *
 *        Usage: bin2tap [binfile] [tapfile]
 *
 *        Dominic Morris  - 08/02/2000 - tapmaker
 *        Stefano Bodrato - 03/12/2000 - bin2tap
 *        Stefano Bodrato - 29/05/2001 - ORG parameter added
 *        Dominic Morris  - 10/03/2003 - integrated into appmake & options
 *        Stefano Bodrato - 19/07/2007 - BASIC block 'merge' feature
 *        Stefano Bodrato - 2010,2011  - AUDIO options and single BASIC block mode
 *        Stefano Bodrato - 01/02/2013 - Turbo tape option
 *        Stefano Bodrato - 13/02/2013 - Extreme turbo tape option
 *        Alvin Albrecht  - 08/2017    - ESXDOS dot command generation
 *        Alvin Albrecht  - 09/2017    - SNA snapshot generation
 *
 *        Creates a new TAP file (overwriting if necessary) just ready to run.
 *        You can use tapmaker to customize your work.
 * 
 *        If zorg=23760 the code is embedded in the BASIC program.
 *        (take care of the BASIC extension, 
 *              I.E. zorg=23813 if Interface 1 is activated).
 *        To know the exact location after the insertion of your disk interface,
 *        activate it (CLS #, CAT, RUN or similar), then type:
 *            PRINT PEEK 23635+256*PEEK 23636+5
 *        Advanced users can also see bin2bas-rem in the 'support/zx' directory
 *        and take benefit of the self-relocating code.
 * 
 *        The turbo tape option produces valid WAV files only.
 * 
 *        It can be combined with the '--fast' flag to achieve extra speed and
 *        with the '--screen' option to add a title screen.
 * 
 *        The '.tap' file is left for advanced users for hand-editing which
 *        can take benefit od the 'dumb' mode and 'patch' options
 *        (i.e. the extra compile options:
 *              -Cz--patchpos -Cz18 -Cz--patchdata -Czcd69ff
 *         ..will make the turbo loader ready to load an intermediate block
 *        (by default a title screen but it can be changed with a longer patch),
 *        then some more sound editing will be necessary to add the picture
 *        taken from a previously prepared audio file using the dumb/turbo options).
 * 
 *        See zx-util.c
 *
 *        $Id: zx.c,v 1.27 2016-09-17 05:09:40 aralbrec Exp $
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

static char sna = 0;
static char dot = 0;
static char bin = 0;

/* Options that are available for this module */
option_t zx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &zxc.help },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &zxc.crtfile },
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &zxc.binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &zxc.origin },
    { 'o', "output",   "Name of output file\n",      OPT_STR,   &zxc.outfile },

    { 0,  "sna",      "Make .sna instead of .tap",  OPT_BOOL,  &sna },
    { 0,  "org",      "Start address of .sna",      OPT_INT,   &zxc.origin },
    { 0,  "sna-sp",   "Stack location in .sna",     OPT_INT,   &zxs.stackloc },
    { 0,  "sna-di",   "Di on start if non-zero (default = 0)", OPT_INT, &zxs.intstate },
    { 0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    { 0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    { 0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    { 0,  "dot",      "Make esxdos dot command instead of .tap\n", OPT_BOOL, &dot },

    { 0,  "audio",     "Create also a WAV file",    OPT_BOOL,  &zxt.audio },
    { 0,  "ts2068",    "TS2068 BASIC relocation (if possible)",  OPT_BOOL,  &zxt.ts2068 },
    { 0,  "turbo",     "Turbo tape loader",         OPT_BOOL,  &zxt.turbo },
    { 0,  "extreme",   "Extremely fast save (RLE)", OPT_BOOL,  &zxt.extreme },
    { 0,  "patchpos",  "Turbo tape patch position", OPT_INT,   &zxt.patchpos },
    { 0,  "patchdata", "Turbo tape patch (i.e. cd7fff..)", OPT_STR, &zxt.patchdata },
    { 0,  "screen",    "Title screen file name",    OPT_STR,   &zxt.screen },
    { 0,  "fast",      "Create a fast loading WAV", OPT_BOOL,  &zxt.fast },
    { 0,  "dumb",      "Just convert to WAV a tape file", OPT_BOOL, &zxt.dumb },
    { 0,  "noloader",  "Don't create the loader block", OPT_BOOL, &zxt.noloader },
    { 0,  "noheader",  "Don't create the header",   OPT_BOOL,  &zxt.noheader },
    { 0 , "merge",     "Merge a custom loader from external TAP file", OPT_STR, &zxt.merge },
    { 0 , "blockname", "Name of the code block in tap file", OPT_STR, &zxt.blockname },
    { 0,  "clearaddr", "Address to CLEAR at",       OPT_INT,   &zxt.clear_address },
    { 0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


int zx_exec(char *target)
{   
    if (zxc.help)
        return -1;

    if (sna)
        return zx_sna(&zxc, &zxs, 0);

    if (dot)
        return zx_dot_command(&zxc);

    return zx_tape(&zxc, &zxt);
}
