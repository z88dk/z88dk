/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.c,v 1.13 2002-12-01 15:47:17 dom Exp $ */
/* $History: Z80ASM.C $ */
/*  */
/* *****************  Version 22  ***************** */
/* User: Gbs          Date: 30-01-00   Time: 12:49 */
/* Updated in $/Z80asm */
/* New option -M implemented, which defines arbitrary object file name */
/* extension. */
/*  */
/* *****************  Version 21  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:12 */
/* Updated in $/Z80asm */
/* "V1.0.14" version text changes. */
/*  */
/* *****************  Version 20  ***************** */
/* User: Gbs          Date: 30-09-99   Time: 22:39 */
/* Updated in $/Z80asm */
/* CALL_PKG hard coded macro implemented for Garry Lancaster's Package */
/* System. */
/*  */
/* *****************  Version 18  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 16  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/* '#' changed to '@' in default help page. */
/* ReportError() changed to display the platform specific MAXCODESIZE */
/* value when the maximum code generation size has been reached. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:04 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Explicitly specified file source file extension automaticlly removed. */
/* Slight changes to default help page. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:12 */
/* Updated in $/Z80asm */
/* New function, ReportIOError().  */
/* ReportError() improved to display to <stderr> when no error filename is */
/* available and to display the name of the module in which the error */
/* occurred (this is especially useful during linking errors). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:14 */
/* Updated in $/Z80asm */
/* Program terminates with 1 if error occurs, otherwise 0 if all went OK. */
/* (Dominic Morris - djm@jb.man.ac.uk) */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 6-09-98    Time: 12:53 */
/* Updated in $/Z80asm */
/* -o logic replaced with -e<ext> option. This makes Z80asm completely */
/* configurable on which filename extension to use for source files. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:11 */
/* Updated in $/Z80asm */
/* ".opt" source files now parsed in stead of ".asm" files using new -o */
/* option. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:00 */
/* Updated in $/Z80asm */
/* SourceSafe Version  History comment block added. */
/* program version strings updated, "V1.0.3". */

/* All exit(-1) changed to exit(0) - djm 26/6/98 */
/* Cleaned up info so doesn't linewrap on Amiga */

/* Oops, screw up! exit(0) (was exit(-1))  should be exit(1) - djm 29/2/99 */


#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <ctype.h>
#include "config.h"
#include "symbol.h"

/* external functions */
char *AllocIdentifier (size_t len);
void RemovePfixlist (struct expr *pfixexpr);
void Z80pass1 (void);
void Z80pass2 (void);
void CreateLib (void);
void LinkModules (void);
void DeclModuleName (void);
void DeclSymGlobal (void);
void FreeSym (symbol * node);
void CreateDeffile (void);
void WriteGlobal (symbol * node);
void WriteMapFile (void);
void CreateBinFile (void);
void Fetchfilename(FILE *fptr);
struct sourcefile *Newfile (struct sourcefile *curfile, char *fname);
enum symbols GetSym (void);
long GetConstant (char *evalerr);
long ReadLong (FILE * fileid);
int cmpidstr (symbol * kptr, symbol * p);
int DefineSymbol (char *identifier, long value, unsigned char symboltype);
int DefineDefSym (char *ident, long value, unsigned char symtype, avltree ** root);
symbol *CreateSymbol (char *identifier, long value, unsigned char symboltype, struct module *symowner);


/* local functions */
void prompt (void);
void usage (void);
void ReportError (char *filename, short linenr, int errnum);
void ReportIOError (char *filename);
void SetAsmFlag (char *flagid);
void WriteHeader (void);
void ReleaseFile (struct sourcefile *srcfile);
void ReleaseLibraries (void);
void ReleaseOwnedFile (struct usedfile *ownedfile);
void ReleaseModules (void);
void ReleaseFilenames (void);
void ReleaseExprns (struct expression *express);
void CloseFiles (void);
void CreateLibfile (char *libfilename);
int AssembleSourceFile (void);
int TestAsmFile (void);
int GetModuleSize (void);
symbol *createsym (symbol * symptr);
struct modules *AllocModuleHdr (void);
struct module *AllocModule (void);
struct liblist *AllocLibHdr (void);
struct libfile *AllocLib (void);
struct module *NewModule (void);
struct libfile *NewLibrary (void);
struct expression *AllocExprHdr (void);
struct JRPC_Hdr *AllocJRaddrHdr (void);


#ifdef QDOS
#include <qdos.h>

char _prog_name[] = "Z80asm";
char _version[] = "1.0.19";
char _copyright[] = "\x7f InterLogic 1993-2002";

void consetup_title ();
void (*_consetup) () = consetup_title;
int (*_readkbd) (chanid_t, timeout_t, char *) = readkbd_move;
struct WINDOWDEF _condetails =
{2, 1, 0, 7, 484, 256, 0, 0};

#endif

#ifdef AMIGA
char amiver[] = "$VER: z80asm v1.0.19, (c) InterLogic 1993-2002";
#endif


char copyrightmsg[] = "Z80 Module Assembler V1.0.19 (20.2.2002), (c) InterLogic 1993-2002";

FILE *z80asmfile, *listfile, *errfile, *objfile, *mapfile, *modsrcfile, *deffile, *libfile;
long	clineno;

char *errmsg[] =
{"File open/read error",	/* 0  */
 "Syntax error",		/* 1  */
 "Symbol not defined",		/* 2  */
 "Not enough memory",		/* 3  */
 "Integer out of range",	/* 4  */
 "Syntax error in expression",	/* 5  */
 "Right bracket missing",	/* 6  */
 "Out of range",		/* 7  */
 "Source filename missing",	/* 8  */
 "Illegal option",		/* 9  */
 "Unknown identifier",		/* 10 */
 "Illegal identifier",		/* 11 */
 "Max. code size of %ld bytes reached",	/* 12 */
 "errors occurred during assembly",	/* 13 */
 "Symbol already defined",	/* 14 */
 "Module name already defined",	/* 15 */
 "Module name not defined",	/* 16 */
 "Symbol already declared local",	/* 17 */
 "Symbol already declared global",	/* 18 */
 "Symbol already declared external",	/* 19 */
 "No command line arguments",	/* 20 */
 "Illegal source filename",	/* 21 */
 "Symbol declared global in another module",	/* 22 */
 "Re-declaration not allowed",	/* 23 */
 "ORG already defined",		/* 24 */
 "Relative jump address must be local",		/* 25 */
 "Not an object file",		/* 26 */
 "Reserved name",		/* 27 */
 "Couldn't open library file",	/* 28 */
 "Not a library file",		/* 29 */
 "Environment variable not defined",	/* 30 */
 "Cannot include file recursively",	/* 31 */
};

enum symbols sym, ssym[] =
{space, strconq, dquote, squote, semicolon, comma, fullstop,
 lparen, lcurly, rcurly, rparen, plus, minus, multiply, divi, mod, power,
 assign, bin_and, bin_or, bin_xor, less, greater, log_not, constexpr};

enum flag pass1, listing, listing_CPY, symtable, z80bin, writeline, mapref, globaldef, datestamp, ti83plus;
enum flag deforigin, verbose, ASMERROR, EOL, symfile, library, createlibrary, autorelocate;
enum flag smallc_source, codesegment, expl_binflnm, clinemode, swapIXIY;

int ASSEMBLE_ERROR, ERRORS, TOTALERRORS, PAGENR, LINENR;
long TOTALLINES;
int sourcefile_open;
char PAGELEN;
int TAB_DIST = 8, COLUMN_WIDTH;
char separators[] = " &\"\';,.({})+-*/%^=~|:<>!#:";
char line[255], stringconst[255], ident[255];
char *srcfilename, *lstfilename, *objfilename, *errfilename, *libfilename;

#ifdef QDOS
char asmext[] = "_asm", lstext[] = "_lst", objext_templ[] = "_obj", defext[] = "_def", errext[] = "_err";
char binext[] = "_bin", libext[] = "_lib", symext[] = "_sym", mapext[] = "_map";
char segmbinext[] = "_bn0";
#else
char asmext[] = ".asm", lstext[] = ".lst", objext_templ[] = ".obj", defext[] = ".def", binext[] = ".bin";
char mapext[] = ".map", errext[] = ".err", symext[] = ".sym", libext[] = ".lib";
char segmbinext[] = ".bn0";
#endif

char srcext[5];			/* contains default source file extension */
char objext[5];			/* contains default object file extension */
char binfilename[64];		/* -o explicit filename buffer */
char Z80objhdr[] = "Z80RMF01";
char objhdrprefix[] = "oomodnexprnamelibnmodc";
char Z80libhdr[] = "Z80LMF01";

unsigned char reloc_routine[] =
"\x08\xD9\xFD\xE5\xE1\x01\x49\x00\x09\x5E\x23\x56\xD5\x23\x4E\x23"
"\x46\x23\xE5\x09\x44\x4D\xE3\x7E\x23\xB7\x20\x06\x5E\x23\x56\x23"
"\x18\x03\x16\x00\x5F\xE3\x19\x5E\x23\x56\xEB\x09\xEB\x72\x2B\x73"
"\xD1\xE3\x2B\x7C\xB5\xE3\xD5\x20\xDD\xF1\xF1\xFD\x36\x00\xC3\xFD"
"\x71\x01\xFD\x70\x02\xD9\x08\xFD\xE9";

size_t sizeof_relocroutine = 73;

char *reloctable = NULL, *relocptr = NULL;

long listfileptr;
unsigned char *codearea, *codeptr;
size_t CODESIZE;
long PC, oldPC;			/* Program Counter */
unsigned short DEFVPC;		/* DEFVARS address counter */
size_t EXPLICIT_ORIGIN;		/* origin defined from command line */
time_t asmtime;			/* time   of assembly in seconds */
char *date;			/* pointer to datestring calculated from asmtime */

struct modules *modulehdr;
struct module *CURRENTMODULE;
struct liblist *libraryhdr;
avltree *globalroot, *staticroot;


int 
AssembleSourceFile (void)
{
  char  *dotptr;

  if ((errfile = fopen (errfilename, "w")) == NULL)
    {				/* Create error file */
      ReportIOError (errfilename);
      return 0;
    }
  if (listing_CPY || symfile)
    {
      if ((listfile = fopen (lstfilename, "w+")) != NULL)
	{			/* Create LIST or SYMBOL file */
	  PAGENR = 0;
	  LINENR = 6;
	  WriteHeader ();			/* Begin list file with a header */
	  listfileptr = ftell (listfile);	/* Get file pos. of next line in list file */
	}
      else
	{
	  ReportIOError (lstfilename);
	  return 0;
	}
    }
  if ((objfile = fopen (objfilename, "w+b")) != NULL)
    {				/* Create relocatable object file */
      fwrite (Z80objhdr, sizeof (char), strlen (Z80objhdr), objfile);
      fwrite (objhdrprefix, sizeof (char), strlen (objhdrprefix), objfile);
    }
  else
    {
      ReportIOError (objfilename);
      return 0;
    }

  PC = oldPC = 0;
  copy (staticroot, &CURRENTMODULE->localroot, (int (*)()) cmpidstr, (void *(*)()) createsym);
  if (DefineDefSym (ASSEMBLERPC, PC, 0, &globalroot) == 0)
    {				/* Create standard 'ASMPC' identifier */
      ReportError (NULL, 0, 3);
      return 0;
    }

  if (verbose)
    printf ("Assembling '%s'...\nPass1...\n", srcfilename);

  pass1 = ON;
  Z80pass1 ();
  pass1 = OFF;			/* GetSymPtr will only generate page references in Pass1 (if listing is ON) */

  /*
   * Source file no longer needed (file could already have been closed, if fatal error occurred during INCLUDE
   * processing).
   */
  if (sourcefile_open)
    {
      fclose (z80asmfile);
      z80asmfile = NULL;
    }
  if (CURRENTMODULE->mname == NULL) {	/* Module name must be defined */
    dotptr = strrchr(srcfilename,'/');
    if ( dotptr == NULL )
	dotptr = strrchr(srcfilename,'\\');
    if ( dotptr == NULL )
	dotptr = srcfilename-1;
    strcpy(ident,dotptr+1);
    dotptr = strchr(ident,asmext[0]);
    if ( dotptr )
	*dotptr = 0;
    sym = name;
    dotptr = ident;
    while ( *dotptr )
     {
	*dotptr = toupper(*dotptr);
	dotptr++;
      }
    DeclModuleName();
    /* ReportError (CURRENTFILE->fname, 0, 16); */
  }
    

  if (ERRORS == 0)
    {
      if (verbose)
	puts ("Pass2...");
      Z80pass2 ();
    }
  if (listing_CPY || symfile)
    {
      fseek (listfile, 0, SEEK_END);
      fputc (12, listfile);	/* end listing with a FF */
      fclose (listfile);
      listfile = NULL;
      if (ERRORS)
	remove (lstfilename);	/* remove incomplete list file */
    }
  fclose (objfile);
  objfile = NULL;
  if (ERRORS)
    remove (objfilename);	/* remove incomplete object file */

  if (errfile != NULL)
    {
      fclose (errfile);
      errfile = NULL;
      if (ERRORS == 0 && errfilename != NULL)
	remove (errfilename);	/* remove empty error file */
    }
  if (globaldef)
    {
      fputc ('\n', deffile);	/* separate DEFC lines for each module */
      inorder (globalroot, (void (*)()) WriteGlobal);
    }
  deleteall (&CURRENTMODULE->localroot, (void (*)()) FreeSym);
  deleteall (&CURRENTMODULE->notdeclroot, (void (*)()) FreeSym);
  deleteall (&globalroot, (void (*)()) FreeSym);

  return 1;
}


void 
ReleaseFilenames (void)
{
  if (srcfilename != NULL) free (srcfilename);
  if (lstfilename != NULL) free (lstfilename);
  if (objfilename != NULL) free (objfilename);
  if (errfilename != NULL) free (errfilename);
  srcfilename = lstfilename = objfilename = errfilename = NULL;
}


void 
CloseFiles (void)
{
  if (z80asmfile != NULL) fclose (z80asmfile);
  if (listfile != NULL) fclose (listfile);
  if (objfile != NULL) fclose (objfile);
  if (errfile != NULL) fclose (errfile);
  z80asmfile = listfile = objfile = errfile = NULL;
}


int 
TestAsmFile (void)
{
  struct stat afile, ofile;

  if (datestamp)
    {				/* assemble only updated files */
      if (stat (srcfilename, &afile) == -1)
	return GetModuleSize ();	/* source file not available... */
      else if (stat (objfilename, &ofile) != -1)
	if (afile.st_mtime <= ofile.st_mtime)
	  return GetModuleSize ();	/* source is older than object module */
    }
  if ((z80asmfile = fopen (srcfilename, "rb")) == NULL)
    {				/* Open source file */
      ReportIOError (srcfilename);		/* Object module is not found or */
      return -1;		/* source is has recently been updated */
    }
  sourcefile_open = 1;
  return 1;			/* assemble if no datestamp check */
}



int 
GetModuleSize (void)
{
  char fheader[9];
  long fptr_modcode, fptr_modname;
  long highbyte, lowbyte;
  size_t size;

  if ((objfile = fopen (objfilename, "rb")) != NULL)
    {				/* open relocatable object file */
      fread (fheader, 1U, 8U, objfile);		/* read first 8 chars from file into array */
      fheader[8] = '\0';

      if (strcmp (fheader, Z80objhdr) != 0)
	{			/* compare header of file */
	  ReportError (objfilename, 0, 26);	/* not an object file */
	  fclose (objfile);
	  objfile = NULL;
	  return -1;
	}
      fseek (objfile, 8 + 2, SEEK_SET);		/* set file pointer to point at module name */
      fptr_modname = ReadLong (objfile);	/* get file pointer to module name */
      fseek (objfile, fptr_modname, SEEK_SET);	/* set file pointer to module name */

      size = fgetc (objfile);
      fread (line, sizeof (char), size, objfile);	/* read module name */
      line[size] = '\0';
      if ((CURRENTMODULE->mname = AllocIdentifier (size + 1)) == NULL)
	{
	  ReportError (NULL, 0, 3);
	  return -1;
	}
      else
	strcpy (CURRENTMODULE->mname, line);

      fseek (objfile, 26, SEEK_SET);	/* set file pointer to point at module code pointer */
      fptr_modcode = ReadLong (objfile);	/* get file pointer to module code */
      if (fptr_modcode != -1)
	{
	  fseek (objfile, fptr_modcode, SEEK_SET);	/* set file pointer to module code */
	  lowbyte = fgetc (objfile);
	  highbyte = fgetc (objfile);
	  size = lowbyte + highbyte * 256;
	  if (CURRENTMODULE->startoffset + size > MAXCODESIZE)
	    ReportError (objfilename, 0, 12);
	  else
	    CODESIZE += size;
	}
      fclose (objfile);
      return 0;
    }
  else
    {
      ReportIOError (objfilename);
      return -1;
    }
}


void 
CreateLibfile (char *filename)
{
  size_t l;

  l = strlen (filename);
  if (l)
    {
      if (strcmp (filename + (l - 4), libext) != 0)
	{			/* 'lib' extension not specified */
	  if ((libfilename = AllocIdentifier (l + 4 + 1)) != NULL)
	    {
	      strcpy (libfilename, filename);
	      strcat (libfilename, libext);	/* add '_lib' extension */
	    }
	  else
	    {
	      ReportError (NULL, 0, 3);
	      return;
	    }
	}
      else
	{
	  if ((libfilename = AllocIdentifier (l + 1)) != NULL)	/* 'lib' extension specified */
	    strcpy (libfilename, filename);
	  else
	    {
	      ReportError (NULL, 0, 3);
	      return;
	    }
	}
    }
  else
    {
      if ((filename = getenv ("Z80_STDLIB")) != NULL)
	{
	  if ((libfilename = AllocIdentifier (strlen (filename))) != NULL)
	    strcpy (libfilename, filename);
	  else
	    {
	      ReportError (NULL, 0, 3);
	      return;
	    }
	}
      else
	{
	  ReportError (NULL, 0, 30);
	  return;
	}
    }

  if ((libfile = fopen (libfilename, "w+b")) == NULL)
    {				/* create library as BINARY file */
      free (libfilename);
      libfilename = NULL;
      ReportError (libfilename, 0, 28);
    }
  else
    {
      createlibrary = ON;
      fwrite (Z80libhdr, sizeof (char), 8U, libfile);	/* write library header */
    }
}


void 
GetLibfile (char *filename)
{
  struct libfile *newlib;
  char *f, fheader[9];
  int l;

  if ((newlib = NewLibrary ()) == NULL)
    {
      ReportError (NULL, 0, 3);
      return;
    }

  l = strlen (filename);
  if (l)
    {
      if (strcmp (filename + (l - 4), libext) != 0)
	{			/* 'lib' extension not specified */
	  if ((f = AllocIdentifier (l + 4 + 1)) != NULL)
	    {
	      strcpy (f, filename);
	      strcat (f, libext);	/* add '_lib' extension */
	    }
	  else
	    {
	      ReportError (NULL, 0, 3);
	      return;
	    }
	}
      else
	{
	  if ((f = AllocIdentifier (l + 1)) != NULL)	/* 'lib' extension specified */
	    strcpy (f, filename);
	  else
	    {
	      ReportError (NULL, 0, 3);
	      return;
	    }
	}
    }
  else
    {
      filename = getenv ("Z80_STDLIB");
      if (filename != NULL)
	{
	  if ((f = AllocIdentifier (strlen (filename))) != NULL)
	    strcpy (f, filename);
	  else
	    {
	      ReportError (NULL, 0, 3);
	      return;
	    }
	}
      else
	{
	  ReportError (NULL, 0, 30);
	  return;
	}
    }

  newlib->libfilename = f;
  if ((z80asmfile = fopen (f, "rb")) == NULL)
    {				/* Does file exist? */
      ReportError (f, 0, 28);
      return;
    }
  else
    {
      fread (fheader, 1U, 8U, z80asmfile);	/* read first 8 chars from file into array */
      fheader[8] = '\0';
    }

  if (strcmp (fheader, Z80libhdr) != 0)		/* compare header of file */
    ReportError (f, 0, 29);	/* not a library file */
  else
    library = ON;

  fclose (z80asmfile);
  z80asmfile = NULL;
}



void 
SetAsmFlag (char *flagid)
{
  int i;

  if (*flagid == 'e')
    {
      smallc_source = ON;	/* use ".xxx" as source file in stead of ".asm" */
      srcext[0] = '.';
      strncpy ((srcext + 1), (flagid + 1), 3);	/* copy argument string */
      srcext[4] = '\0';		/* max. 3 letters extension */
      return;
    }

  /* djm: mod to get .o files produced instead of .obj */
  /* gbs: extended to use argument as definition, e.g. -Mo, which defines .o extension */
  if (*flagid == 'M')
   {
	strncpy ((objext + 1), (flagid + 1), 3);	/* copy argument string (append after '.') */
     objext[4] = '\0';						/* max. 3 letters extension */
   }

  /* check weather to use an RST or CALL when Invoke is used */
  if (strcmp(flagid, "plus") == 0 ) 
    {
      ti83plus = ON;
      return;
    }

  /* (stefano) IX and IY swap option */

  if (strcmp (flagid, "IXIY") == 0)
    {
      swapIXIY = ON;
      return;
    }

  /* djm turn on c line mode to report line number of C source */

  if (strcmp(flagid, "C") == 0 ) 
    {
      clinemode = ON;
      return;
    }

  if (strcmp(flagid, "c") == 0)
    {
      codesegment = ON;
      return;
    }
  if (strcmp (flagid, "a") == 0)
    {
      z80bin = ON;
      datestamp = ON;
      return;
    }
  if (strcmp (flagid, "l") == 0)
    {
      listing_CPY = listing = ON;
      if (symtable)
	symfile = OFF;
      return;
    }
  if (strcmp (flagid, "nl") == 0)
    {
      listing_CPY = listing = OFF;
      if (symtable)
	symfile = ON;
      return;
    }
  if (strcmp (flagid, "s") == 0)
    {
      symtable = ON;
      if (listing_CPY)
	symfile = OFF;
      else
	symfile = ON;
      return;
    }
  if (strcmp (flagid, "ns") == 0)
    {
      symtable = symfile = OFF;
      return;
    }
  if (strcmp (flagid, "nb") == 0)
    {
      z80bin = OFF;
      mapref = OFF;
      return;
    }
  if (strcmp (flagid, "b") == 0)
    {
      z80bin = ON;		/* perform address relocation & linking */
      return;
    }
  if (strcmp (flagid, "v") == 0)
    {
      verbose = ON;		/* perform address relocation & linking */
      return;
    }
  if (strcmp (flagid, "nv") == 0)
    {
      verbose = OFF;		/* perform address relocation & linking */
      return;
    }
  if (strcmp (flagid, "d") == 0)
    {
      datestamp = ON;		/* assemble only if source > object file */
      return;
    }
  if (strcmp (flagid, "nd") == 0)
    {
      datestamp = OFF;
      return;
    }
  if (strcmp (flagid, "m") == 0)
    {
      mapref = ON;
      return;
    }
  if (strcmp (flagid, "g") == 0)
    {
      globaldef = ON;
      return;
    }
  if (strcmp (flagid, "ng") == 0)
    {
      globaldef = OFF;
      return;
    }
  if (strcmp (flagid, "nm") == 0)
    {
      mapref = OFF;
      return;
    }
  if (strcmp (flagid, "nR") == 0)
    {
      autorelocate = OFF;
      return;
    }
  if (*flagid == 'h')
    {
      usage();
      exit(1);
    }
  if (*flagid == 'i')
    {
      GetLibfile ((flagid + 1));
      return;
    }
  if (*flagid == 'x')
    {
      CreateLibfile ((flagid + 1));
      return;
    }
  if (*flagid == 'r')
    {
      sscanf (flagid + 1, "%x", &EXPLICIT_ORIGIN);
      deforigin = ON;		/* explicit origin has been defined */
      return;
    }
  if (*flagid == 'o')
    {
      sscanf (flagid + 1, "%s", binfilename); /* store explicit filename for .BIN file */
      expl_binflnm = ON;      
      return;
    }
  if (*flagid == 'R')
    {
      autorelocate = ON;
      return;
    }
  if (*flagid == 't')
    {
      sscanf (flagid + 1, "%d", &TAB_DIST);
      return;
    }
  if (*flagid == 'D')
    {
      strcpy (ident, (flagid + 1));	/* copy argument string */
      if (!isalpha (ident[0]))
	{
	  ReportError (NULL, 0, 11);	/* symbol must begin with alpha */
	  return;
	}
      i = 0;
      while (ident[i] != '\0')
	{
	  if (strchr (separators, ident[i]) == NULL)
	    {
	      if (!isalnum (ident[i]))
		{
		  if (ident[i] != '_')
		    {
		      ReportError (NULL, 0, 11);	/* illegal char in identifier */
		      return;
		    }
		  else
		    ident[i] = '_';	/* underscore in identifier */
		}
	      else
		ident[i] = toupper (ident[i]);
	    }
	  else
	    {
	      ReportError (NULL, 0, 11);	/* illegal char in identifier */
	      return;
	    }
	  ++i;
	}
      DefineDefSym (ident, 1, 0, &staticroot);
    }
}



struct module *
NewModule (void)
{
  struct module *newm;

  if (modulehdr == NULL)
    {
      if ((modulehdr = AllocModuleHdr ()) == NULL)
	return NULL;
      else
	{
	  modulehdr->first = NULL;
	  modulehdr->last = NULL;	/* Module header initialised */
	}
    }
  if ((newm = AllocModule ()) == NULL)
    return NULL;
  else
    {
      newm->nextmodule = NULL;
      newm->mname = NULL;
      newm->startoffset = CODESIZE;
      newm->origin = 65535;
      newm->cfile = NULL;
      newm->localroot = NULL;
      newm->notdeclroot = NULL;

      if ((newm->mexpr = AllocExprHdr ()) != NULL)
	{			/* Allocate room for expression header */
	  newm->mexpr->firstexpr = NULL;
	  newm->mexpr->currexpr = NULL;		/* Module expression header initialised */
	}
      else
	{
	  free (newm);		/* remove partial module definition */
	  return NULL;		/* No room for header */
	}

      if ((newm->JRaddr = AllocJRaddrHdr ()) != NULL)
	{
	  newm->JRaddr->firstref = NULL;
	  newm->JRaddr->lastref = NULL;		/* Module JRaddr list header initialised */
	}
      else
	{
	  free (newm->mexpr);	/* remove expression header */
	  free (newm);		/* remove partial module definition */
	  return NULL;		/* No room for header */
	}
    }

  if (modulehdr->first == NULL)
    {
      modulehdr->first = newm;
      modulehdr->last = newm;	/* First module     in list   */
    }
  else
    {
      modulehdr->last->nextmodule = newm;	/* current/last module points now at new current */
      modulehdr->last = newm;			/* pointer to current module updated */
    }

  return newm;
}


struct libfile *
NewLibrary (void)
{
  struct libfile *newl;

  if (libraryhdr == NULL)
    {
      if ((libraryhdr = AllocLibHdr ()) == NULL)
	return NULL;
      else
	{
	  libraryhdr->firstlib = NULL;
	  libraryhdr->currlib = NULL;	/* Library header initialised */
	}
    }
  if ((newl = AllocLib ()) == NULL)
    return NULL;
  else
    {
      newl->nextlib = NULL;
      newl->libfilename = NULL;
      newl->nextobjfile = -1;
    }

  if (libraryhdr->firstlib == NULL)
    {
      libraryhdr->firstlib = newl;
      libraryhdr->currlib = newl;	/* First library in list */
    }
  else
    {
      libraryhdr->currlib->nextlib = newl;	/* current/last library points now at new current */
      libraryhdr->currlib = newl;	/* pointer to current module updated */
    }

  return newl;
}



void 
ReleaseModules (void)
{
  struct module *tmpptr, *curptr;

  if (modulehdr == NULL)
    return;

  curptr = modulehdr->first;
  do
    {
      if (curptr->cfile != NULL)
	ReleaseFile (curptr->cfile);
      deleteall (&curptr->localroot, (void (*)()) FreeSym);
      deleteall (&curptr->notdeclroot, (void (*)()) FreeSym);
      if (curptr->mexpr != NULL)
	ReleaseExprns (curptr->mexpr);
      if (curptr->mname != NULL)
	free (curptr->mname);
      tmpptr = curptr;
      curptr = curptr->nextmodule;
      free (tmpptr);		/* Release module */
    }
  while (curptr != NULL);	/* until all modules are released */

  free (modulehdr);
  modulehdr = NULL;
  CURRENTMODULE = NULL;
}



void 
ReleaseLibraries (void)
{
  struct libfile *curptr, *tmpptr;

  curptr = libraryhdr->firstlib;
  do
    {
      if (curptr->libfilename != NULL)
	free (curptr->libfilename);
      tmpptr = curptr;
      curptr = curptr->nextlib;
      free (tmpptr);		/* release library */
    }
  while (curptr != NULL);	/* until all libraries are released */

  free (libraryhdr);		/* Release library header */
  libraryhdr = NULL;
}



void 
ReleaseExprns (struct expression *express)
{
  struct expr *tmpexpr, *curexpr;

  curexpr = express->firstexpr;
  while (curexpr != NULL)
    {
      tmpexpr = curexpr->nextexpr;
      RemovePfixlist (curexpr);
      curexpr = tmpexpr;
    }

  free (express);
}


void 
ReleaseFile (struct sourcefile *srcfile)
{
  if (srcfile->usedsourcefile != NULL)
    ReleaseOwnedFile (srcfile->usedsourcefile);
  free (srcfile->fname);	/* Release allocated area for filename */
  free (srcfile);		/* Release file information record for this file */
}


void 
ReleaseOwnedFile (struct usedfile *ownedfile)
{
  /* Release first other files called by this file */
  if (ownedfile->nextusedfile != NULL)
    ReleaseOwnedFile (ownedfile->nextusedfile);

  /* Release first file owned by this file */
  if (ownedfile->ownedsourcefile != NULL)
    ReleaseFile (ownedfile->ownedsourcefile);

  free (ownedfile);		/* Then release this owned file */
}


void 
ReportError (char *filename, short lineno, int errnum)
{
  char	errstr[256], errflnmstr[128], errmodstr[128], errlinestr[64];
  

  ASSEMBLE_ERROR = errnum;	/* set the global error variable for general error trapping */
  ASMERROR = ON;
 
  errflnmstr[0] = '\0';
  errmodstr[0] = '\0'; 
  errlinestr[0] = '\0';
  errstr[0] = '\0';


  if (clinemode && clineno ) lineno=clineno;

  if (filename != NULL)
    sprintf (errflnmstr,"File '%s', ", filename);

  if (CURRENTMODULE != NULL)
    if ( CURRENTMODULE->mname != NULL )
      sprintf(errmodstr,"Module '%s', ", CURRENTMODULE->mname);

  if (lineno != 0)
    sprintf (errlinestr, "at line %d, ", lineno);
     
  strcpy(errstr, errflnmstr);
  strcat(errstr, errmodstr);
  strcat(errstr, errlinestr);
  strcat(errstr, errmsg[errnum]);
 
  switch(errnum)
    {
      case 12:
        if (errfile == NULL) { 
          fprintf (stderr, errstr, MAXCODESIZE);
          fputc ('\n',stderr);
        }
        else {
          fprintf (errfile, errstr, MAXCODESIZE);
          fputc ('\n',errfile);
        }
        break;

      case 13:
        fprintf (stderr, "%d %s\n", TOTALERRORS, errmsg[errnum]);
        break;

      default:
        if (errfile == NULL) 
          fprintf (stderr, "%s\n", errstr);
        else
	  fprintf (errfile, "%s\n", errstr);
     }

  ++ERRORS;
  ++TOTALERRORS;
}


void 
ReportIOError (char *filename)
{
  ASSEMBLE_ERROR = 0;
  ASMERROR = ON;

  if (CURRENTMODULE != NULL)
    if ( CURRENTMODULE->mname != NULL )
       fprintf(stderr,"Module '%s', ", CURRENTMODULE->mname);
  fprintf (stderr,"file '%s' couldn't be opened or created\n", filename);

  ++ERRORS;
  ++TOTALERRORS;
}



void 
display_options (void)
{
  if (datestamp == ON)
    puts ("Assemble only updated files.");
  else
    puts ("Assemble all files");
  if (symfile == ON)
    puts ("Create symbol table file.");
  if (listing == ON)
    puts ("Create listing file.");
  if (globaldef == ON)
    puts ("Create global definition file.");
  if (createlibrary == ON)
    puts ("Create library from specified modules.");
  if (z80bin == ON)
    puts ("Link/relocate assembled modules.");
  if (library == ON)
    puts ("Link library modules with code.");
  if (z80bin == ON && mapref == ON)
    puts ("Create address map file.");
  if (codesegment == ON && autorelocate == OFF)
    puts ("Split code into 16K banks.");
  if (autorelocate == ON)
    puts ("Create relocatable code.");
  putchar ('\n');
}


/***************************************************************************************************
 * Main entry of Z80asm
 ***************************************************************************************************/
int 
main (int argc, char *argv[])
{
  int asmflag;


  symtable = symfile = writeline = mapref = ON;
  verbose = smallc_source = listing = listing_CPY = z80bin = datestamp = ASMERROR = codesegment = clinemode = OFF;
  deforigin = globaldef = library = createlibrary = autorelocate = clineno = OFF;

  libfilename = NULL;
  modsrcfile = NULL;
  CURRENTMODULE = NULL;
  modulehdr = NULL;		/* initialise to no modules */
  libraryhdr = NULL;		/* initialise to no library files */

  globalroot = NULL;		/* global identifier tree initialized */
  staticroot = NULL;		/* static identifier tree initialized */

  asmflag = DefineDefSym (OS_ID, 1, 0, &staticroot);
  if (!asmflag)
    exit (1);

  strcpy (objext, objext_templ);	/* use ".obj" as default object file extension */

  /* Get command line arguments, if any... */
  if (argc == 1)
    {
      prompt ();
      exit (1);
    }
  time (&asmtime);
  date = asctime (localtime (&asmtime));	/* get current system time for date in list file */

  codearea = (unsigned char *) calloc (MAXCODESIZE, sizeof (char));	/* Allocate Memory for Z80 machine code */
  if (codearea == NULL)
    {
      ReportError (NULL, 0, 3);
      exit (1);
    }
  CODESIZE = 0;

  PAGELEN = 66;
  TOTALERRORS = 0;
  TOTALLINES = 0;
  
  if ((CURRENTMODULE = NewModule ()) == NULL)
    {				/* then create a dummy module */
      ReportError (NULL, 0, 3);	/* this   is needed during command line parsing */
      exit (1);
    }
  while (--argc > 0)
    {				/* Get options first */
      ++argv;
 
      if ((*argv)[0] == '-')
	SetAsmFlag (((*argv) + 1));
      else
	{
	  if ((*argv)[0] == '@')
	    if ((modsrcfile = fopen ((*argv + 1), "rb")) == NULL)
	      ReportIOError ((*argv + 1));
	  break;
	}
    }

  ReleaseModules ();		/* Now remove dummy module again, not needed */

  if (!argc && modsrcfile == NULL)
    {
      ReportError (NULL, 0, 8);
      exit (1);
    }
  COLUMN_WIDTH = 4 * TAB_DIST;	/* define column width   for output files */

  if (verbose == ON)
    display_options ();		/* display status messages of select assembler options */

  if (smallc_source == OFF)
    {
      strcpy (srcext, asmext);	/* use ".asm" as default source file extension */
    }

  for (;;)
    {				/* Module loop */
      z80asmfile = listfile = objfile = errfile = NULL;

      codeptr = codearea;	/* Pointer (PC)     to store z80 instruction */
      ERRORS = 0;
      ASSEMBLE_ERROR = -1;	/* General error flag */

      if (modsrcfile == NULL)
	{
	  if (argc > 0)
	    {
	      if ((*argv)[0] != '-')
		{
		  strncpy(ident, *argv, 254);
		  --argc;
		  ++argv;	/* get ready for next filename */
		}
	      else
		{
		  ReportError (NULL, 0, 21);	/* Illegal source file name */
		  break;
		}
	    }
	  else
	    break;
	}
      else
	{
          Fetchfilename(modsrcfile);
	  if (strlen (ident) == 0)
	    {
	      fclose (modsrcfile);
	      break;
	    }
	}

#ifdef QDOS
      /* explicit extension are automatically discarded */
      if (strchr(ident,'_') != NULL) *(strchr(ident, '_')) ='\0';	
#else
      if (strchr(ident,'.') != NULL) *(strchr(ident, '.')) ='\0';
#endif

      if ((srcfilename = AllocIdentifier (strlen (ident) + 5)) != NULL)
	{
	  strcpy (srcfilename, ident);
	  strcat (srcfilename, srcext);		/* add '_asm' or '_opt' extension   */
	}
      else
	{
	  ReportError (NULL, 0, 3);
	  break;
	}
      if ((objfilename = AllocIdentifier (strlen (srcfilename) + 1)) != NULL)
	{
	  strcpy (objfilename, srcfilename);
	  strcpy (objfilename + strlen (srcfilename) - 4, objext);	/* overwrite '_asm' extension with
									   * '_obj' */
	}
      else
	{
	  ReportError (NULL, 0, 3);
	  break;		/* No more room     */
	}

      if ((lstfilename = AllocIdentifier (strlen (srcfilename) + 1)) != NULL)
	{
	  strcpy (lstfilename, srcfilename);
	  if (listing)
	    strcpy (lstfilename + strlen (srcfilename) - 4, lstext);	/* overwrite '_asm' extension
									   * with   '_lst' */
	  else
	    strcpy (lstfilename + strlen (srcfilename) - 4, symext);	/* overwrite '_asm' extension
									   * with   '_sym' */
	}
      else
	{
	  ReportError (NULL, 0, 3);
	  break;		/* No more room     */
	}

      if ((errfilename = AllocIdentifier (strlen (srcfilename) + 1)) != NULL)
	{
	  strcpy (errfilename, srcfilename);
	  strcpy (errfilename + strlen (srcfilename) - 4, errext);	/* overwrite '_asm' extension with
									   * '_err' */
	}
      else
	{
	  ReportError (NULL, 0, 3);
	  break;		/* No more room     */
	}

      if ((CURRENTMODULE = NewModule ()) == NULL)
	{			/* Create module data structures for new file */
	  ReportError (NULL, 0, 3);
	  break;
	}
      if ((CURRENTFILE = Newfile (NULL, srcfilename)) == NULL)
	break;			/* Create first     file record, if     possible */

      if (globaldef && CURRENTMODULE == modulehdr->first)
	CreateDeffile ();

      if ((asmflag = TestAsmFile ()) == 1)
	{
	  AssembleSourceFile ();	/* begin assembly... */
	  if (verbose)
	    putchar ('\n');	/* separate module texts */
	}
      else if (asmflag == -1)
	break;			/* file open error - stop assembler */

      ReleaseFilenames ();
    }				/* for */

  ReleaseFilenames ();
  CloseFiles ();

  if (globaldef)
    fclose (deffile);

  if (createlibrary && ASMERROR == OFF)
    CreateLib ();

  if (createlibrary)
    {
      fclose (libfile);
      if (ASMERROR)
	remove (libfilename);
      free (libfilename);
      libfilename = NULL;
    }

  if ((ASMERROR == OFF) && verbose)
    printf ("Total of %ld lines assembled.\n", TOTALLINES);

  if ((ASMERROR == OFF) && z80bin)
    LinkModules ();

  if ((TOTALERRORS == 0) && z80bin)
    {
      if (mapref)
	WriteMapFile ();

      CreateBinFile ();
    }


  ReleaseFilenames ();
  CloseFiles ();

#ifndef QDOS
  deleteall (&globalroot, (void (*)()) FreeSym);
  deleteall (&staticroot, (void (*)()) FreeSym);

  if (modulehdr != NULL)
    ReleaseModules ();		/* Release module information (symbols, etc.) */

  if (libraryhdr != NULL)
    ReleaseLibraries ();	/* Release library information */
  free (codearea);		/* Release area for machine code */

  if (autorelocate)
    if (reloctable != NULL)
      free (reloctable);
#endif

  if (ASMERROR)
    ReportError (NULL, 0, 13);

  /* <djm>, if errors, then we really want to return an error number
   * surely?
   */
  if (ASMERROR)
      return 1;
  else
      return 0;		/* assembler successfully ended */
}

void
prompt (void)
{
	printf("%s\n",copyrightmsg);
}

void 
usage (void)
{
  printf ("%s\n", copyrightmsg);
  puts ("z80asm [options] [ @<modulefile> | {<filename>} ]");
  puts ("[] = may be ignored. {} = may be repeated. | = OR clause.");
  printf ("To assemble 'fred%s' use 'fred' or 'fred%s'\n", asmext, asmext);
  puts ("<modulefile> contains file names of all modules to be linked:");
  puts ("File names are put on separate lines ended with \\n. File types recognized or");
  puts ("created by z80asm (defined by the following extension):");
  printf ("%s = source file (default), or alternative -e<ext>\n", asmext);
  printf ("%s = object file (default), or alternative -M<ext>\n", objext);
  printf ("%s = list file, %s = Z80 code file\n", lstext, binext);
  printf ("%s = symbols file, %s = map file, %s = XDEF file, %s = error file\n", symext, mapext, defext, errext);
  puts ("Options: -n defines option to be turned OFF (except -r -R -i -x -D -t -o)");
  printf ("-v verbose, -l listing file, -s symbol table, -m map listing file\n");
  puts ("-r<ORG> Explicit relocation <ORG> defined in hex (ignore ORG in first module)");
  puts ("-plus Interpret 'Invoke' as RST 28h");
  puts ("-R Generate relocatable code (Automatical relocation before execution)");
  puts ("-D<symbol> define symbol as logically TRUE (used for conditional assembly)");
  puts ("-b assemble files & link to ORG address. -c split code in 16K banks");
  puts ("-d date stamp control, assemble only if source file > object file");
  puts ("-a: -b & -d (assemble only updated source files, then link & relocate)");
  puts ("-o<bin filename> expl. output filename, -g XDEF reloc. addr. from all modules");
  printf ("-i<library> include <library> LIB modules with %s modules during linking\n", objext);
  puts ("-x<library> create library from specified modules ( e.g. with @<modules> )");
  printf ("-t<n> tabulator width for %s, %s, %s files. Column width is 4 times -t\n", mapext, defext, symext);
  puts ("Default options: -nv -nd -nb -nl -s -m -ng -nc -nR -t8");
}


symbol *
createsym (symbol * symptr)
{
  return CreateSymbol (symptr->symname, symptr->symvalue, symptr->type, symptr->owner);
}


struct expression *
AllocExprHdr (void)
{
  return (struct expression *) malloc (sizeof (struct expression));
}

struct JRPC_Hdr *
AllocJRaddrHdr (void)
{
  return (struct JRPC_Hdr *) malloc (sizeof (struct JRPC_Hdr));
}

struct modules *
AllocModuleHdr (void)
{
  return (struct modules *) malloc (sizeof (struct modules));
}

struct module *
AllocModule (void)
{
  return (struct module *) malloc (sizeof (struct module));
}

struct liblist *
AllocLibHdr (void)
{
  return (struct liblist *) malloc (sizeof (struct liblist));
}

struct libfile *
AllocLib (void)
{
  return (struct libfile *) malloc (sizeof (struct libfile));
}
