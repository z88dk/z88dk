/*
 *
 *   z88dk Application Generator (appmake)
 *
 *
 *   $Id: appmake.h,v 1.63 2016-11-06 05:14:02 aralbrec Exp $
 */



#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <string.h>
#include <stdarg.h>
#include <stdint.h>
#include <sys/stat.h>
#ifndef WIN32
#include <unistd.h>
#endif

/* Conversion routines */

#define OPT_BASE_MASK 127
typedef enum { OPT_NONE, OPT_BOOL, OPT_INT, OPT_STR, OPT_INPUT=128, OPT_OUTPUT=256 } type_t;

enum { FALSE = 0, TRUE };

typedef struct {
    char     sopt;
    char    *lopt;
    char    *desc;
    type_t   type;
    void    *dest;
} option_t;

#ifdef _WIN32
#ifndef strncasecmp
#define strncasecmp(a,b,c) strnicmp(a,b,c)
#endif
#endif


#ifdef MAIN_C
extern int       abc80_exec(char *target);
extern option_t  abc80_options;

extern int       acetap_exec(char *target);
extern option_t  acetap_options;

extern int       aquarius_exec(char *target);
extern option_t  aquarius_options;

extern int       c128_exec(char *target);
extern option_t  c128_options;

extern int       c7420_exec(char *target);
extern option_t  c7420_options;

extern int       cpc_exec(char *target);
extern option_t  cpc_options;

extern int       enterprise_exec(char *target);
extern option_t  enterprise_options;

extern int       gal_exec(char *target);
extern option_t  gal_options;

extern int       hex_exec(char *target);
extern option_t  hex_options;

extern int       inject_exec(char *target);
extern option_t  inject_options;
extern char      inject_longhelp[];

extern int       extract_exec(char *target);
extern option_t  extract_options;
extern char      extract_longhelp[];

extern int       lynx_exec(char *target);
extern option_t  lynx_options;

extern int       m5_exec(char *target);
extern option_t  m5_options;

extern int       mc_exec(char *target);
extern option_t  mc_options;

extern int       msx_exec(char *target);
extern option_t  msx_options;

extern int       mtx_exec(char *target);
extern option_t  mtx_options;

extern int       mz_exec(char *target);
extern option_t  mz_options;

extern int       nascom_exec(char *target);
extern option_t  nascom_options;

extern int       nec_exec(char *target);
extern option_t  nec_options;

extern int       p2000_exec(char *target);
extern option_t  p2000_options;

extern int       px_exec(char *target);
extern option_t  px_options;

extern int       sorcerer_exec(char *target);
extern option_t  sorcerer_options;

extern int       sos_exec(char *target);
extern option_t  sos_options;

extern int       newbrain_exec(char *target);
extern option_t  newbrain_options;

extern int       newext_exec(char *target);
extern option_t  newext_options;

extern int       rex_exec(char *target);
extern option_t  rex_options;

extern int       rom_exec(char *target);
extern option_t  rom_options;

extern int       residos_exec(char *target);
extern option_t  residos_options;

extern int       sc3000_exec(char *target);
extern option_t  sc3000_options;

extern int       sms_exec(char *target);
extern option_t  sms_options;

extern int       svi_exec(char *target);
extern option_t  svi_options;

extern int       tixx_exec(char *target);
extern option_t  tixx_options;

extern int       trs80_exec(char *target);
extern option_t  trs80_options;

extern int       vg5k_exec(char *target);
extern option_t  vg5k_options;

extern int       vz_exec(char *target);
extern option_t  vz_options;

extern int       x07_exec(char *target);
extern option_t  x07_options;

extern int       z1013_exec(char *target);
extern option_t  z1013_options;

extern int       z9001_exec(char *target);
extern option_t  z9001_options;

extern int       kc_exec(char *target);
extern option_t  kc_options;

extern int       z88_exec(char *target);
extern option_t  z88_options;

extern int       z88shell_exec(char *target);
extern option_t  z88shell_options;

extern int       zx_exec(char *target);
extern option_t  zx_options;

extern int       zxvgs_exec(char *target);
extern option_t  zxvgs_options;

extern int       zx81_exec(char *target);
extern option_t  zx81_options;



struct {
    char      *execname;
    char      *ident;
    char      *copyright;
    char      *desc;
    char      *longdesc;
    int      (*exec)();
    option_t  *options;
} machines[] = {
    { "abccas",  "abc80",    "(C) 2000 Stefano Bodrato, (C) 2008 Robert Juhasz ",
      "Creates a BASIC loader and a tape file for the ABC computers",
      NULL,
      abc80_exec,   &abc80_options },
    { "acetap",  "ace",    "(C) 2001 Stefano Bodrato",
      "Generates a .TAP for the Ace32 emulator, optional WAV file",
      NULL,
      acetap_exec,   &acetap_options },
    { "bin2caq",  "aquarius", "(C) 2001 Stefano Bodrato",
      "Creates a BASIC loader file and binary stored in variable array format",
      NULL,
      aquarius_exec,   &aquarius_options },
    { "bin3000",  "c128",      "(C) 2001 Stefano Bodrato",
      "Adds a c128 style disk file header",
      NULL,
      c128_exec,   &c128_options },
    { "bin2cpc",  "cpc",      "(C) 2003 Dominic Morris, (C) 1997 Pierre Thevenet",
      "Creates an AMSDOS file suitable for writing to a .DSK image, opt. WAV",
      NULL,
      cpc_exec,   &cpc_options },
    { "bin2ep",   "enterprise",      "(C) 2011 Stefano Bodrato",
      "Adds a type 5 header to make a .app file",
      NULL,
      enterprise_exec,   &enterprise_options },
    { "bin2gtp",  "gal",      "(C) 2007,2008 Tomaz Solc & Stefano Bodrato",
      "Creates a tape file image for the Galaksija micro",
      NULL,
      gal_exec,   &gal_options },
    { "bin2hex",  "hex",      "(C) 2001 Dominic Morris & Jeff Brown",
      "Creates an intel hex record suitable for embedded devices",
      NULL,
      hex_exec,     &hex_options },
    { "newext",  "newext",      "(C) 2014 Stefano Bodrato",
      "Changes the binary file extension for CP/M and others",
      NULL,
      newext_exec,   &newext_options },
    { "inject",  "inject",      "(C) 2014 Dominic Morris",
      "Injects files within other files",
      inject_longhelp,
      inject_exec,     &inject_options },
    { "extract", "extract",      "(C) 2015 Alvin Albrecht",
      "Extracts bytes from input file",
      extract_longhelp,
      extract_exec,    &extract_options },
    { "kcc",      "kc",          "(C) 2016 Stefano Bodrato",
      "Prapares a .KCC file for the Robotron KC85/2..KC85/4",
      NULL,
      kc_exec,       &kc_options },
    { "lynxtap",  "lynx",      "(C) 2014 Stefano Bodrato",
      "Generates a tape file for the Camputers Lynx, opt. WAV",
      NULL,
      lynx_exec,     &lynx_options },
    { "bin2m5",   "m5",      "(C) 2010 Stefano Bodrato",
      "Generates a tape file for the Sord M5, optional WAV file",
      NULL,
      m5_exec,   &m5_options },
    { "mc1000",   "mc",      "(C) 2013 Stefano Bodrato",
      "Generates a CAS file for the CCE MC-1000, optional WAV file",
      NULL,
      mc_exec,   &mc_options },
    { "bin2msx",  "msx",      "(C) 2001 Stefano Bodrato",
      "Adds a file header to enable the program to be loaded using 'bload \"file.bin\",r",
      NULL,
      msx_exec,     &msx_options },
    { "bin2mtx",  "mtx",      "(C) 2011 Stefano Bodrato",
      "Memotech MTX file format packaging, optional WAV format",
      NULL,
      mtx_exec,     &mtx_options },
    { "bin2m12",  "mz",       "(C) 2000,2003 S. Bodrato, J.F.J. Laros, M. Nemecek",
      "Generates a tape file for the Sharp MZ computers",
      NULL,
      mz_exec,      &mz_options },
    { "bin2nas",   "nas",       "(C) 2003 Stefano Bodrato",
      "Generates a .NAS file suitable for use by emulators",
      NULL,
      nascom_exec,    &nascom_options },
    { "hex2cas",   "nec",       "(C) 2003,2007 Takahide Matsutsuka",
      "PC-6001 (and others) CAS format conversion utility",
      NULL,
      nec_exec,    &nec_options },
    { "px2rom",   "px",       "(C) 2015 Stefano Bodrato",
      "Create an epson PX(HC) family compatible EPROM image",
      NULL,
      px_exec,   &px_options },
    { "mc2cas",   "p2000",      "(C) 2014 Stefano Bodrato",
      "Philips P2000 MicroCassette to CAS format conversion",
      NULL,
      p2000_exec,    &p2000_options },
    { "bin7420",   "c7420",    "(C) 2015 Stefano Bodrato",
      "Philips Videopac C7420 cassette format conversion",
      NULL,
      c7420_exec,    &c7420_options },
    { "bin2pkg",    "residos",       "(C) 2014 Dominic Morris",
      "Create the header for a Residos package",
      NULL,
      residos_exec,    &residos_options },
    { "rompad",    "rom",       "(C) 2014 Stefano Bodrato",
      "Embed a binary inside a rom, padding if necessary",
      NULL,
      rom_exec,    &rom_options },
    { "dgos",   "srr",       "(C) 2011, 2017 Stefano Bodrato",
      "DGOS, KCS variant for Sorcerer Exidy and Microbee, also WAV format",
      NULL,
      sorcerer_exec,    &sorcerer_options },
    { "sentinel",  "sos",       "(C) 2013 Stefano Bodrato",
      "Add a header for S-OS (The Sentinel)",
      NULL,
      sos_exec,    &sos_options },
    { "bin2nwbn",  "newbrain",       "(C) 2007 Stefano Bodrato",
      "BASIC loader + data block in Tape format or plain TXT (less efficient)",
      NULL,
      newbrain_exec,    &newbrain_options },
    { "mkaddin",   "rex",       "(C) 2001 Dominic Morris",
      "Creates a .rex application using data from a .res file and a .bin file",
      NULL,
      rex_exec,     &rex_options },
    { "bin2var",   "ti82",       "(C) 2000,2003 David Phillips et al",
      "Creates a .82p file",
      NULL,
      tixx_exec,      &tixx_options },
    { "bin2var",   "ti83",       "(C) 2000,2003 David Phillips et al",
      "Creates a .83p file",
      NULL,
      tixx_exec,      &tixx_options },
    { "bin2var",   "ti8x",       "(C) 2000,2003 David Phillips et al",
      "Creates a .8xp file",
      NULL,
      tixx_exec,      &tixx_options },
    { "bin2var",   "ti85",       "(C) 2000,2003 David Phillips et al",
      "Creates a .85p file",
      NULL,
      tixx_exec,      &tixx_options },
    { "bin2var",   "ti86",       "(C) 2000,2003 David Phillips et al",
      "Creates a .86p file",
      NULL,
      tixx_exec,      &tixx_options },
    { "bin2var",   "ti86s",       "(C) 2000,2003 David Phillips et al",
      "Creates a .86s file",
      NULL,
      tixx_exec,      &tixx_options },
    { "bin2svi",  "svi",       "(C) 2001 Stefano Bodrato",
      "Creates a .cas file loadable with the SVI emulator",
      NULL,
      svi_exec,      &svi_options },
    { "bin2sms",  "sms",       "(C) 2007 Dominic Morris",
      "Creates an sms file composed of a 32k main binary and 16k expansion banks",
      NULL,
      sms_exec,      &sms_options },
    { "bin2cmd",  "trs80",    "(C) 2008 Stefano Bodrato",
      "Creates a CMD file for the TRS 80",
      NULL,
      trs80_exec,   &trs80_options },
    { "bin2sc",   "sc3000",      "(C) 2010 Stefano Bodrato",
      "Packager for the SEGA SC-3000 / SF-7000, Kansas City Standard variant",
      NULL,
      sc3000_exec,   &sc3000_options },
    { "vz2cas",    "vz",     "(C) 2010 Stefano Bodrato",
      "Convert the Laser 200 .vz file to .cas, optionally to WAV",
      NULL,
      vz_exec,    &vz_options },
    { "vg5k2k7",    "vg5k",     "(C) 2014 Stefano Bodrato",
      "Convert to Philips VG-5000 .k7 format, optionally to WAV",
      NULL,
      vg5k_exec,    &vg5k_options },
    { "appz88",   "z88",      "(C) 2000,2003 Dominic Morris & Dennis Groning",
      "Generates .63 and .62 files suitable for burning to EPROM",
      NULL,
      z88_exec,     &z88_options },
    { "x07cas",    "x07",     "(C) 2011 Stefano Bodrato",
      "Prapares a .cas file for the Canon X-07, optional WAV format",
      NULL,
      x07_exec,    &x07_options },
    { "z1013",    "z1013",     "(C) 2016 Stefano Bodrato",
      "Prapares a .z80 file for the Robotron Z1013, optional WAV format",
      NULL,
      z1013_exec,    &z1013_options },
    { "kctape",   "z9001",      "(C) 2016 Stefano Bodrato",
      "Prapares a .TAP file for the Robotron Z9001, KC85/1, KC87",
      NULL,
      z9001_exec,     &z9001_options },
    { "shellmak", "z88shell", "(C) 2002,2003 Dominic Morris",   
      "Patches the header to ensure that the program is recognised by the shell",
      NULL,
      z88shell_exec,&z88shell_options },
    { "appzxvgs", "zxvgs",    "(C) 2003 Yarek",
      "Creates a zxvgs application file",
      NULL,
      zxvgs_exec,   &zxvgs_options},
    { "bin2tap",  "zx",       "(C) 2000,2003 Dominic Morris & Stefano Bodrato", 
      "Generates a .TAP file complete with BASIC header, optional WAV file",
      NULL,
      zx_exec,      &zx_options },
    { "bin2p",    "zx81",     "(C) 2000 Stefano Bodrato",                         
      "Generates a .P file suitable for use by emulators, optional WAV file",
      NULL,
      zx81_exec,    &zx81_options },
    { NULL, NULL, NULL, NULL, NULL, NULL }
};
#endif




#define LINEMAX         80


#define myexit(buf, code) exit_log(code, buf)
extern void         exit_log(int code, char *fmt, ...);
extern long         parameter_search(char *filen, char *ext,char *target);
extern FILE         *fopen_bin(char *fname, char *crtfile);
extern FILE         *fopen_data(char *fname);
extern long         get_org_addr(char *crtfile);
extern void         suffix_change(char *name, char *suffix);
extern void         any_suffix_change(char *name, char *suffix, char schar);

extern void         writebyte(unsigned char c, FILE *fp);
extern void         writeword(unsigned int i, FILE *fp);
extern void         writelong(unsigned long i, FILE *fp);
extern void         writestring(char *mystring, FILE *fp);

extern void         writeword_p(unsigned int i, FILE *fp,unsigned char *p);
extern void         writebyte_p(unsigned char c, FILE *fp,unsigned char *p);
extern void         writestring_p(char *mystring, FILE *fp,unsigned char *p);

extern void         writeword_pk(unsigned int i, FILE *fp,unsigned char *p);
extern void         writebyte_pk(unsigned char c, FILE *fp,unsigned char *p);
extern void         writestring_pk(char *mystring, FILE *fp,unsigned char *p);

extern void         writebyte_cksum(unsigned char c, FILE *fp, unsigned long *cksum);
extern void         writeword_cksum(unsigned int i, FILE *fp, unsigned long *cksum);
extern void         writestring_cksum(char *mystring, FILE *fp, unsigned long *cksum);

extern void         raw2wav(char *rawfilename);

extern void         zx_pilot(int pilot_len, FILE *fpout);
extern void         zx_rawbit(FILE *fpout, int period);
extern void         zx_rawout (FILE *fpout, unsigned char b, char fast);

/*  record size for bin2hex and other text encoding formats */
#define RECSIZE 16
extern int          bin2hex(FILE *input, FILE *output, int address);
extern int          hexdigit(char digit);
extern uint32_t     num2bcd(uint32_t num);

/* snprintf is _snprintf in _MSC_VER */
#ifdef _MSC_VER
#define snprintf _snprintf
#define vsnprintf _vsnprintf
#endif
