/* 
 * Some standard defines which are the same for all machines - hopefully!
 *
 * rcs messing up..hohum! (twiddle, keep adding here till I sort it!)
 *
 * $Id: zcc.h,v 1.10 2001-10-06 20:55:46 dom Exp $
 */


/* Some machine specific definitions (paths etc!) */

char *version = "v2.492 (C) 6.10.2001 D.J.Morris\n";

#ifdef AMIGA
#define PREFIX "zcc:lib/config/"
char *amiver="$VER: zcc v2.492 (6.10.2001)";
#endif

/* Insert your machines definitions in here... */

#ifdef MSDOS
#define PREFIX "c:\\z88dk\\lib\\config\\"
#endif

#ifdef _WIN32
#define PREFIX "c:/z88dk/lib/config/"
#endif

#ifdef UNIX
#define PREFIX "/usr/local/z88dk/lib/config/"
#endif

#ifdef hpux
#undef FILENAME_MAX
#define FILENAME_MAX 1024
#endif



/* 
 *      Now some fun stuff - all this moved out of zcc.c to clean
 *      things up a little bit!
 */

#define CFILE   1
#define PFILE   2
#define AFILE   3
#define OFILE   4

#define NO      0
#define YES     1

#define Z88MATH 1
#define GENMATH 2

#define LINEMAX 160      /* Max number of chars to read from config file*/

/*
 *      Sorry, this is hard coded, hopefully won't cause too many
 *      problems - needed to ensure math libs are linked in correctly!
 */

#define DEFFILE "zcc_opt.def"


struct args {
        char *name;
        char more;
        void (*setfunc)(char *);
};

struct confs {
        char *name;
        void (*setfunc)(char *,int);
        char *def;
};

enum iostyle { outimplied=0, outspecified, filter };

enum conf { OPTIONS, Z80EXE, CPP, LINKER, COMPILER, COPTEXE, COPYCMD, INCPATH, COPTRULES1, COPTRULES2, COPTRULES3, CRT0, LIBPATH,  LINKOPTS, ASMOPTS, APPMAKE, Z88MATHLIB,  Z88MATHFLG, STARTUPLIB, GENMATHLIB, CPPSTYLE  };

