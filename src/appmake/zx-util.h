#ifndef ZX_UTIL_H
#define ZX_UTIL_H

struct zx_common
{
    char           help;
    char          *binname;
    char          *crtfile;
    char          *outfile;
    int            origin;
    char          *banked_space;
    char          *excluded_banks;
    char          *excluded_sections;
    char           clean;
    int            main_fence;
    char           pages;
    FILE          *file;
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
    char           force_128;
    char           snx;
    char           xsna;
    FILE          *fsna;
};

struct zx_bin
{
    char           fullsize;
    int            romfill;
    char           ihex;
    char           ipad;
    int            recsize;
};

struct zxn_nex
{
    char          *screen;
    int            border;
};

extern int  z88dk_ffs(int n);
extern void zxn_construct_page_contents(unsigned char *mem, struct memory_bank *mb, int mbsz, int fillbyte);

extern int zx_tape(struct zx_common *zxc, struct zx_tape *zxt);
extern int zx_dot_command(struct zx_common *zxc, struct banked_memory *memory);
extern int zxn_dotn_command(struct zx_common *zxc, struct banked_memory *memory, int fillbyte);
extern int zxn_universal_dot(struct zx_common *zxc);
extern int zx_sna(struct zx_common *zxc, struct zx_sna *zxs, struct banked_memory *memory, int is_zxn);
extern int zxn_nex(struct zx_common *zxc, struct zxn_nex *zxnex, struct banked_memory *memory, int fillbyte);

#endif
