/*
 *
 *   z88dk Application Generator (appmake)
 *
 *
 *   $Id: appmake.h $
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

#if defined(__GNUC__) || defined(__clang__)
#ifndef __NORETURN
#define __NORETURN __attribute((noreturn))
#endif
#endif

#ifndef __NORETURN
#define __NORETURN 
#endif

#include "dirname.h"
#include "cpmdisk.h"

extern char c_install_dir[];

/* Conversion routines */

typedef void (*option_cb)(char *param);
#define OPT_BASE_MASK 127
typedef enum { OPT_NONE, OPT_BOOL, OPT_INT, OPT_STR, OPT_FUNCTION, OPT_INPUT=128, OPT_OUTPUT=256 } type_t;

#ifndef WIN32
enum { FALSE = 0, TRUE };
#endif


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
#ifndef strcasecmp
#define strcasecmp(a,b) stricmp(a,b)
#endif
#endif


#ifdef MAIN_C
extern int       abc80_exec(char *target);
extern option_t  abc80_options;

extern int       acetap_exec(char *target);
extern option_t  acetap_options;

extern int       adam_exec(char *target);
extern option_t  adam_options;

extern int       aquarius_exec(char *target);
extern option_t  aquarius_options;

extern int       c128_exec(char *target);
extern option_t  c128_options;

extern int       c7420_exec(char *target);
extern option_t  c7420_options;

extern int       cpc_exec(char *target);
extern option_t  cpc_options;

extern int       cpm2_exec(char *target);
extern option_t  cpm2_options;

extern int       dai_exec(char *target);
extern option_t  dai_options;

extern int       enterprise_exec(char *target);
extern option_t  enterprise_options;

extern int       fat_exec(char *target);
extern option_t  fat_options;

extern int       fp1100_exec(char *target);
extern option_t  fp1100_options;

extern int       gal_exec(char *target);
extern option_t  gal_options;

extern int       gb_exec(char *target);
extern option_t  gb_options;


extern int       hex_exec(char *target);
extern option_t  hex_options;

extern int       homelab_exec(char *target);
extern option_t  homelab_options;

extern int       inject_exec(char *target);
extern option_t  inject_options;
extern char      inject_longhelp[];

extern int       extract_exec(char *target);
extern option_t  extract_options;
extern char      extract_longhelp[];

extern int       lviv_exec(char *target);
extern option_t  lviv_options;

extern int       lynx_exec(char *target);
extern option_t  lynx_options;

extern int       m5_exec(char *target);
extern option_t  m5_options;

extern int       mamepp_exec(char *target);
extern option_t  mamepp_options;

extern int       mameql_exec(char *target);
extern option_t  mameql_options;

extern int       mc_exec(char *target);
extern option_t  mc_options;

extern int       mgt_exec(char *target);
extern option_t  mgt_options;

extern int       msx_exec(char *target);
extern option_t  msx_options;

extern int       msxrom_exec(char *target);
extern option_t  msxrom_options;

extern int       mtx_exec(char *target);
extern option_t  mtx_options;

extern int       multi8_exec(char *target);
extern option_t  multi8_options;

extern int       mz_exec(char *target);
extern option_t  mz_options;

extern int       mz2500_exec(char *target);
extern option_t  mz2500_options;

extern int       nascom_exec(char *target);
extern option_t  nascom_options;

extern int       nec_exec(char *target);
extern option_t  nec_options;

extern int       noop_exec(char *target);
extern option_t  noop_options;

extern int       ondra_exec(char *target);
extern option_t  ondra_options;

extern int       pasopia7_exec(char *target);
extern option_t  pasopia7_options;

extern int       pc88_exec(char *target);
extern option_t  pc88_options;

extern int       pc88disc_exec(char *target);
extern option_t  pc88disc_options;

extern int       p2000_exec(char *target);
extern option_t  p2000_options;

extern int       px_exec(char *target);
extern option_t  px_options;

extern int       rk_exec(char *target);
extern option_t  rk_options;

extern int       smc777_exec(char *target);
extern option_t  smc777_options;

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

extern int       glue_exec(char *target);
extern option_t  glue_options;

extern int       residos_exec(char *target);
extern option_t  residos_options;

extern int       pmd85_exec(char *target);
extern option_t  pmd85_options;

extern int       sc3000_exec(char *target);
extern option_t  sc3000_options;

extern int       sms_exec(char *target);
extern option_t  sms_options;

extern int       sol20_exec(char *target);
extern option_t  sol20_options;

extern int       spc1000_exec(char *target);
extern option_t  spc1000_options;

extern int       svi_exec(char *target);
extern option_t  svi_options;

extern int       tixx_exec(char *target);
extern option_t  tixx_options;

#ifndef _MSC_VER
extern int       ti8xk_exec(char *target);
extern option_t  ti8xk_options;
#else
// GMP can't be used in msbuild (see PR #2433)
static int ti8xk_exec(char *target){
  fprintf(stderr, "TI8xk disabled for msbuild!");
  return 0;
}
#define ti8xk_options tixx_options
#endif

extern int       trs80_exec(char *target);
extern option_t  trs80_options;

extern int       vector06c_exec(char *target);
extern option_t  vector06c_options;

extern int       vg5k_exec(char *target);
extern option_t  vg5k_options;

extern int       vz_exec(char *target);
extern option_t  vz_options;
extern int       laser500_exec(char *target);
extern option_t  laser500_options;

extern int       x07_exec(char *target);
extern option_t  x07_options;

extern int       x1_exec(char *target);
extern option_t  x1_options;

extern int       z1013_exec(char *target);
extern option_t  z1013_options;

extern int       z9001_exec(char *target);
extern option_t  z9001_options;

extern int       kc_exec(char *target);
extern option_t  kc_options;

extern int       z88_exec(char *target);
extern option_t  z88_options;

extern int       z88elf_exec(char *target);
extern option_t  z88elf_options;

extern int       z88shell_exec(char *target);
extern option_t  z88shell_options;

extern int       zx_exec(char *target);
extern option_t  zx_options;

extern int       zxn_exec(char *target);
extern option_t  zxn_options;

extern int       zxvgs_exec(char *target);
extern option_t  zxvgs_options;

extern int       zx81_exec(char *target);
extern option_t  zx81_options;

extern int       tvc_exec(char *target);
extern option_t  tvc_options;

extern int       primo_exec(char *target);
extern option_t  primo_options;


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
    { "bin2dpp",  "adam",    "(C) 2021 z88dk",
      "Generates a .DDP for ADAM machines",
      NULL,
      adam_exec,   &adam_options },
    { "bin2caq",  "aquarius", "(C) 2001 Stefano Bodrato",
      "Creates a BASIC loader file and binary stored in variable array format",
      NULL,
      aquarius_exec,   &aquarius_options },
    { "bin3000",  "c128",      "(C) 2001 Stefano Bodrato",
      "Adds a c128 style disk file header",
      NULL,
      c128_exec,   &c128_options },
    { "bin7420",   "c7420",    "(C) 2015 Stefano Bodrato",
      "Philips Videopac C7420 cassette format conversion",
      NULL,
      c7420_exec,    &c7420_options },
    { "bin2cpc",  "cpc",      "(C) 2003 Dominic Morris, (C) 1997 Pierre Thevenet",
      "Creates an AMSDOS file suitable for writing to a .DSK image, opt. WAV",
      NULL,
      cpc_exec,   &cpc_options },
    { "cpmdisk",  "cpmdisk",   "(C) 2018 dom",
      "CPM disk image creation",
      NULL,
      cpm2_exec,     &cpm2_options },
    { "bin2dai",  "dai",   "(C) 2020 z88dk",
      "DAI cassete image creater",
      NULL,
      dai_exec,     &dai_options },
    { "bin2ep",   "enterprise",      "(C) 2011 Stefano Bodrato",
      "Adds a type 5 header to make a .app file",
      NULL,
      enterprise_exec,   &enterprise_options },
    { "extract", "extract",      "(C) 2015 Alvin Albrecht",
      "Extracts bytes from input file",
      extract_longhelp,
      extract_exec,    &extract_options },
    { "bin2fat",  "fat",      "(C) 2019 dom + ChaN",
      "Creates a FAT disc for many platforms",
      NULL,
      fat_exec,   &fat_options },
    { "fp1kd88",  "fp1100",      "(C) 2018 Dominic Morris",
      "Creates a .d88 for the Casio FP-1100",
      NULL,
      fp1100_exec,   &fp1100_options },
    { "bin2gtp",  "gal",      "(C) 2007,2008 Tomaz Solc & Stefano Bodrato",
      "Creates a tape file image for the Galaksija micro",
      NULL,
      gal_exec,   &gal_options },
    { "makebin",  "gb",      "(C) 2000 - 2019 gbdk + z88dk",
      "Creates a ROM image for the Gameboy",
      NULL,
      gb_exec,   &gb_options },
    { "gluebin", "glue", "(C) 2017 Alvin Albrecht",
      "Glue several output binaries into a single binary representing memory",
       NULL,
       glue_exec, &glue_options },
    { "bin2hex",  "hex",      "(C) 2001 Dominic Morris & Jeff Brown",
      "Creates an intel hex record suitable for embedded devices",
      NULL,
      hex_exec,     &hex_options },
    { "bin2htp",  "homelab",  "(C) 2020 z88dk",
      "Creates a .htp file for Homelab emulators",
      NULL,
      homelab_exec,    &homelab_options },
    { "inject",  "inject",      "(C) 2014 Dominic Morris",
      "Injects files within other files",
      inject_longhelp,
      inject_exec,     &inject_options },
    { "kcc",      "kc",          "(C) 2016 Stefano Bodrato",
      "Prapares a .KCC file for the VEB MPM KC85/2..KC85/4",
      NULL,
      kc_exec,       &kc_options },
    { "laser2cas", "laser500",     "(C) 2010-2018 Stefano Bodrato",
      "Convert the Laser 350/500/700 .vz file to .cas, optionally to WAV",
      NULL,
      laser500_exec,    &laser500_options },
    { "bin2lvt",  "lviv",          "(C) 2020 z88dk",
      "Generates an LVT file for the Livi PK-01",
      NULL,
      lviv_exec,     &lviv_options },
    { "lynxtap",  "lynx",      "(C) 2014 Stefano Bodrato",
      "Generates a tape file for the Camputers Lynx, opt. WAV",
      NULL,
      lynx_exec,     &lynx_options },
    { "bin2m5",   "m5",      "(C) 2010 Stefano Bodrato",
      "Generates a tape file for the Sord M5, optional WAV file",
      NULL,
      m5_exec,   &m5_options },
    { "bin2pp",   "mamepp",  "(C) 2020 z88dk",
      "Create a Mame quickload file (pp)",
      NULL,
      mamepp_exec,   &mamepp_options },
    { "bin2mql",   "mameql",  "(C) 2018 dom",
      "Create a Mame quickload file (z80bin)",
      NULL,
      mameql_exec,   &mameql_options },
    { "mc1000",   "mc",      "(C) 2013 Stefano Bodrato",
      "Generates a CAS file for the CCE MC-1000, optional WAV file",
      NULL,
      mc_exec,   &mc_options },
    { "bin2mgt",  "mgt",      "(C) 2021 z88dk",
      "Creates an MGT disc",
      NULL,
      mgt_exec,     &mgt_options },
    { "bin2msx",  "msx",      "(C) 2001 Stefano Bodrato",
      "Adds a file header to enable the program to be loaded using 'bload \"file.bin\",r",
      NULL,
      msx_exec,     &msx_options },
    { "bin2msr",  "msxrom",   "(C) 2020 z88dk",
      "Generates an MSX rom file.",
      NULL,
      msxrom_exec,  &msxrom_options },
    { "bin2mtx",  "mtx",      "(C) 2011 Stefano Bodrato",
      "Memotech MTX file format packaging, optional WAV format",
      NULL,
      mtx_exec,     &mtx_options },
    { "bin2m8",   "multi8",   "(C) 2018 Dominic Morris",
      "Generates a tape file for the Mitsubishi Multi8 computers",
      NULL,
      multi8_exec,      &multi8_options },
    { "bin2m12",  "mz",       "(C) 2000,2003 S. Bodrato, J.F.J. Laros, M. Nemecek",
      "Generates a tape file for the Sharp MZ computers",
      NULL,
      mz_exec,      &mz_options },
    { "bin2mz",  "mz2500",    "(C) 2018 S. Bodrato",
      "Generates a tape file for the Sharp MZ2500 computers",
      NULL,
      mz2500_exec,      &mz2500_options },
    { "bin2nas",   "nas",       "(C) 2003 Stefano Bodrato",
      "Generates a .NAS file suitable for use by emulators",
      NULL,
      nascom_exec,    &nascom_options },
    { "hex2cas",   "nec",       "(C) 2003,2007 Takahide Matsutsuka",
      "PC-6001 (and others) CAS format conversion utility",
      NULL,
      nec_exec,    &nec_options },
    { "bin2nwbn",  "newbrain",       "(C) 2007 Stefano Bodrato",
      "BASIC loader + data block in Tape format or plain TXT (less efficient)",
      NULL,
      newbrain_exec,    &newbrain_options },
    { "newext",  "newext",      "(C) 2014 Stefano Bodrato",
      "Changes the binary file extension for CP/M and others",
      NULL,
      newext_exec,   &newext_options },
    { "bin2bin",   "noop",       "(C) 2020 z88dk",
      "A noop operator, does nothing",
      NULL,
      noop_exec,    &noop_options },
    { "bin2otp",   "ondra",       "(C) 2020 z88dk",
      "Convert binary file to Ondra .tap file",
      NULL,
      ondra_exec,    &ondra_options },
    { "mc2cas",   "p2000",      "(C) 2014 Stefano Bodrato",
      "Philips P2000 MicroCassette to CAS format conversion",
      NULL,
      p2000_exec,    &p2000_options },
    { "bin2pas",   "pasopia7",  "(C) 2019 z88dk",
      "Convert binary file to .wav",
      NULL,
      pasopia7_exec,    &pasopia7_options },
    { "bin2t88",   "pc88",       "(C) 2018 Stefano Bodrato",
      "PC-8801 T88 format conversion utility",
      NULL,
      pc88_exec,    &pc88_options },
    { "bin2d88",   "pc88disc",   "(C) 2021 z88dk",
      "Create a PC88 bootable d88 disc",
      NULL,
      pc88disc_exec,    &pc88disc_options },
    { "bin2ptp",   "pmd85",       "(C) 2020 z88dk",
      "Create a PMD85 ptp file",
      NULL,
      pmd85_exec,    &pmd85_options },
    { "px2rom",   "px",       "(C) 2015 Stefano Bodrato",
      "Create an epson PX(HC) family compatible EPROM image",
      NULL,
      px_exec,   &px_options },
    { "bin2pkg",    "residos",       "(C) 2014 Dominic Morris",
      "Create the header for a Residos package",
      NULL,
      residos_exec,    &residos_options },
    { "mkaddin",   "rex",       "(C) 2001 Dominic Morris",
      "Creates a .rex application using data from a .res file and a .bin file",
      NULL,
      rex_exec,     &rex_options },
    { "bin2rk",    "rkx",  "(C) 2020 z88dk",
      "Create a rk? file for USSR RKs",
      NULL,
      rk_exec,        &rk_options },
    { "rompad",    "rom",       "(C) 2014,2017 Stefano Bodrato & Alvin Albrecht",
      "Embed a binary inside a rom, padding if necessary",
      NULL,
      rom_exec,    &rom_options },
    { "bin2smc",  "smc777",   "(C) 2021 z88dk",
      "Create a SMC-777 bootable d88 disc",
      NULL,
      smc777_exec,    &smc777_options },
    { "bin2ent",  "sol20",   "(C) 2021 z88dk",
      "Create a Sol20 ENT file",
      NULL,
      sol20_exec,    &sol20_options },
    { "sentinel",  "sos",       "(C) 2013 Stefano Bodrato",
      "Add a header for S-OS (The Sentinel)",
      NULL,
      sos_exec,    &sos_options },
    { "bin2spc",   "spc1000",   "(C) 2018 Dominic Morris",
      "Create a .SPC file suitable for emulators",
      NULL,
      spc1000_exec,    &spc1000_options },
    { "dgos",   "srr",       "(C) 2011, 2017 Stefano Bodrato",
      "DGOS, KCS variant for Sorcerer Exidy and Microbee, also WAV format",
      NULL,
      sorcerer_exec,    &sorcerer_options },
    { "bin2app",   "ti83papp",       "(C) 2023 z88dk, HeronErin, Spasm-ng",
      "Creates a .8xk file. This is for ti83p/ti84p flash apps. Requires to use the 83/84 app crt",
      NULL,
      ti8xk_exec,      &ti8xk_options },
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
    { "bin2sms",  "sms",       "(C) 2007 Dominic Morris",
      "Creates an sms file composed of a 32k main binary and 16k expansion banks",
      NULL,
      sms_exec,      &sms_options },
    { "bin2sc",   "sc3000",      "(C) 2010 Stefano Bodrato",
      "Packager for the SEGA SC-3000 / SF-7000, Kansas City Standard variant",
      NULL,
      sc3000_exec,   &sc3000_options },
    { "bin2svi",  "svi",       "(C) 2001 Stefano Bodrato",
      "Creates a .cas file loadable with the SVI emulator",
      NULL,
      svi_exec,      &svi_options },
    { "bin2cmd",  "trs80",    "(C) 2008 Stefano Bodrato",
      "Creates a CMD file for the TRS 80",
      NULL,
      trs80_exec,   &trs80_options },
    { "bin2cas",   "tvc",      "(C) 2019 Sandor Vass",
      "Generate TVC .cas file from the linked binary",
      NULL,
      tvc_exec,   &tvc_options },
    { "bin2pri",   "primo",      "(C) 2022 Sandor Vass",
      "Generate Primo .pri/.ptp file from the linked binary",
      NULL,
      primo_exec,   &primo_options },
    { "bin2fdd",  "vector06c", "(C) 2020 z88dk",
      "Create a bootable vector06c disk",
      NULL,
      vector06c_exec,    &vector06c_options },
    { "vg5k2k7",    "vg5k",     "(C) 2014 Stefano Bodrato",
      "Convert to Philips VG-5000 .k7 format, optionally to WAV",
      NULL,
      vg5k_exec,    &vg5k_options },
    { "vz2cas",    "vz",     "(C) 2010 Stefano Bodrato",
      "Convert the Laser 200 .vz file to .cas, optionally to WAV",
      NULL,
      vz_exec,    &vz_options },
    { "x07cas",     "x07",     "(C) 2011 Stefano Bodrato",
      "Prapares a .cas file for the Canon X-07, optional WAV format",
      NULL,
      x07_exec,    &x07_options },
    { "x1-2d",       "x1",     "(C) 2018 Stefano Bodrato",
      "Prapares a .2d disk image file for the Sharp X1",
      NULL,
      x1_exec,    &x1_options },
    { "z1013",      "z1013",     "(C) 2016 Stefano Bodrato",
      "Prapares a .z80 file for the Robotron Z1013, optional WAV format",
      NULL,
      z1013_exec,    &z1013_options },
    { "appz88",     "z88",      "(C) 2000,2003 Dominic Morris & Dennis Groning",
      "Generates .63 and .62 files suitable for burning to EPROM",
      NULL,
      z88_exec,     &z88_options },
    { "appelf",     "z88elf",      "(C) 2021 z88dk",
      "Generates an elf file for the z88 OZ5 shell",
      NULL,
      z88elf_exec,     &z88elf_options },
    { "shellmak",   "z88shell", "(C) 2002,2003 Dominic Morris",   
      "Patches the header to ensure that the program is recognised by the shell",
      NULL,
      z88shell_exec,&z88shell_options },
    { "kctape",     "z9001",      "(C) 2016 Stefano Bodrato",
      "Prapares a .TAP file for the Robotron Z9001, KC85/1, KC87",
      NULL,
      z9001_exec,     &z9001_options },
    { "bin2tap",  "zx",  "(C) 2000,2003,2017 Morris, Bodrato, Albrecht", 
      "Generates a .TAP file complete with BASIC header, optional WAV file\n"
      "Generates 48k/128k SNA Snapshots from binary files\n"
      "Generates ESXDOS dot commands",
      NULL,
      zx_exec,      &zx_options },
    { "bin2p",    "zx81",     "(C) 2000 Stefano Bodrato",                         
      "Generates a .P file suitable for use by emulators, optional WAV file",
      NULL,
      zx81_exec,    &zx81_options },
    { "zxnext",  "zxn",  "(C) 2000,2003,2017 Morris, Bodrato, Albrecht",
      "Generates a .TAP file complete with BASIC header, optional WAV file\n"
      "Generates 48k/128k SNA Snapshots from binary files\n"
      "Generates ESXDOS dot commands\n"
      "Generates BINARIES representing contents of all memory banks\n"
      "Generates ZXN monolithic programs",
      NULL,
      zxn_exec,     &zxn_options },
    { "appzxvgs",   "zxvgs",    "(C) 2003 Yarek",
      "Creates a zxvgs application file",
      NULL,
      zxvgs_exec,   &zxvgs_options},
    { NULL, NULL, NULL, NULL, NULL, NULL }
};
#endif




#define LINEMAX         80


extern void         exit_log(int code, char *fmt, ...) __NORETURN;
extern long         parameter_search(const char *filen,const  char *ext,const char *target);
extern FILE        *fopen_bin(const char *fname,const  char *crtfile);
extern long         get_org_addr(char *crtfile);
extern void         suffix_change(char *name, const char *suffix);
extern void         any_suffix_change(char *name, const char *suffix, char schar);

#define must_malloc_block(sz,sector_sz) must_malloc( ((sz/sector_sz)+1) * sector_sz)
extern void        *must_malloc(size_t sz);
extern void        *must_realloc(void *p, size_t sz);
extern void        *must_strdup(char *p);

extern void         writebyte(unsigned char c, FILE *fp);
extern void         writeword(unsigned int i, FILE *fp);
extern void         writelong(unsigned long i, FILE *fp);
extern void         writestring(char *mystring, FILE *fp);

extern void         writeword_be(unsigned int i, FILE *fp);

extern void         writeword_p(unsigned int i, FILE *fp,unsigned char *p);
extern void         writebyte_p(unsigned char c, FILE *fp,unsigned char *p);
extern void         writestring_p(char *mystring, FILE *fp,unsigned char *p);

extern void         writeword_pk(unsigned int i, FILE *fp,unsigned char *p);
extern void         writebyte_pk(unsigned char c, FILE *fp,unsigned char *p);
extern void         writestring_pk(char *mystring, FILE *fp,unsigned char *p);

extern void         writebyte_cksum(unsigned char c, FILE *fp, unsigned long *cksum);
extern void         writeword_cksum(unsigned int i, FILE *fp, unsigned long *cksum);
extern void         writestring_cksum(char *mystring, FILE *fp, unsigned long *cksum);


extern void         writebyte_b(unsigned char c, uint8_t **pptr);
extern void         writeword_b(unsigned int i, uint8_t **pptr);
extern void         writelong_b(unsigned long i, uint8_t **pptr);
extern void         writestring_b(char *mystring, uint8_t **pptr);

extern void         raw2wav(char *rawfilename);
extern void         raw2wav_22k(char *rawfilename, int mode);

extern void         zx_pilot(int pilot_len, FILE *fpout);
extern void         zx_rawbit(FILE *fpout, int period);
extern void         zx_rawout (FILE *fpout, unsigned char b, char fast);

extern long         get_file_size(FILE *fp);


/*  record size for bin2hex and other text encoding formats */
extern int          bin2hex(FILE *input, FILE *output, int address, uint32_t len, int recsize, int eofrec);
extern int          hexdigit(char digit);
extern uint32_t     num2bcd(uint32_t num);

/* snprintf is _snprintf in _MSC_VER */
#ifdef _MSC_VER
#define snprintf _snprintf
#define vsnprintf _vsnprintf
#endif

/* memory banks */

#define MAXBANKS  256     // maximum number of memory banks

// all pointers are dynamic data

struct section_bin
{
    char    *filename;       // name of file holding binary data
    uint32_t offset;         // offset into file to start of data
    char    *section_name;   // section name corresponding to binary data
    int      org;
    int      size;
};

struct memory_bank
{
    int    num;                   // number of sections in bank
    struct section_bin *secbin;   // array of sections
};

struct bank_space
{
    char *bank_id;                          // substring of section name that identifies a bank space
    struct memory_bank membank[MAXBANKS];   // independent 64k banks in bank space
    int   org;
    int   size;                             // non-zero indicates banks should output at fixed org with size indicated
};

struct banked_memory
{
    int    num;                      // number of independent bank spaces
    struct bank_space  *bankspace;   // an array of independent bank spaces
    struct memory_bank  mainbank;    // the main memory bank
};

struct section_aligned
{
    char *section_name;   // section name corresponding to aligned data
    int   alignment;      // power of two
    int   org;
    int   size;
};

struct aligned_data
{
    int num;                         // number of aligned sections
    struct section_aligned *array;   // array of sections
};

extern void mb_create_bankspace(struct banked_memory *memory, char *bank_id);
extern void mb_enumerate_banks(FILE *fmap, const char *binname, struct banked_memory *memory, struct aligned_data *aligned);
extern int  mb_find_bankspace(struct banked_memory *memory, char *bankspace_name);
extern int  mb_remove_bankspace(struct banked_memory *memory, char *bankspace_name);
extern int  mb_remove_bank(struct bank_space *bs, unsigned int index, int clean);
extern void mb_remove_mainbank(struct memory_bank *mb, int clean);
extern int  mb_find_section(struct banked_memory *memory, char *section_name, struct memory_bank **mb_r, int *secnum_r);
extern int  mb_remove_section(struct banked_memory *memory, char *section_name, int clean);
extern int  mb_user_remove_bank(struct banked_memory *memory, char *bankname);
extern int  mb_check_alignment(struct aligned_data *aligned);
extern int  mb_sort_banks(struct banked_memory *memory);
extern int  mb_output_section_binary(FILE *fbout, struct section_bin *sb);
extern int  mb_generate_output_binary(FILE *fbin, int filler, FILE *fhex, int ipad, int irecsz, struct memory_bank *mb, int borg, int bsize);
extern void mb_generate_output_binary_complete(char *binname, int ihex, int filler, int ipad, int irecsz, struct banked_memory *memory);
extern void mb_delete_source_binaries(struct banked_memory *memory);
extern void mb_cleanup_memory(struct banked_memory *memory);
extern void mb_cleanup_aligned(struct aligned_data *aligned);
extern int mb_print_info(struct banked_memory *memory);


/* mgt.c */
typedef enum {
    MGT_ERASE = 0,
    MGT_BASIC = 1,
    MGT_NUMBER_ARRAY = 2,
    MGT_STRING_ARRAY = 3,
    MGT_CODE = 4,
    MGT_SNAP48K = 5,
    MGT_MICRODRIVE = 6,
    MGT_SCREEN = 7,
    MGT_SPECIAL = 8,
    MGT_SNAP128K = 9,
    MGT_OPENTYPE = 10,
    MGT_EXECUTE = 11,
    MGT_SAM_BASIC = 16,
    MGT_SAM_NUMBER_ARRAY = 17,
    MGT_SAM_STRING_ARRAY = 18,
    MGT_SAM_CODE = 19,
    MGT_SAM_SCREEN = 20,
} mgt_filetype;
extern disc_handle *mgt_create(void);
extern void mgt_writefile(disc_handle *h, char mgt_filename[11], mgt_filetype filetype, int org, int isexec, unsigned char *data, size_t len);



/* lz49.c */
extern unsigned char *LZ49_encode(unsigned char *data, int length, int *retlength);
extern void LZ49_decode(unsigned char *data, unsigned char *odata);

