#ifndef ZX_UTIL_H
#define ZX_UTIL_H

struct zx_common
{
    char           help;
    char          *binname;
    char          *crtfile;
    char          *outfile;
    int            origin;
    char          *excluded_banks;
    char          *excluded_sections;
    char           clean;
};

struct zx_tape
{
    char          *blockname;
    char          *merge;
    int            patchpos;
    int            clear_address;
    char          *patchdata;
    char          *screen;
    char           audio;
    char           ts2068;
    char           turbo;
    char           extreme;
    char           fast;
    char           dumb;
    char           noloader;
    char           noheader;
    unsigned char  parity;
};

struct zx_sna
{
    int            stackloc;
    int            intstate;
};

struct zx_bin
{
    char           fullsize;
    int            romfill;
    char           ihex;
    char           ipad;
    int            recsize;
};

extern int zx_tape(struct zx_common *zxc, struct zx_tape *zxt);
extern int zx_dot_command(struct zx_common *zxc);
extern int zx_sna(struct zx_common *zxc, struct zx_sna *zxs, struct banked_memory *memory, int is_zxn);


#endif
