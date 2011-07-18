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
Copyright (C) Paulo Custodio, 2011
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.c,v 1.4 2011-07-18 00:48:25 pauloscustodio Exp $ */
/* $Log: options.c,v $
/* Revision 1.4  2011-07-18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.3  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.2  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.1  2011/07/11 15:40:46  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c
/*
/* */

#include "memalloc.h"	/* before any other include to enable memory leak detection */

#include <string.h>
#include <ctype.h>
#include "z80asm.h"
#include "options.h"
#include "symbols.h"
#include "errors.h"

/* global option variables */
enum flag smallc_source;
enum flag ti83plus;
enum flag swapIXIY;
enum flag clinemode;
long clineno;
enum flag codesegment;
enum flag datestamp;
enum flag sdcc_hacks;
enum flag force_xlib;
enum flag listing;
enum flag listing_CPY;
enum flag symtable;
enum flag symfile;
enum flag z80bin;
enum flag mapref;
enum flag verbose;
enum flag globaldef;
enum flag autorelocate;
enum flag deforigin;
enum flag expl_binflnm;
char binfilename[64];		/* -o explicit filename buffer */

/*-----------------------------------------------------------------------------
*   ResetOptions
*	Reset globals to defaults
*----------------------------------------------------------------------------*/
void ResetOptions (void) 
{
    smallc_source   = OFF;
    ti83plus	    = OFF;
    swapIXIY	    = OFF;
    clinemode	    = OFF;
    clineno	    = 0;
    codesegment	    = OFF;
    datestamp	    = OFF;
    sdcc_hacks	    = OFF;
    force_xlib	    = OFF;
    listing	    = OFF;
    listing_CPY	    = OFF;
    symtable	    = ON;
    symfile	    = ON;
    z80bin	    = OFF;
    mapref	    = ON;
    verbose	    = OFF;
    globaldef	    = OFF;
    autorelocate    = OFF;
    deforigin	    = OFF; 
    expl_binflnm    = OFF;
}

/*-----------------------------------------------------------------------------
*   SetAsmFlag
*	Parse one command line option
*   Args:
*	string after the initial '-' option start
*   Sets global option variables, stop with error if option cannot be parsed
*----------------------------------------------------------------------------*/
void SetAsmFlag (char *flagid)
{
    if (*flagid == 'e') {
	smallc_source = ON;			/* use ".xxx" as source file in stead of ".asm" */
	srcext[0] = '.';
	strncpy ((srcext + 1), (flagid + 1), 3);
						/* copy argument string */
	srcext[4] = '\0';			/* max. 3 letters extension */
    }

    /* djm: mod to get .o files produced instead of .obj */
    /* gbs: extended to use argument as definition, e.g. -Mo, which defines .o extension */
    else if (*flagid == 'M') {
	strncpy ((objext + 1), (flagid + 1), 3);/* copy argument string (append after '.') */
	objext[4] = '\0';			/* max. 3 letters extension */
    }

    /** Check whether this is for the RCM2000/RCM3000 series of Z80-like CPU's */
    else if (strcmp (flagid, "RCMX000") == 0) {
	cpu_type = CPU_RCM2000;
    }

    /* check weather to use an RST or CALL when Invoke is used */
    else if (strcmp(flagid, "plus") == 0 ) {
	ti83plus = ON;
    }

    /* (stefano) IX and IY swap option */
    else if (strcmp (flagid, "IXIY") == 0) {
	swapIXIY = ON;
    }

    /* djm turn on c line mode to report line number of C source */
    else if (strcmp(flagid, "C") == 0) {
	clinemode = ON;
    }

    /* split in 16K blocks */
    else if (strcmp(flagid, "c") == 0) {
	codesegment = ON;
    }

    else if ( strcmp(flagid, "sdcc") == 0 ) {
	sdcc_hacks = ON;
    }

    else if ( strcmp(flagid, "forcexlib") == 0 ) {
	force_xlib = ON;
    }

    else if (strcmp (flagid, "l") == 0) {
	listing_CPY = listing = ON;
	if (symtable)
	    symfile = OFF;
    }

    else if (strcmp (flagid, "nl") == 0) {
	listing_CPY = listing = OFF;
	if (symtable)
	    symfile = ON;
    }

    else if (strcmp (flagid, "s") == 0) {
	symtable = ON;
	if (listing_CPY)
	    symfile = OFF;
	else
	    symfile = ON;
    }

    else if (strcmp (flagid, "ns") == 0) {
	symtable = symfile = OFF;
    }
    
    else if (strcmp (flagid, "b") == 0) {
	z80bin = ON;		/* perform address relocation & linking */
    }

    else if (strcmp (flagid, "nb") == 0) {
	z80bin = OFF;
	mapref = OFF;
    }

    else if (strcmp (flagid, "d") == 0) {
	datestamp = ON;		/* assemble only if source > object file */
    }

    else if (strcmp (flagid, "nd") == 0) {
	datestamp = OFF;
    }

    /* -b, -d */
    else if (strcmp (flagid, "a") == 0) {
	z80bin = ON;
	datestamp = ON;
    }

    else if (strcmp (flagid, "v") == 0) {
	verbose = ON;
    }

    else if (strcmp (flagid, "nv") == 0) {
	verbose = OFF;
    }

    else if (strcmp (flagid, "m") == 0) {
	mapref = ON;  
    }

    else if (strcmp (flagid, "nm") == 0) {
	mapref = OFF;
    }

    else if (strcmp (flagid, "g") == 0) {
	globaldef = ON;
    }

    else if (strcmp (flagid, "ng") == 0) {
	globaldef = OFF;
    }

    else if (strcmp (flagid, "R") == 0) {
	autorelocate = ON;
    }

    else if (strcmp (flagid, "nR") == 0) {
	autorelocate = OFF;
    }

    else if (*flagid == 'i') {
	GetLibfile ((flagid + 1));
    }

    else if (*flagid == 'x') {
	CreateLibfile ((flagid + 1));
    }

    else if (*flagid == 'r') {
	sscanf (flagid + 1, "%x", &EXPLICIT_ORIGIN);
	deforigin = ON;		/* explicit origin has been defined */
    }

    else if (*flagid == 'o') {
	sscanf (flagid + 1, "%s", binfilename); /* store explicit filename for .BIN file */
	expl_binflnm = ON;      
    }

    else if (*flagid == 't') {
	sscanf (flagid + 1, "%d", &TAB_DIST);
    }

    else if (*flagid == 'I') {
	int i = include_dir_num++;
	include_dir = realloc(include_dir, include_dir_num * sizeof(include_dir[0]));
	include_dir[i] = strdup(flagid+1);
    }

    else if (*flagid == 'L') {
	int i = lib_dir_num++;
	lib_dir = realloc(lib_dir, lib_dir_num * sizeof(lib_dir[0]));
	lib_dir[i] = strdup(flagid+1);
    }

    else if (*flagid == 'D') {
	int i;

	strcpy (ident, (flagid + 1));	/* copy argument string */
	if (!isalpha (ident[0])) {
	    ReportError (NULL, 0, ERR_ILLEGAL_IDENT);	/* symbol must begin with alpha */
	    return;
	}
	i = 0;
	while (ident[i] != '\0') {
	    if (strchr (separators, ident[i]) == NULL) {
		if (!isalnum (ident[i])) {
		    if (ident[i] != '_') {
			ReportError (NULL, 0, ERR_ILLEGAL_IDENT);	/* illegal char in identifier */
			return;
		    }
		    else {
			ident[i] = '_';			/* underscore in identifier */
		    }
		}
		else {
		    ident[i] = toupper (ident[i]);
		}
	    }
	    else {
		ReportError (NULL, 0, ERR_ILLEGAL_IDENT);		/* illegal char in identifier */
		return;
	    }
	    ++i;
	}
	DefineDefSym (ident, 1, 0, &staticroot);
    }

    else if (strcmp (flagid, "h") == 0) {
	usage();
	exit(1);
    }

    else {
	/* BUG_0003 was missing Illegal Option error */
	ReportError (NULL, 0, ERR_ILLEGAL_OPTION, flagid);
    }
}

