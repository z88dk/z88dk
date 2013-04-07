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
Copyright (C) Paulo Custodio, 2011-2013
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.c,v 1.23 2013-04-07 22:26:07 pauloscustodio Exp $ */
/* $Log: options.c,v $
/* Revision 1.23  2013-04-07 22:26:07  pauloscustodio
/* Removed global variable smallc_source, no longer used
/*
/* Revision 1.22  2013/04/06 13:15:04  pauloscustodio
/* Move default asm and obj extension handling to file.c.
/* srcfilename and objfilename are now pointers to static variables in file.c
/*
/* Revision 1.21  2013/04/03 22:52:56  pauloscustodio
/* Move libfilename to options.c, keep it in strpool
/*
/* Revision 1.20  2013/02/27 22:34:16  pauloscustodio
/* Move include path search to srcfile.c
/*
/* Revision 1.19  2013/02/27 20:47:30  pauloscustodio
/* Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
/*
/* Revision 1.18  2013/02/25 21:36:17  pauloscustodio
/* Uniform the APIs of classhash, classlist, strhash, strlist
/*
/* Revision 1.17  2013/02/19 22:52:40  pauloscustodio
/* BUG_0030 : List bytes patching overwrites header
/* BUG_0031 : List file garbled with input lines with 255 chars
/* New listfile.c with all the listing related code
/*
/* Revision 1.16  2013/02/12 00:55:00  pauloscustodio
/* CH_0017 : Align with spaces, deprecate -t option
/*
/* Revision 1.15  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.14  2012/11/03 17:39:36  pauloscustodio
/* astyle, comments
/*
/* Revision 1.13  2012/05/26 18:51:10  pauloscustodio
/* CH_0012 : wrappers on OS calls to raise fatal error
/* CH_0013 : new errors interface to decouple calling code from errors.c
/*
/* Revision 1.12  2012/05/24 21:48:24  pauloscustodio
/* Remove the global variables include_dir, lib_dir, and respective
/* counts, create instead the paths in the options module and
/* create new search_include_file() and search_lib_file()
/* functions to replace SearchFile().
/*
/* Revision 1.11  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.10  2012/05/24 15:04:20  pauloscustodio
/* Make invalid option error fatal
/*
/* Revision 1.9  2012/05/17 21:36:06  pauloscustodio
/* Remove global ASMERROR, redundant with TOTALERRORS.
/* Remove IllegalArgumentException, replace by FatalErrorException.
/*
/* Revision 1.8  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.7  2011/10/14 14:57:45  pauloscustodio
/* - Move cpu_type to options.c.
/* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
/*
/* Revision 1.6  2011/08/21 20:25:31  pauloscustodio
/* BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX
/* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
/* - Factor all pathname manipulation into module file.c.
/* - Make default extensions constants.
/* - Move asm_ext[] and obj_ext[] to the options.c module.
/*
/* Revision 1.5  2011/08/05 19:58:28  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
/* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
/* removing all the test code after each memory allocation.
/* Replaced all exit(1) by an exception.
/*
/* Revision 1.4  2011/07/18 00:48:25  pauloscustodio
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

#include "memalloc.h"   /* before any other include */

#include "errors.h"
#include "file.h"
#include "options.h"
#include "srcfile.h"
#include "strlist.h"
#include "strpool.h"
#include "symbols.h"
#include "z80asm.h"
#include <ctype.h>
#include <string.h>

/* global option variables */
enum flag ti83plus;
enum flag swapIXIY;
enum flag clinemode;
long clineno;
enum flag codesegment;
enum flag datestamp;
enum flag sdcc_hacks;
enum flag force_xlib;
enum flag listing;
enum flag option_list;
enum flag option_symtable;
enum flag symfile;
enum flag z80bin;
enum flag mapref;
enum flag verbose;
enum flag globaldef;
enum flag autorelocate;
enum flag deforigin;
enum flag expl_binflnm;
char *libfilename;				/* -i, -x library file, kept in strpool */
char binfilename[FILENAME_MAX]; /* -o explicit filename buffer (BUG_0012) */
int  cpu_type;

/* directory list for search_lib_file() */
static SzList *lib_path = NULL;

/*-----------------------------------------------------------------------------
*   Initialize search paths
*----------------------------------------------------------------------------*/
static void init_search_paths( void )
{
    char *dir;

	/* init source path */
    dir = getenv( "Z80_OZFILES" );
    if ( dir != NULL )
    {
        add_source_file_path( dir );
    }

	/* init lib path */
    if ( lib_path == NULL )
    {
        lib_path = OBJ_NEW( SzList );
    }
}

/*-----------------------------------------------------------------------------
*   Search file
*----------------------------------------------------------------------------*/
char *search_lib_file( char *filename )
{
    return search_file( filename, lib_path );
}

/*-----------------------------------------------------------------------------
*   reset_options
*       Reset globals to defaults
*----------------------------------------------------------------------------*/
void reset_options( void )
{
    ti83plus        = OFF;
    swapIXIY        = OFF;
    clinemode       = OFF;
    clineno         = 0;
    codesegment     = OFF;
    datestamp       = OFF;
    sdcc_hacks      = OFF;
    force_xlib      = OFF;
    listing         = OFF;
    option_list     = OFF;
    option_symtable = ON;
    symfile         = ON;
    z80bin          = OFF;
    mapref          = ON;
    verbose         = OFF;
    globaldef       = OFF;
    autorelocate    = OFF;
    deforigin       = OFF;
    expl_binflnm    = OFF;
    cpu_type        = CPU_Z80;

    init_search_paths();                /* initialize the search paths */
}

/*-----------------------------------------------------------------------------
*   set_asm_flag
*       Parse one command line option
*   Args:
*       string after the initial '-' option start
*   Sets global option variables, stop with error if option cannot be parsed
*----------------------------------------------------------------------------*/
void set_asm_flag( char *flagid )
{
	/* use ".xxx" as source file in stead of ".asm" */
    if ( *flagid == 'e' )
    {
		set_asm_ext( flagid + 1 );
    }

    /* djm: mod to get .o files produced instead of .obj */
    /* gbs: extended to use argument as definition, e.g. -Mo, which defines .o extension */
    else if ( *flagid == 'M' )
    {
		set_obj_ext( flagid + 1 );
    }

    /** Check whether this is for the RCM2000/RCM3000 series of Z80-like CPU's */
    else if ( strcmp( flagid, "RCMX000" ) == 0 )
    {
        cpu_type = CPU_RCM2000;
    }

    /* check weather to use an RST or CALL when Invoke is used */
    else if ( strcmp( flagid, "plus" ) == 0 )
    {
        ti83plus = ON;
    }

    /* (stefano) IX and IY swap option */
    else if ( strcmp( flagid, "IXIY" ) == 0 )
    {
        swapIXIY = ON;
    }

    /* djm turn on c line mode to report line number of C source */
    else if ( strcmp( flagid, "C" ) == 0 )
    {
        clinemode = ON;
    }

    /* split in 16K blocks */
    else if ( strcmp( flagid, "c" ) == 0 )
    {
        codesegment = ON;
    }

    else if ( strcmp( flagid, "sdcc" ) == 0 )
    {
        sdcc_hacks = ON;
    }

    else if ( strcmp( flagid, "forcexlib" ) == 0 )
    {
        force_xlib = ON;
    }

    else if ( strcmp( flagid, "l" ) == 0 )
    {
        option_list = listing = ON;

		if ( option_symtable )
        {
            symfile = OFF;
        }
    }

    else if ( strcmp( flagid, "nl" ) == 0 )
    {
        option_list = listing = OFF;

		if ( option_symtable )
        {
            symfile = ON;
        }
    }

    else if ( strcmp( flagid, "s" ) == 0 )
    {
        option_symtable = ON;

        if ( option_list )
        {
            symfile = OFF;
        }
        else
        {
            symfile = ON;
        }
    }

    else if ( strcmp( flagid, "ns" ) == 0 )
    {
        option_symtable = symfile = OFF;
    }

    else if ( strcmp( flagid, "b" ) == 0 )
    {
        z80bin = ON;            /* perform address relocation & linking */
    }

    else if ( strcmp( flagid, "nb" ) == 0 )
    {
        z80bin = OFF;
        mapref = OFF;
    }

    else if ( strcmp( flagid, "d" ) == 0 )
    {
        datestamp = ON;         /* assemble only if source > object file */
    }

    else if ( strcmp( flagid, "nd" ) == 0 )
    {
        datestamp = OFF;
    }

    /* -b, -d */
    else if ( strcmp( flagid, "a" ) == 0 )
    {
        z80bin = ON;
        datestamp = ON;
    }

    else if ( strcmp( flagid, "v" ) == 0 )
    {
        verbose = ON;
    }

    else if ( strcmp( flagid, "nv" ) == 0 )
    {
        verbose = OFF;
    }

    else if ( strcmp( flagid, "m" ) == 0 )
    {
        mapref = ON;
    }

    else if ( strcmp( flagid, "nm" ) == 0 )
    {
        mapref = OFF;
    }

    else if ( strcmp( flagid, "g" ) == 0 )
    {
        globaldef = ON;
    }

    else if ( strcmp( flagid, "ng" ) == 0 )
    {
        globaldef = OFF;
    }

    else if ( strcmp( flagid, "R" ) == 0 )
    {
        autorelocate = ON;
    }

    else if ( strcmp( flagid, "nR" ) == 0 )
    {
        autorelocate = OFF;
    }

    else if ( *flagid == 'i' )
    {
        libfilename = GetLibfile( ( flagid + 1 ) );
    }

    else if ( *flagid == 'x' )
    {
        libfilename = CreateLibfile( ( flagid + 1 ) );
    }

    else if ( *flagid == 'r' )
    {
        sscanf( flagid + 1, "%x", &EXPLICIT_ORIGIN );
        deforigin = ON;         /* explicit origin has been defined */
    }

    else if ( *flagid == 'o' )
    {
        /* store explicit filename for .BIN file (BUG_0012) */
        binfilename[0] = '\0';          /* prepare for strncat */
        strncat( binfilename, flagid + 1, sizeof( binfilename ) - 1 );
        expl_binflnm = ON;
    }

    else if ( *flagid == 't' )
    {
		flagid[1] = '\0';
		warning( ERR_OPTION_DEPRECATED, flagid );		/* CH_0017 */
    }

    else if ( *flagid == 'I' )
    {
        add_source_file_path( flagid + 1 );
    }

    else if ( *flagid == 'L' )
    {
        SzList_push( lib_path, flagid + 1 );
    }

    else if ( *flagid == 'D' )
    {
        int i;

        strcpy( ident, ( flagid + 1 ) ); /* copy argument string */

        if ( !isalpha( ident[0] ) )
        {
            error( ERR_ILLEGAL_IDENT );  /* symbol must begin with alpha */
            return;
        }

        i = 0;

        while ( ident[i] != '\0' )
        {
            if ( strchr( separators, ident[i] ) == NULL )
            {
                if ( !isalnum( ident[i] ) )
                {
                    if ( ident[i] != '_' )
                    {
                        error( ERR_ILLEGAL_IDENT );      /* illegal char in identifier */
                        return;
                    }
                    else
                    {
                        ident[i] = '_';                 /* underscore in identifier */
                    }
                }
                else
                {
                    ident[i] = toupper( ident[i] );
                }
            }
            else
            {
                error( ERR_ILLEGAL_IDENT );              /* illegal char in identifier */
                return;
            }

            ++i;
        }

        DefineDefSym( ident, 1, 0, &staticroot );
    }

    else if ( strcmp( flagid, "h" ) == 0 )
    {
        usage();
        throw( FatalErrorException, "usage" );
    }

    else
    {
        /* BUG_0003 was missing Illegal Option error */
        fatal_error( ERR_ILLEGAL_OPTION, flagid );
    }
}


