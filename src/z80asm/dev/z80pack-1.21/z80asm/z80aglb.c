/*
 *	Z80 - Assembler
 *	Copyright (C) 1987-2014 by Udo Munk
 *
 *	History:
 *	17-SEP-1987 Development under Digital Research CP/M 2.2
 *	28-JUN-1988 Switched to Unix System V.3
 *	21-OCT-2006 changed to ANSI C for modern POSIX OS's
 *	03-FEB-2007 more ANSI C conformance and reduced compiler warnings
 *	18-MAR-2007 use default output file extension dependend on format
 *	04-OCT-2008 fixed comment bug, ';' string argument now working
 */

/*
 *	this module contains all global variables other
 *	than CPU specific tables
 */

#include <stdio.h>
#include "z80a.h"

char *infiles[MAXFN],		/* source filenames */
     objfn[LENFN + 1],		/* object filename */
     lstfn[LENFN + 1],		/* listing filename */
     *srcfn,			/* filename of current processed source file */
     line[MAXLINE],		/* buffer for one line souce */
     tmp[MAXLINE],		/* temporary buffer */
     label[SYMSIZE+1],		/* buffer for label */
     opcode[MAXLINE],		/* buffer for opcode */
     operand[MAXLINE],		/* buffer for operand */
     ops[OPCARRAY],		/* buffer for generated object code */
     title[MAXLINE];		/* buffer for titel of souce */

int  list_flag,			/* flag for option -l */
     sym_flag,			/* flag for option -s */
     ver_flag,			/* flag for option -v */
     dump_flag,			/* flag for option -x */
     pc,			/* programm counter */
     pass,			/* processed pass */
     iflevel,			/* IF nesting level */
     gencode = 1,		/* flag for conditional object code */
     errors,			/* error counter */
     errnum,			/* error number in pass 2 */
     sd_flag,			/* list flag for PSEUDO opcodes */
				/* = 0: address from <val>, data from <ops> */
				/* = 1: address from <sd_val>, data from <ops>*/
				/* = 2: no address, data from <ops> */
				/* = 3: address from <sd_val>, no data */
				/* = 4: suppress whole line */
     sd_val,			/* output value for PSEUDO opcodes */
     prg_adr,			/* start address of programm */
     prg_flag,			/* flag for prg_adr valid */
     out_form = OUTDEF,		/* format of object file */
     symsize;			/* size of symarray */

FILE *srcfp,			/* file pointer for current source */
     *objfp,			/* file pointer for object code */
     *lstfp,			/* file pointer for listing */
     *errfp;			/* file pointer for error output */

unsigned
      c_line,			/* current line no. in current source */
      s_line,			/* line no. counter for listing */
      p_line,			/* no. printed lines on page */
      ppl = PLENGTH,		/* page length */
      page;			/* no. of pages for listing */

struct sym
     *symtab[HASHSIZE],		/* symbol table */
     **symarray;		/* sorted symbol table */
