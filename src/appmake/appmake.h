/* */



#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdarg.h>


/* Conversion routines */

typedef enum { OPT_NONE, OPT_BOOL, OPT_INT, OPT_STR } type_t;

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


#ifdef MAIN_C
extern int       abc80_exec(char *target);
extern option_t  abc80_options;

extern int       acebyt_exec(char *target);
extern option_t  acebyt_options;

extern int       acetap_exec(char *target);
extern option_t  acetap_options;

extern int       aquarius_exec(char *target);
extern option_t  aquarius_options;

extern int       cpc_exec(char *target);
extern option_t  cpc_options;

extern int       hex_exec(char *target);
extern option_t  hex_options;

extern int       msx_exec(char *target);
extern option_t  msx_options;

extern int       mz_exec(char *target);
extern option_t  mz_options;

extern int       nascom_exec(char *target);
extern option_t  nascom_options;

extern int       rex_exec(char *target);
extern option_t  rex_options;

extern int       svi_exec(char *target);
extern option_t  svi_options;

extern int       tixx_exec(char *target);
extern option_t  tixx_options;

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
    int      (*exec)();
    option_t  *options;
} machines[] = {
    { "bin2bas",  "abc80",    "(C) 2000 Stefano Bodrato",
      "",
      abc80_exec,   &abc80_options },
    { "bin2byt",  "ace",      "(C) 2001 Stefano Bodrato",
      "Generates a .byt file suitable for loading into emulators",
      acebyt_exec,   &acebyt_options },
    { "acetap",  "acetap",    "(C) 2001 Stefano Bodrato",
      "Generates a .TAP for the Ace32 emulator",
      acebyt_exec,   &acebyt_options },
    { "bin2caq",  "aquarius", "(C) 2001 Stefano Bodrato",
      "Creates a BASIC loader file and binary stored in variable array format",
      abc80_exec,   &abc80_options },
    { "bin2cpc",  "cpc",      "(C) 2003 Dominic Morris",
      "Creates an AMSDOS file suitable for writing to a .DSK image",
      cpc_exec,   &cpc_options },
    { "bin2hex",  "hex",      "(C) 2001 Dominic Morris & Jeff Brown",                         
      "Creates an intel hex record suitable for embedded devices",
      hex_exec,     &hex_options },
    { "bin2msx",  "msx",      "(C) 2001 Stefano Bodrato",                         
      "Adds a file header to enable the program to be loaded using 'bload \"file.bin\",r",
      msx_exec,     &msx_options },
    { "bin2m12",  "mz",       "(C) 2000 Stefano Bodrato",                         
      "",
      mz_exec,      &mz_options },
    { "bin2nas",   "nas",       "(C) 2003 Stefano Bodrato",                         
      "Generates a .NAS file suitable for use by emulators",
      nascom_exec,    &nascom_options },

    { "mkaddin",   "rex",       "(C) 2001 Dominic Morris",   
      "Creates a .rex application using data from a .res file and a .bin file",
      rex_exec,     &rex_options },
    { "bin2var",   "ti82",       "(C) 2000 - 2003 David Phillips et al",
        "Creates a .82p file",
        tixx_exec,      &tixx_options },
    { "bin2var",   "ti83",       "(C) 2000 - 2003 David Phillips et al",
        "Creates a .83p file",
        tixx_exec,      &tixx_options },
    { "bin2var",   "ti8x",       "(C) 2000 - 2003 David Phillips et al",
        "Creates a .8xp file",
        tixx_exec,      &tixx_options },
    { "bin2var",   "ti85",       "(C) 2000 - 2003 David Phillips et al",
        "Creates a .85p file",
        tixx_exec,      &tixx_options },
    { "bin2var",   "ti86",       "(C) 2000 - 2003 David Phillips et al",
        "Creates a .86p file",
        tixx_exec,      &tixx_options },
    { "bin2var",   "ti86s",       "(C) 2000 - 2003 David Phillips et al",
        "Creates a .86s file",
        tixx_exec,      &tixx_options },
    { "bin2svi",  "svi",       "(C) 2001 Stefano Bodrato",                         
      "Creates a .cas file loadable with the SVI emulator",
      svi_exec,      &svi_options },
    { "appz88",   "z88",      "(C) 2000 - 2003 Dominic Morris & Dennis Groning",
      "Generates .63 and .62 files suitable for burning to EPROM",
      z88_exec,     &z88_options },
    { "shellmak", "z88shell", "(C) 2002 - 2003 Dominic Morris",   
      "Patches the header to ensure that the program is recognised by the shell",
      z88shell_exec,&z88shell_options },
    { "appzxvgs", "zxvgs",    "(C) 2003 Yarek",
      "Creates a zxvgs application file",
      zxvgs_exec,   &zxvgs_options},
    { "bin2tap",  "zx",       "(C) 2000 - 2003 Dominic Morris & Stefano Bodrato", 
      "Generates a .TAP file complete with BASIC header",
      zx_exec,      &zx_options },
    { "bin2p",    "zx81",     "(C) 2000 Stefano Bodrato",                         
      "Generates a .P file suitable for use by emulators",
      zx81_exec,    &zx81_options },

};
#define APPMAKE_TARGETS 21
#endif




#define LINEMAX         80

extern int          myexit(char *str,int code);
extern long         parameter_search(char *filen, char *ext,char *target);
extern void         suffix_change(char *name, char *suffix);

extern void         writebyte(unsigned char c, FILE *fp);
extern void         writeword(unsigned int i, FILE *fp);
extern void         writestring(char *mystring, FILE *fp);
extern void         writeword_p(unsigned int i, FILE *fp,unsigned char *p);
extern void         writebyte_p(unsigned char c, FILE *fp,unsigned char *p);
extern void         writestring_p(char *mystring, FILE *fp,unsigned char *p);
