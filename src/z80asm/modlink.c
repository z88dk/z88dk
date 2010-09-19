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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/modlink.c,v 1.11 2010-09-19 00:06:20 dom Exp $ */
/* $History: MODLINK.C $ */
/*  */
/* *****************  Version 16  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 14  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:06 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:30 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:00 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Createlib() rewritten to replace low I/O open() with fopen() and */
/* fread(). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:06 */
/* Updated in $/Z80asm */
/* File IO errors now handled through new ReportIOError() function. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:13 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:10 */
/* Updated in $/Z80asm */
/* Various changes by Dominic Morris (ENDIAN #if). */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */

/* ifdef QDOS changed to ifdef ENDIAN to sort ENDIAN djm 26/6/98 */

#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "symbol.h"


/* external functions */
void FreeSym (symbol * node);
void ReportError (char *filename, int linenr, int errnum);
void ReportIOError (char *filename);
void RemovePfixlist (struct expr *pfixexpr);
char *AllocIdentifier (size_t len);
struct module *NewModule (void);
struct libfile *NewLibrary (void);
struct sourcefile *Newfile (struct sourcefile *curfile, char *fname);
long EvalPfixExpr (struct expr *pass2expr);
int DefineDefSym (char *identifier, long value, unsigned char symtype, avltree ** root);
int cmpidstr (symbol * kptr, symbol * p);
int cmpidval (symbol * kptr, symbol * p);
int GetChar (FILE *fptr);
struct expr *ParseNumExpr (void);
symbol *FindSymbol (char *identifier, avltree * symbolptr);
symbol *CreateSymbol (char *identifier, long value, unsigned char symboltype, struct module *symowner);

/* local functions */
int LinkModule (char *filename, long fptr_base);
int LinkTracedModule (char *filename, long baseptr);
int LinkLibModules (char *objfilename, long fptr_base, long startnames, long endnames);
int LinkLibModule (struct libfile *library, long curmodule, char *modname);
int SearchLibfile (struct libfile *curlib, char *modname);
char *ReadName (void);
long ReadLong (FILE * fileid);
void redefinedmsg (void);
void CreateLib (void);
void SearchLibraries (char *modname);
void WriteLong (long fptr, FILE * fileid);
void LinkModules (void);
void ModuleExpr (void);
void CreateBinFile (void);
void WriteExprMsg (void);
void DefineOrigin (void);
void WriteMapFile (void);
void ReadNames (long nextname, long endnames);
void ReadExpr (long nextexpr, long endexpr);
void ReOrderSymbol (avltree * node, avltree ** maproot, int (*symcmp) (void *, void *));
void WriteMapSymbol (symbol * mapnode);
void WriteGlobal (symbol * node);
void CreateDeffile (void);
void ReleaseLinkInfo (void);
struct linklist *AllocLinkHdr (void);
struct linkedmod *AllocTracedModule (void);
static char *         CheckIfModuleWanted(FILE *z80asmfile, long currentlibmodule, char *modname);

/* global variables */
extern FILE *listfile, *mapfile, *z80asmfile, *errfile, *deffile, *libfile;
extern char line[], ident[];
extern char *lstfilename, *objfilename, *errfilename, *libfilename;
extern char objext[], segmbinext[], binext[], mapext[], errext[], defext[], binfilename[];
extern char Z80objhdr[];
extern enum symbols sym, GetSym (void);
extern enum flag listing, writeline, symtable, mapref, z80bin, autorelocate, codesegment, sdcc_hacks;
extern enum flag verbose, deforigin, globaldef, EOL, library, ASMERROR, expl_binflnm;
extern long PC;
extern long EXPLICIT_ORIGIN;
extern size_t CODESIZE;
extern unsigned char *codearea, PAGELEN;
extern unsigned char reloc_routine[];
extern int ASSEMBLE_ERROR, listfileptr;
extern struct modules *modulehdr;
extern struct liblist *libraryhdr;
extern struct module *CURRENTMODULE;
extern int PAGENR, TOTALERRORS;
extern int TAB_DIST, COLUMN_WIDTH;
extern avltree *globalroot;
extern char *reloctable, *relocptr;
extern size_t sizeof_relocroutine;

struct linklist *linkhdr;
struct libfile *CURRENTLIB;
unsigned short totaladdr, curroffset, sizeof_reloctable;


void 
ReadNames (long nextname, long endnames)
{
  char scope, symtype;
  long value;
  symbol *foundsymbol;

  do
    {
      scope = fgetc (z80asmfile);
      symtype = fgetc (z80asmfile);	/* type of name   */
      value = ReadLong (z80asmfile);	/* read symbol (long) integer */
      ReadName ();			/* read symbol name */

      nextname += 1 + 1 + 4 + 1 + strlen (line);

      switch (symtype)
        {
        case 'A':
          symtype = SYMADDR | SYMDEFINED;
          value += modulehdr->first->origin + CURRENTMODULE->startoffset;	/* Absolute address */
          break;

        case 'C':
          symtype = SYMDEFINED;
          break;
        }

      switch (scope)
        {
        case 'L':
          if ((foundsymbol = FindSymbol (line, CURRENTMODULE->localroot)) == NULL)
            {
              foundsymbol = CreateSymbol (line, value, symtype | SYMLOCAL, CURRENTMODULE);
              if (foundsymbol != NULL)
                insert (&CURRENTMODULE->localroot, foundsymbol, (int (*)()) cmpidstr);
            }
          else
            {
              foundsymbol->symvalue = value;
              foundsymbol->type |= symtype | SYMLOCAL;
              foundsymbol->owner = CURRENTMODULE;
              redefinedmsg ();
            }
          break;

        case 'G':
          if ((foundsymbol = FindSymbol (line, globalroot)) == NULL)
            {
              foundsymbol = CreateSymbol (line, value, symtype | SYMXDEF, CURRENTMODULE);
              if (foundsymbol != NULL)
                insert (&globalroot, foundsymbol, (int (*)()) cmpidstr);
            }
          else
            {
              foundsymbol->symvalue = value;
              foundsymbol->type |= symtype | SYMXDEF;
              foundsymbol->owner = CURRENTMODULE;
              redefinedmsg ();
            }
          break;

        case 'X':
          if ((foundsymbol = FindSymbol (line, globalroot)) == NULL)
            {
              foundsymbol = CreateSymbol (line, value, symtype | SYMXDEF | SYMDEF, CURRENTMODULE);
              if (foundsymbol != NULL)
                insert (&globalroot, foundsymbol, (int (*)()) cmpidstr);
            }
          else
            {
              foundsymbol->symvalue = value;
              foundsymbol->type |= symtype | SYMXDEF | SYMDEF;
              foundsymbol->owner = CURRENTMODULE;
              redefinedmsg ();
            }

          break;
        }
    }
  while (nextname < endnames);
}



void 
redefinedmsg (void)
{
  printf ("Symbol <%s> redefined in module '%s'\n", line, CURRENTMODULE->mname);
}



void 
ReadExpr (long nextexpr, long endexpr)
{
  char type;
  long lowbyte, highbyte, offsetptr;
  long constant, i, fptr;
  struct expr *postfixexpr;
  unsigned char *patchptr;

  do
    {
      type = fgetc (z80asmfile);
      lowbyte = fgetc (z80asmfile);
      highbyte = fgetc (z80asmfile);
      offsetptr = highbyte * 256U + lowbyte;

      /* assembler PC     as absolute address */
      PC = modulehdr->first->origin + CURRENTMODULE->startoffset + offsetptr;

      FindSymbol (ASSEMBLERPC, globalroot)->symvalue = PC;

      i = fgetc (z80asmfile);	/* get length of infix expression */
      fptr = ftell (z80asmfile);	/* file pointer is at start of expression */
      fgets (line, i + 1, z80asmfile);	/* read string for error reference */
      fseek (z80asmfile, fptr, SEEK_SET);	/* reset file pointer to start of expression */
      nextexpr += 1 + 1 + 1 + 1 + i + 1;


      EOL = OFF;		/* reset end of line parsing flag - a line is to be parsed... */

      GetSym ();
      if ((postfixexpr = ParseNumExpr ()) != NULL)
        {			/* parse numerical expression */
          if (postfixexpr->rangetype & NOTEVALUABLE)
            {
              ReportError (CURRENTFILE->fname, 0, 2);
              WriteExprMsg ();
            }
          else
            {
              constant = EvalPfixExpr (postfixexpr);
              patchptr = codearea + CURRENTMODULE->startoffset + offsetptr;	/* absolute patch pos.
                                                                             * in memory buffer */
              switch (type)
                {
                case 'U':
                  *patchptr = (unsigned char) constant;
                  break;

                case 'S':
                  if ((constant >= -128) && (constant <= 255))
                    *patchptr = (char) constant;	/* opcode is stored, now store
                                                     * relative jump */
                  else
                    {
                      ReportError (CURRENTFILE->fname, 0, 7);
                      WriteExprMsg ();
                    }
                  break;

                case 'C':
                  if ((constant >= -32768) && (constant <= 65535))
                    {
                      *patchptr++ = (unsigned short) constant % 256U;
                      *patchptr = (unsigned short) constant / 256U;
                    }
                  else
                    {
                      ReportError (CURRENTFILE->fname, 0, 7);
                      WriteExprMsg ();
                    }

                  if (autorelocate)
                    if (postfixexpr->rangetype & SYMADDR)
                      {
                        /* Expression contains relocatable address */
                        constant = PC - curroffset;

                        if ((constant >= 0) && (constant <= 255))
                          {
                            *relocptr++ = (unsigned char) constant;
                            sizeof_reloctable++;
                          }
                        else
                          {
                            *relocptr++ = 0;
                            *relocptr++ = (unsigned short) (PC - curroffset) % 256U;
                            *relocptr++ = (unsigned short) (PC - curroffset) / 256U;
                            sizeof_reloctable += 3;
                          }

                        totaladdr++;
                        curroffset = PC;
                      }
                  break;

                case 'L':
                  if (constant >= LONG_MIN && constant <= LONG_MAX)
                    for (i = 0; i < 4; i++)
                      {
                        *patchptr++ = constant & 255;
                        constant >>= 8;
                      }
                  else
                    {
                      ReportError (CURRENTFILE->fname, 0, 7);
                      WriteExprMsg ();
                    }
                  break;
                }
            }
          RemovePfixlist (postfixexpr);
        }
      else 
        {
          WriteExprMsg ();
        }
    }
  while (nextexpr < endexpr);
}



void 
WriteExprMsg (void)
{
  fprintf (errfile, "Error in expression %s\n\n", line);
}


void 
LinkModules (void)
{
  char fheader[9];
  size_t lowbyte, highbyte;
  struct module *lastobjmodule;
  symtable = listing = OFF;
  linkhdr = NULL;

  if (verbose)
    puts ("linking module(s)...\nPass1...");

  if (autorelocate == ON)
    {
      reloctable = (char *) malloc (32768U);
      if (reloctable == NULL)
        {
          ReportError (NULL, 0, 3);
          return;		/* No more room     */
        }
      else
        {
          relocptr = reloctable;
          relocptr += 4;	/* point at first offset to store */
          totaladdr = 0;
          sizeof_reloctable = 0;	/* relocation table, still 0 elements .. */
          curroffset = 0;
        }
    }

  CURRENTMODULE = modulehdr->first;	/* begin with first module */
  lastobjmodule = modulehdr->last;	/* remember this last module, further modules are libraries */

  if ((errfilename = AllocIdentifier (strlen (CURRENTFILE->fname) + 1)) != NULL)
    {
      strcpy (errfilename, CURRENTFILE->fname);
      strcpy (errfilename + strlen (errfilename) - 4, errext);	/* overwrite '_asm' extension with '_err' */
    }
  else
    {
      ReportError (NULL, 0, 3);
      return;			/* No more room     */
    }

  if ((errfile = fopen (errfilename, "w")) == NULL)
    {				/* open error file */
      ReportIOError (errfilename);	/* couldn't open relocatable file */
      free (errfilename);
      errfilename = NULL;
      return;
    }

  PC = 0;
  if (DefineDefSym (ASSEMBLERPC, PC, 0, &globalroot) == 0)
    {				/* Create standard 'ASMPC' identifier */
      ReportError (NULL, 0, 3);	/* no more room     */
      free (errfilename);
      return;
    }

  do
    {				/* link machine code & read symbols in all modules */
      if (library)
        {
          CURRENTLIB = libraryhdr->firstlib;	/* begin library search  from first library for each
                                                 * module */
          CURRENTLIB->nextobjfile = 8;	/* point at first library module (past header) */
        }
      CURRENTFILE->line = 0;	/* no line references on errors    during link processing */

      if ((objfilename = AllocIdentifier (strlen (CURRENTFILE->fname) + 1)) != NULL)
        {
          strcpy (objfilename, CURRENTFILE->fname);
          strcpy (objfilename + strlen (objfilename) - 4, objext);	/* overwrite '_asm' extension with
                                                                     * '_obj' */
        }
      else
        {
          ReportError (NULL, 0, 3);
          break;		/* No more room */
        }

      if ((z80asmfile = fopen (objfilename, "rb")) != NULL)
        {								/* open relocatable file for reading */
          fread (fheader, 1U, 8U, z80asmfile);	/* read first 6 chars from file into array */
          fheader[8] = '\0';
        }
      else
        {
          ReportIOError (objfilename);	/* couldn't open relocatable file */
          break;
        }

      if (strcmp (fheader, Z80objhdr) != 0)
        {			/* compare header of file */
          ReportError (objfilename, 0, 26);	/* not a object     file */
          fclose (z80asmfile);
          z80asmfile = NULL;
          break;
        }
      lowbyte = fgetc (z80asmfile);
      highbyte = fgetc (z80asmfile);

      if (modulehdr->first == CURRENTMODULE)
        {			/* origin of first module */
          if (autorelocate)
            CURRENTMODULE->origin = 0;	/* ORG 0 on auto relocation */
          else
            {
              if (deforigin)
                CURRENTMODULE->origin = EXPLICIT_ORIGIN;	/* use origin from command line    */
              else
                {
                  CURRENTMODULE->origin = highbyte * 256U + lowbyte;
                  if (CURRENTMODULE->origin == 65535U)
                    DefineOrigin ();	/* Define origin of first module from the keyboard */
                }
            }
          if (verbose == ON)
            printf ("ORG address for code is %04lX\n", CURRENTMODULE->origin);
        }
      fclose (z80asmfile);

      LinkModule (objfilename, 0);	/* link   code & read name definitions */
      free (objfilename);	/* release allocated file name */
      objfilename = NULL;

      CURRENTMODULE = CURRENTMODULE->nextmodule;	/* get next module, if any */
    }
  while (CURRENTMODULE != lastobjmodule->nextmodule);	/* parse only object modules, not added library modules */

  if (verbose == ON)
    printf ("Code size of linked modules is %d bytes\n", (int)CODESIZE);

  if (ASMERROR == OFF)
    ModuleExpr ();		/*  Evaluate expressions in  all modules */

  ReleaseLinkInfo ();		/* Release module link information */
  fclose (errfile);

  if (TOTALERRORS == 0)
    remove (errfilename);

  free (errfilename);
  errfilename = NULL;
  errfile = NULL;
}




int 
LinkModule (char *filename, long fptr_base)
{
  long fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
  size_t lowbyte, highbyte, size;
  int flag = 0;

  z80asmfile = fopen (filename, "rb");	/* open object file for reading */
  fseek (z80asmfile, fptr_base + 10U, SEEK_SET);

  fptr_modname = ReadLong (z80asmfile);		/* get file pointer to module name */
  ReadLong (z80asmfile);			/* get file pointer to expression declarations */
  fptr_namedecl = ReadLong (z80asmfile);	/* get file pointer to name declarations */
  fptr_libnmdecl = ReadLong (z80asmfile);	/* get file pointer to library name declarations */
  fptr_modcode = ReadLong (z80asmfile);		/* get file pointer to module code */

  if (fptr_modcode != -1)
    {
      fseek (z80asmfile, fptr_base + fptr_modcode, SEEK_SET);	/* set file pointer to module code */
      lowbyte = fgetc (z80asmfile);
      highbyte = fgetc (z80asmfile);
      size = lowbyte + highbyte * 256U;
      if (CURRENTMODULE->startoffset + size > MAXCODESIZE)
        {
          ReportError (filename, 0, 12);
          return 0;
        }
      else
        fread (codearea + CURRENTMODULE->startoffset, sizeof (char), size, z80asmfile);	/* read module code */

      if (CURRENTMODULE->startoffset == CODESIZE)
        CODESIZE += size;	/* a new module has been added */
    }

  if (fptr_namedecl != -1)
    {
      fseek (z80asmfile, fptr_base + fptr_namedecl, SEEK_SET);	/* set file pointer to point at name
                                                                 * declarations */
      if (fptr_libnmdecl != -1)
        ReadNames (fptr_namedecl, fptr_libnmdecl);	/* Read symbols until library declarations */
      else
        ReadNames (fptr_namedecl, fptr_modname);	/* Read symbol suntil module name */
    }

  fclose (z80asmfile);

  if (fptr_libnmdecl != -1)
    {
      if (library)
        {			/* search in libraries, if present */
          flag = LinkLibModules (filename, fptr_base, fptr_libnmdecl, fptr_modname);	/* link library modules */

          if (!flag)
            return 0;
        }
    }

  return LinkTracedModule (filename, fptr_base);	/* Remember module for pass2 */
}




int 
LinkLibModules (char *filename, long fptr_base, long nextname, long endnames)
{

  long l;
  char *modname;

  do
    {
      z80asmfile = fopen (filename, "rb");	/* open object file for reading */
      fseek (z80asmfile, fptr_base + nextname, SEEK_SET);	/* set file pointer to point at library name
                                                             * declarations */
      ReadName ();		/* read library reference name */
      fclose (z80asmfile);

      l = strlen (line);
      nextname += 1 + l;	/* remember module pointer to next name in this   object module */
      if (FindSymbol (line, globalroot) == NULL)
        {
          modname = AllocIdentifier ((size_t) l + 1);
          if (modname == NULL)
            {
              ReportError (NULL, 0, 3);	/* Ups - system out of memory! */
              return 0;
            }

          strcpy (modname, line);
          SearchLibraries (modname);	/* search name in libraries */
          free (modname);	/* remove copy of module name */
        }                          
    }
  while (nextname < endnames);

  return 1;
}




void 
SearchLibraries (char *modname)
{

  int i;
 

  for (i = 0; i < 2; i++)
    {				/* Libraries searched in max. 2 passes */
      while (CURRENTLIB != NULL)
        {
          if (SearchLibfile (CURRENTLIB, modname))
            return;

          CURRENTLIB = CURRENTLIB->nextlib;
          if (CURRENTLIB != NULL)
            if (CURRENTLIB->nextobjfile != 8)
              CURRENTLIB->nextobjfile = 8;	/* search at start of next lib */
        }

      /* last library read ... */
      CURRENTLIB = libraryhdr->firstlib;	/* start at the beginning of the first module */
      CURRENTLIB->nextobjfile = 8;		/* in the first library */
    }
}



int 
SearchLibfile (struct libfile *curlib, char *modname)
{
  long currentlibmodule, modulesize;
  int ret;
  char *mname;

  z80asmfile = fopen (curlib->libfilename, "rb");

  while (curlib->nextobjfile != -1)
    {				/* search name in all available library modules */
      do
        {			/* point at first available module in library */
          fseek (z80asmfile, curlib->nextobjfile, SEEK_SET);	/* point at beginning of a module */
          currentlibmodule = curlib->nextobjfile;
          curlib->nextobjfile = ReadLong (z80asmfile);	/* get file pointer to next module in library */
          modulesize = ReadLong (z80asmfile);	/* get size of current module */
        }
      while (modulesize == 0 && curlib->nextobjfile != -1);

      if (modulesize != 0)
        {
          if ( ( mname = CheckIfModuleWanted(z80asmfile, currentlibmodule, modname) ) != NULL )
            {
              fclose (z80asmfile);
              ret =  LinkLibModule (curlib, currentlibmodule + 4 + 4, mname);
              free(mname);
              return ret;
            }
          else if ( sdcc_hacks == ON && modname[0] == '_' && ( mname = CheckIfModuleWanted(z80asmfile, currentlibmodule, modname + 1) ) != NULL )
            {
              fclose (z80asmfile);
              ret =  LinkLibModule (curlib, currentlibmodule + 4 + 4, mname);
              free(mname);
              return ret;
            }
        }
    }

  fclose (z80asmfile);
  return 0;
}


/** \brief Check to see if a library module is required
 *
 *  \param z80asmfile - File to read from
 *  \param currentlibmodule - Current offset in file
 *  \param modname - Module/symbol to search for

 */
static char *
CheckIfModuleWanted(FILE *z80asmfile, long currentlibmodule, char *modname)
{
  long fptr_mname, fptr_expr, fptr_name, fptr_libname;
  char *mname;
  char *name;


  /* found module name? */
  fseek (z80asmfile, currentlibmodule + 4 + 4 + 8 + 2, SEEK_SET);	/* point at module name  file
                                                                     * pointer */
  fptr_mname = ReadLong (z80asmfile);	/* get module name file  pointer   */
  fptr_expr = ReadLong(z80asmfile);
  fptr_name = ReadLong(z80asmfile);
  fptr_libname = ReadLong(z80asmfile);
  fseek (z80asmfile, currentlibmodule + 4 + 4 + fptr_mname, SEEK_SET);	/* point at module name  */
  mname = strdup(ReadName ());			/* read module name */

  if (strcmp (mname, modname) == 0)
    {
      return mname;
    }


  /* We didn't find the module name, lets have a look through the exported symbol list */
  if ( fptr_name != 0 ) 
    {
      long end = fptr_libname;
      long red = 0;
      if ( fptr_libname == 0xffffffff )
        {
          end = fptr_mname;
        }
      /* Move to the name section */
      fseek(z80asmfile,currentlibmodule + 4 + 4 + fptr_name,SEEK_SET);
      red = fptr_name;
      while ( red < end ) 
        {
          char scope, type;
          long temp;

          scope = fgetc(z80asmfile); red++;
          type = fgetc(z80asmfile); red++;
          temp = ReadLong(z80asmfile); red += 4;
          name = ReadName();
          red += strlen(name);
          red++; /* Length byte */
          if ( (scope == 'X' || scope == 'G') && strcmp(name, modname) == 0 ) 
            {
              return mname;
            }
        }
    }
  free(mname);
  return NULL;
}

int 
LinkLibModule (struct libfile *library, long curmodule, char *modname)
{
  struct module *tmpmodule;
  int flag;
  char *mname;

  tmpmodule = CURRENTMODULE;	/* remember current module */

  if ((CURRENTMODULE = NewModule ()) != NULL)
    {
      mname = AllocIdentifier (strlen (modname) + 1);	/* get a copy of module name */
      if (mname != NULL)
        {
          strcpy (mname, modname);
          CURRENTMODULE->mname = mname;		/* create new module for library */
          CURRENTFILE = Newfile (NULL, library->libfilename);	/* filename for 'module' */

          if (verbose)
            printf ("Linking library module <%s>\n", modname);

          flag = LinkModule (library->libfilename, curmodule);	/* link   module & read names */
        }
      else
        {
          ReportError (NULL, 0, 3);
          flag = 0;
        }
    }
  else
    flag = 0;

  CURRENTMODULE = tmpmodule;	/* restore previous current module */
  return flag;
}



char *
ReadName (void)
{
  size_t strlength;

  strlength = fgetc (z80asmfile);
  fread (line, sizeof (char), strlength, z80asmfile);	/* read   name */
  line[strlength] = '\0';

  return line;
}



void 
ModuleExpr (void)
{
  long fptr_namedecl, fptr_modname, fptr_exprdecl, fptr_libnmdecl;
  long fptr_base;
  struct linkedmod *curlink;

  if (verbose)
    puts ("Pass2...");

  curlink = linkhdr->firstlink;
  do
    {
      CURRENTMODULE = curlink->moduleinfo;
      fptr_base = curlink->modulestart;

      if ((z80asmfile = fopen (curlink->objfilename, "rb")) != NULL)
        {			/* open relocatable file for reading */
          fseek (z80asmfile, fptr_base + 10, SEEK_SET);		/* point at module name  pointer   */
          fptr_modname = ReadLong (z80asmfile);		/* get file pointer to module name */
          fptr_exprdecl = ReadLong (z80asmfile);	/* get file pointer to expression declarations */
          fptr_namedecl = ReadLong (z80asmfile);	/* get file pointer to name declarations */
          fptr_libnmdecl = ReadLong (z80asmfile);	/* get file pointer to library name declarations */
        }
      else
        {
          ReportIOError (curlink->objfilename);		/* couldn't open relocatable file */
          return;
        }

      if (fptr_exprdecl != -1)
        {
          fseek (z80asmfile, fptr_base + fptr_exprdecl, SEEK_SET);
          if (fptr_namedecl != -1)
            ReadExpr (fptr_exprdecl, fptr_namedecl);	/* Evaluate until beginning of name
                                                         * declarations     */
          else if (fptr_libnmdecl != -1)
            ReadExpr (fptr_exprdecl, fptr_libnmdecl);	/* Evaluate until beginning of library
                                                         * reference declarations */
          else
            ReadExpr (fptr_exprdecl, fptr_modname);	/* Evaluate until beginning of module name */
        }
      fclose (z80asmfile);

      z80asmfile = NULL;
      curlink = curlink->nextlink;
    }
  while (curlink != NULL);
}



void 
CreateBinFile (void)
{
  char *tmpstr;
  char binfilenumber = '0';
  FILE *binaryfile;
  unsigned short codeblock, offset;

  if (expl_binflnm == ON)
    /* use predined output filename from command line */
    tmpstr = binfilename;
  else
    { 
      /* create output filename, based on project filename */
      tmpstr = modulehdr->first->cfile->fname;	/* get source filename from first module */
      if (codesegment == ON && CODESIZE > 16384)
        strcpy (tmpstr + strlen (tmpstr) - 4, segmbinext);	/* replace '.asm' with '.bn0' extension */
      else
        strcpy (tmpstr + strlen (tmpstr) - 4, binext);	/* replace '.asm' with '.bin' extension */
    }

  binaryfile = fopen (tmpstr, "wb");	/* binary output to srcfilename.bin */
  if (binaryfile != NULL)
    {
      if (autorelocate == ON && totaladdr != 0)
	{
	  fwrite (reloc_routine, sizeof (char), sizeof_relocroutine, binaryfile);	/* relocate routine */
	  *(reloctable + 0) = (unsigned short) totaladdr % 256U;
	  *(reloctable + 1) = (unsigned short) totaladdr / 256U;	/* total of relocation elements */
	  *(reloctable + 2) = (unsigned short) sizeof_reloctable % 256U;
	  *(reloctable + 3) = (unsigned short) sizeof_reloctable / 256U;/* total size of relocation table elements */

	  fwrite (reloctable, 1U, sizeof_reloctable + 4, binaryfile);	/* write relocation table, inclusive 4 byte header */
	  printf ("Relocation header is %d bytes.\n", (int)(sizeof_relocroutine + sizeof_reloctable + 4));
	  fwrite (codearea, sizeof (char), CODESIZE, binaryfile);	/* write code as one big chunk */
	  fclose (binaryfile);
	}
      else if (codesegment == ON && CODESIZE > 16384)
	{
	  fclose (binaryfile);
	  offset = 0;
	  do
	    {
	      codeblock = (CODESIZE / 16384U) ? 16384U : CODESIZE % 16384U;
	      CODESIZE -= codeblock;
	      tmpstr[strlen (tmpstr) - 1] = binfilenumber++;	/* path code file with number */
	      binaryfile = fopen (tmpstr, "wb");

	      if (binaryfile != NULL)
		{
		  fwrite (codearea + offset, sizeof (char), codeblock, binaryfile);	/* code in 16K chunks */
		  fclose (binaryfile);
		}

	      offset += codeblock;
	    }
	  while (CODESIZE);
	}
      else
	{
	  fwrite (codearea, sizeof (char), CODESIZE, binaryfile);	/* write code as one big chunk */
	  fclose (binaryfile);
	}

      if (verbose)
	puts ("Code generation completed.");
    }
  else
    ReportIOError (tmpstr);
}



void 
CreateLib (void)
{
  long Codesize;
  FILE *objectfile = NULL;
  long fptr;
  char *filebuffer, *fname;

  if (verbose)
    puts ("Creating library...");

  CURRENTMODULE = modulehdr->first;

  if ((errfilename = AllocIdentifier (strlen (libfilename) + 1)) != NULL)
    {
      strcpy (errfilename, libfilename);
      strcpy (errfilename + strlen (errfilename) - 4, errext);	/* overwrite '_lib' extension with '_err' */
    }
  else
    {
      ReportError (NULL, 0, 3);
      return;			/* No more room     */
    }

  if ((errfile = fopen (errfilename, "w")) == NULL)
    {				/* open error file */
      ReportIOError (errfilename);
      free (errfilename);
      errfilename = NULL;
      return;
    }
  do
    {
      fname = CURRENTFILE->fname;
      strcpy (fname + strlen (fname) - 4, objext);	/* overwrite '_asm' extension with '_obj' */

      if ((objectfile = fopen (CURRENTFILE->fname, "rb")) != NULL)
        {
          fseek(objectfile, 0L, SEEK_END);	/* file pointer to end of file */
	     Codesize = ftell(objectfile);
	     fseek(objectfile, 0L, SEEK_SET);	/* file pointer to start of file */
        	
	     filebuffer = (char *) malloc ((size_t) Codesize);
	     if (filebuffer == NULL)
	       {
	          ReportError (CURRENTFILE->fname, 0, 3);
	          fclose (objectfile);
	          break;
	       }
          fread (filebuffer, sizeof (char), Codesize, objectfile);	/* load object file */
  	     fclose (objectfile);

	     if (memcmp (filebuffer, Z80objhdr, 8U) == 0)
	       {
	          if (verbose)
                 printf ("<%s> module at %04lX.\n", CURRENTFILE->fname, ftell (libfile));

	          if (CURRENTMODULE->nextmodule == NULL)
		        WriteLong (-1, libfile);	/* this is the last module */
	          else
		       {
		         fptr = ftell (libfile) + 4 + 4;
		         WriteLong (fptr + Codesize, libfile);	/* file pointer to next module */
		       }
		       
	          WriteLong (Codesize, libfile);	/* size of this module */
	          fwrite (filebuffer, sizeof (char), (size_t) Codesize, libfile);	/* write module to library */
	          free (filebuffer);
	       }
	     else
	       {
	         free (filebuffer);
	         ReportError (CURRENTFILE->fname, 0, 26);
	         break;
	       }
	   }
      else
	   {
	     ReportError (CURRENTFILE->fname, 0, 0);
	     break;
	   }

      CURRENTMODULE = CURRENTMODULE->nextmodule;
    }
  while (CURRENTMODULE != NULL);

  fclose (errfile);
  errfile = NULL;

  if (ASMERROR == OFF)
    remove (errfilename);	/*    no errors */

  free (errfilename);
  errfilename = NULL;
}



int 
LinkTracedModule (char *filename, long baseptr)
{
  struct linkedmod *newm;
  char *fname;

  if (linkhdr == NULL)
    {
      if ((linkhdr = AllocLinkHdr ()) == NULL)
        {
          ReportError (NULL, 0, 3);
          return 0;
        }
      else
        {
          linkhdr->firstlink = NULL;
          linkhdr->lastlink = NULL;	/* Library header initialised */
        }
    }

  fname = AllocIdentifier (strlen (filename) + 1);	/* get a copy module file name */
  if (fname != NULL)
    strcpy (fname, filename);
  else
    {
      ReportError (NULL, 0, 3);
      return 0;
    }

  if ((newm = AllocTracedModule ()) == NULL)
    {
      free (fname);		/* release redundant copy of filename */
      ReportError (NULL, 0, 3);
      return 0;
    }
  else
    {
      newm->nextlink = NULL;
      newm->objfilename = fname;
      newm->modulestart = baseptr;
      newm->moduleinfo = CURRENTMODULE;		/* pointer to current (active) module structure   */
    }

  if (linkhdr->firstlink == NULL)
    {
      linkhdr->firstlink = newm;
      linkhdr->lastlink = newm;	/* First module trace information */
    }
  else
    {
      linkhdr->lastlink->nextlink = newm;	/* current/last linked module points now at new current */
      linkhdr->lastlink = newm;			/* pointer to current linked module updated */
    }

  return 1;
}




long 
ReadLong (FILE * fileid)
{

  int i;
  long fptr = 0;

  fptr = fgetc(fileid);
  fptr |= (fgetc(fileid) << 8);
  fptr |= (fgetc(fileid) << 16);
  fptr |= (fgetc(fileid) << 24);

  return fptr;
}



void 
WriteLong (long fptr, FILE * fileid)
{
  int i;

  for (i = 0; i < 4; i++)
    {
      fputc (fptr & 255, fileid);
      fptr >>= 8;
    }
}


void 
DefineOrigin (void)
{
  printf ("ORG not yet defined!\nPlease enter as hexadecimal: ");
  scanf ("%lx", &modulehdr->first->origin);
}



void 
CreateDeffile (void)
{
  char *globaldefname;

  /* use first module filename to create global definition file */

  if ((globaldefname = AllocIdentifier (strlen (modulehdr->first->cfile->fname) + 1)) != NULL)
    {
      strcpy (globaldefname, modulehdr->first->cfile->fname);
      strcpy (globaldefname + strlen (globaldefname) - 4, defext);	/* overwrite '_asm' extension with
									   * '_def' */
      if ((deffile = fopen (globaldefname, "w")) == NULL)
	{			/* Create DEFC file with global label declarations */
	  ReportIOError (globaldefname);
	  globaldef = OFF;
	}
    }
  else
    {
      ReportError (NULL, 0, 3);
      globaldef = OFF;
    }

  free (globaldefname);
  globaldefname = NULL;
}


void 
WriteMapFile (void)
{
  avltree *maproot = NULL, *newmaproot = NULL;
  struct module *cmodule;
  char *mapfilename;

  cmodule = modulehdr->first;	/* begin with first module */

  if ((mapfilename = AllocIdentifier (strlen (cmodule->cfile->fname) + 1)) != NULL)
    {
      strcpy (mapfilename, cmodule->cfile->fname);
      strcpy (mapfilename + strlen (mapfilename) - 4, mapext);	/* overwrite '_asm' extension with '_map' */
    }
  else
    {
      ReportError (NULL, 0, 3);
      return;			/* No more room */
    }

  if ((mapfile = fopen (mapfilename, "w")) != NULL)
    {				/* Create MAP file */
      if (verbose)
	puts ("Creating map...");

      do
	{
	  move (&cmodule->localroot, &maproot, (int (*)()) cmpidstr);	/* move all  local address symbols alphabetically */
	  cmodule = cmodule->nextmodule;	/* alphabetically */
	}
      while (cmodule != NULL);

      move (&globalroot, &maproot, (int (*)()) cmpidstr);	/* move all global address symbols alphabetically */

      if (maproot == NULL)
	fputs ("None.\n", mapfile);
      else
	{
	  inorder (maproot, (void (*)()) WriteMapSymbol);	/* Write map symbols alphabetically */
	  move (&maproot, &newmaproot, (int (*)()) cmpidval);	/* then re-order symbols numerically */
	  fputs ("\n\n", mapfile);

	  inorder (newmaproot, (void (*)()) WriteMapSymbol);	/* Write map symbols numerically */
	  deleteall (&newmaproot, (void (*)()) FreeSym);	/* then release all map symbols */
	}

      fclose (mapfile);
    }
  else
    {
      ReportIOError (mapfilename);
      return;
    }

  free (mapfilename);
}



void 
WriteMapSymbol (symbol * mapnode)
{
  int tabulators, space;

  if (mapnode->type & SYMADDR)
    {
      fprintf (mapfile, "%s", mapnode->symname);
      space = COLUMN_WIDTH - strlen (mapnode->symname);
      for (tabulators = space % TAB_DIST ? space / TAB_DIST + 1 : space / TAB_DIST;
	   tabulators > 0; tabulators--)
	fputc ('\t', mapfile);

      if (autorelocate)
	fprintf (mapfile, "= %04lX, ", sizeof_relocroutine + sizeof_reloctable + 4 + mapnode->symvalue);
      else
	fprintf (mapfile, "= %04lX, ", mapnode->symvalue);

      if (mapnode->type & SYMLOCAL)
	fputc ('L', mapfile);
      else
	fputc ('G', mapfile);

      fprintf (mapfile, ": %s\n", mapnode->owner->mname);
    }
}



void 
WriteGlobal (symbol * node)
{
  int tabulators, space;

  if ((node->type & SYMTOUCHED) && (node->type & SYMADDR) &&
      (node->type & SYMXDEF) && !(node->type & SYMDEF))
    {
      /* Write only global definitions - not library routines     */
      fprintf (deffile, "DEFC %s", node->symname);

      space = COLUMN_WIDTH - 5 - strlen (node->symname);
      for (tabulators = space % TAB_DIST ? space / TAB_DIST + 1 : space / TAB_DIST; tabulators > 0; tabulators--)
	fputc ('\t', deffile);

      fprintf (deffile, "= $%04lX; ", node->symvalue + modulehdr->first->origin + CURRENTMODULE->startoffset);
      fprintf (deffile, "Module %s\n", node->owner->mname);
    }
}



void 
ReleaseLinkInfo (void)
{
  struct linkedmod *m, *n;

  if (linkhdr == NULL)
    return;

  m = linkhdr->firstlink;

  do
    {
      if (m->objfilename != NULL)
	free (m->objfilename);

      n = m->nextlink;
      free (m);
      m = n;
    }
  while (m != NULL);

  free (linkhdr);

  linkhdr = NULL;
}


struct linklist *
AllocLinkHdr (void)
{
  return (struct linklist *) malloc (sizeof (struct linklist));
}


struct linkedmod *
AllocTracedModule (void)
{
  return (struct linkedmod *) malloc (sizeof (struct linkedmod));
}

/*
 * Local Variables:
 *  indent-tabs-mode:nil
 *  require-final-newline:t
 *  c-basic-offset: 2
 *  eval: (c-set-offset 'case-label 0)
 *  eval: (c-set-offset 'substatement-open 2)
 *  eval: (c-set-offset 'access-label 0)
 *  eval: (c-set-offset 'class-open 2)
 *  eval: (c-set-offset 'class-close 2)
 * End:
 */
