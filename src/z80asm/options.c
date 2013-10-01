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

Parse command line options

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.c,v 1.34 2013-10-01 22:09:33 pauloscustodio Exp $
*/

#include "memalloc.h"   /* before any other include */

#include "errors.h"
#include "file.h"
#include "hist.h"
#include "options.h"
#include "strpool.h"
#include <glib.h>
#include <string.h>

/* default file name extensions */
#define FILEEXT_ASM     FILEEXT_SEPARATOR "asm"    /* ".asm" / "_asm" */
#define FILEEXT_LST     FILEEXT_SEPARATOR "lst"    /* ".lst" / "_lst" */
#define FILEEXT_OBJ     FILEEXT_SEPARATOR "obj"    /* ".obj" / "_obj" */
#define FILEEXT_DEF     FILEEXT_SEPARATOR "def"    /* ".def" / "_def" */
#define FILEEXT_ERR     FILEEXT_SEPARATOR "err"    /* ".err" / "_err" */
#define FILEEXT_BIN     FILEEXT_SEPARATOR "bin"    /* ".bin" / "_bin" */
#define FILEEXT_SEGBIN  FILEEXT_SEPARATOR "bn0"    /* ".bn0" / "_bn0" */
#define FILEEXT_LIB     FILEEXT_SEPARATOR "lib"    /* ".lib" / "_lib" */
#define FILEEXT_SYM     FILEEXT_SEPARATOR "sym"    /* ".sym" / "_sym" */
#define FILEEXT_MAP     FILEEXT_SEPARATOR "map"    /* ".map" / "_map" */

/* declare functions */
static void reset_options( void );
static void exit_help(void);
static void exit_copyright(void);
static void display_options(void);
static void parse_options(int *parg, int argc, char *argv[]);
static void parse_files(int arg, int argc, char *argv[], 
 			            void (*process_file)(char *filename) );

/*-----------------------------------------------------------------------------
*   singleton opts
*----------------------------------------------------------------------------*/
#define OPT_VAR(type, name, default)	default,
Opts opts =
{
#include "options_def.h"
};

/*-----------------------------------------------------------------------------
*   lookup-table for all options
*----------------------------------------------------------------------------*/
typedef struct OptsLU
{
	enum OptType	 type;		/* type of option */
	void			*arg;		/* option argument */
	char			*short_opt;	/* option text, including starting "-" */
	char			*long_opt;	/* option text, including starting "--" */
} 
OptsLU;

#define OPT(type, arg, short_opt, long_opt, help_text, help_arg) \
		  { type, arg, short_opt, long_opt },

static OptsLU opts_lu[] =
{
#include "options_def.h"
};

/*-----------------------------------------------------------------------------
*   Parse command line, set options, call back for each non-option, 
*	process @lists
*----------------------------------------------------------------------------*/
void parse_argv(int argc, char *argv[], 
 			    void (*process_file)(char *filename) )
{
	int arg;

    reset_options();					/* set defaults */

	if ( argc == 1 )
		exit_copyright();				/* exit if no arguments */

	parse_options(&arg, argc, argv);	/* process all options, set arg to next */

    if ( arg >= argc )
        error_no_src_file();			/* no source file */

    if ( opts.verbose )
        display_options();				/* display status messages of select assembler options */

	parse_files(arg, argc, argv, process_file);		/* process each source file */
}

/*-----------------------------------------------------------------------------
*   process all options
*----------------------------------------------------------------------------*/
static char *opt_arg(char *arg, char *opt)
{
	size_t len = strlen(opt);
	if ( *opt &&				/* ignore empty option strings */
		 strncmp( arg, opt, len ) == 0 )
		return arg + len;		/* point to after argument */
	else
		return NULL;			/* not found */
}

static char *get_opt_arg(char *opt_arg_ptr, int *parg, int argc, char *argv[])
{
#define i (*parg)

	if ( *opt_arg_ptr )		/* get argument from same argv */
	{
		/* skip '=' */
		if ( *opt_arg_ptr == '=' )
			opt_arg_ptr++;

		return opt_arg_ptr;
	}
	else					/* get argument from next argv */
	{
		if ( i+1 < argc )
			return argv[ ++i ];
		else
		{
			error_illegal_option( argv[i] );
			return NULL;
		}
	}

#undef i
}

static BOOL process_opt(int *parg, int argc, char *argv[])
{
#define i (*parg)
	int		 j;
	char	*opt_arg_ptr;

	/* search opts_lu[] */
	for ( j = 0; j < (int)G_N_ELEMENTS(opts_lu); j++ )
	{
		if ( (opt_arg_ptr = opt_arg( argv[i], opts_lu[j].long_opt )) != NULL ||
			 (opt_arg_ptr = opt_arg( argv[i], opts_lu[j].short_opt )) != NULL )
		{
			/* found option, opt_arg_ptr points to after option */
			switch ( opts_lu[j].type )
			{
			case OptClear:
				if ( *opt_arg_ptr )
					error_illegal_option( argv[i] );
				else
					*((BOOL *)(opts_lu[j].arg)) = FALSE;
				break;

			case OptSet:
				if ( *opt_arg_ptr )
					error_illegal_option( argv[i] );
				else
					*((BOOL *)(opts_lu[j].arg)) = TRUE;
				break;

			case OptCall:
				if ( *opt_arg_ptr )
					error_illegal_option( argv[i] );
				else
					((void (*)(void))(opts_lu[j].arg)) ();
				break;

			case OptString:
				opt_arg_ptr = get_opt_arg( opt_arg_ptr, parg, argc, argv );
				if ( opt_arg_ptr )
					*((char **)(opts_lu[j].arg)) = opt_arg_ptr;
				break;

			default:
				error_illegal_option( argv[i] );
			}
			return TRUE;
		}
	}

	return FALSE;

#undef i
}

static void parse_options(int *parg, int argc, char *argv[])
{
#define i (*parg)

    for ( i = 1; i < argc && argv[i][0] == '-'; i++ )
    {
		if ( ! process_opt( &i, argc, argv ) )
			set_asm_flag( argv[i] + 1 );
    }

#undef i
}

/*-----------------------------------------------------------------------------
*   process a file
*----------------------------------------------------------------------------*/
static void parse_file( char *filename, void (*process_file)(char *filename) )
{
	switch ( filename[0] )
	{
        case '-':		/* Illegal source file name */
            error_illegal_src_filename( filename );
            break;

        case '\0':		/* no file */
			break;

        default:
            process_file( filename );
	}
}

/*-----------------------------------------------------------------------------
*   process a @list file or a simple file
*----------------------------------------------------------------------------*/
static void parse_file_list( FileStack *files, 
						     char *filename, void (*process_file)(char *filename) )
{
	char *line;

	if ( filename[0] == '@' )
	{
		read_to_FileStack( files, filename+1 );

		while ( (line = getline_FileStack( files )) != NULL )
		{
			g_strstrip(line);
			if ( line[0] == '@' )
				read_to_FileStack( files, line+1 );		/* recurse */
			else 
				parse_file( line, process_file );
		}
	}
	else 
	{
		parse_file( filename, process_file );
	}
}

/*-----------------------------------------------------------------------------
*   process all files
*----------------------------------------------------------------------------*/
static void parse_files(int arg, int argc, char *argv[], 
						void (*process_file)(char *filename) )
{
	FileStack *files = new_FileStack();
	{
		int i; 

		/* Assemble file list */
		for ( i = arg; i < argc; i++ )
			parse_file_list( files, argv[i], process_file );
	}
	delete0_FileStack( &files );
}

/*-----------------------------------------------------------------------------
*   Show information and exit - functions
*----------------------------------------------------------------------------*/
#define OPT_TITLE(text)		puts(""); puts(text);
#define OPT(type, arg, short_opt, long_opt, help_text, help_arg) \
							show_option(short_opt, long_opt, help_text, help_arg);

#define ALIGN_HELP	24

static void show_option(char *short_opt, char *long_opt, char *help_text, char *help_arg)
{
	char msg[ MAXLINE ];
	int count_opts = 0;

	g_snprintf( msg, sizeof(msg), 
				"  " );
	if ( *short_opt )
	{
		g_snprintf( msg + strlen(msg), sizeof(msg) - strlen(msg), 
					"%s", short_opt );
		count_opts++;
	}
	
	if ( *long_opt )
	{
		if ( count_opts )
			g_snprintf( msg + strlen(msg), sizeof(msg) - strlen(msg), 
						", " );
		g_snprintf( msg + strlen(msg), sizeof(msg) - strlen(msg), 
					"%s", long_opt );
		count_opts++;
	}

	if ( *help_arg )
	{
		g_snprintf( msg + strlen(msg), sizeof(msg) - strlen(msg), 
					"=%s", help_arg );
	}

	if ( strlen(msg) > ALIGN_HELP )
		printf("%s\n%-*s %s\n", msg, ALIGN_HELP, "",  help_text );
	else
		printf(    "%-*s %s\n",      ALIGN_HELP, msg, help_text );
}
#undef ALIGN_HELP

static void exit_help(void)
{
    puts(  copyrightmsg );
	puts(  "" );
	puts(  "Usage:" );
    puts(  "  z80asm [options] { @<modulefile> | <filename> }" );
	puts(  "" );
    puts(  "  [] = optional, {} = may be repeated, | = OR clause." );
	puts(  "" );
    printf("  To assemble 'fred%s%s' use 'fred' or 'fred%s%s'\n", 
		   FILEEXT_SEPARATOR, opts.asm_ext, 
		   FILEEXT_SEPARATOR, opts.asm_ext );
	puts(  "" );
    puts(  "  <modulefile> contains list of file names of all modules to be linked," );
	puts(  "  one module per line." );
	puts(  "" );
    puts(  "  File types recognized or created by z80asm:" );
    printf("    %s%s = source file (default), or alternative -e<ext>\n", 
		   FILEEXT_SEPARATOR, opts.asm_ext );
    printf("    %s%s = object file (default), or alternative -M<ext>\n", 
		   FILEEXT_SEPARATOR, opts.obj_ext );
    printf("    %s = list file\n", FILEEXT_LST );
    printf("    %s = Z80 binary file\n", FILEEXT_BIN );
    printf("    %s = symbols file\n", FILEEXT_SYM );
    printf("    %s = map file\n", FILEEXT_MAP );
    printf("    %s = global address definition file\n", FILEEXT_DEF );
    printf("    %s = error file\n", FILEEXT_ERR );

#include "options_def.h"

	puts(  "" );
    puts( "Options: -n defines option to be turned OFF (except -r -R -i -x -D -t -o)" );
    printf( "-l listing file, -s symbol table, -m map listing file\n" );
    puts( "-r<ORG> Explicit relocation <ORG> defined in hex (ignore ORG in first module)" );
    puts( "-plus Interpret 'Invoke' as RST 28h" );
    puts( "-R Generate relocatable code (Automatical relocation before execution)" );
    puts( "-D<symbol> define symbol as logically TRUE (used for conditional assembly)" );
    puts( "-b assemble files & link to ORG address. -c split code in 16K banks" );
    puts( "-d date stamp control, assemble only if source file > object file" );
    puts( "-a: -b & -d (assemble only updated source files, then link & relocate)" );
    puts( "-o<bin filename> expl. output filename, -g XDEF reloc. addr. from all modules" );
    printf( "-i<library> include <library> LIB modules with %s%s modules during linking\n", 
		   FILEEXT_SEPARATOR, opts.obj_ext );
    puts( "-x<library> create library from specified modules ( e.g. with @<modules> )" );
    printf( "-t<n> tabulator width for %s, %s, %s files. Column width is 4 times -t\n", FILEEXT_MAP, FILEEXT_DEF, FILEEXT_SYM );
    printf( "-I<path> additional path to search for includes\n" );
    printf( "-L<path> path to search for libraries\n" );
    puts( "Default options: -nv -nd -nb -nl -s -m -ng -nc -nR -t8" );

	exit(0);
}

static void exit_copyright(void)
{
    printf("%s\n", copyrightmsg);
	exit(0);
}

static void display_options(void)
{
    if ( datestamp == ON )
        puts( "Assemble only updated files." );
    else
        puts( "Assemble all files." );

    if ( symfile == ON )
        puts( "Create symbol table file." );

    if ( listing == ON )
        puts( "Create listing file." );

    if ( globaldef == ON )
        puts( "Create global definition file." );

    if ( createlibrary == ON )
        puts( "Create library from specified modules." );

    if ( z80bin == ON )
        puts( "Link/relocate assembled modules." );

    if ( library == ON )
        puts( "Link library modules with code." );

    if ( z80bin == ON && mapref == ON )
        puts( "Create address map file." );

    if ( codesegment == ON && autorelocate == OFF )
        puts( "Split code into 16K banks." );

    if ( autorelocate == ON )
        puts( "Create relocatable code." );

    putchar( '\n' );
}

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/

static char *replace_ext( char *filename, char *ext )
{
	char new_filename[ FILENAME_MAX ];
	return strpool_add( path_replace_ext( new_filename, filename, ext ));
}

char *get_lst_filename( char *filename ) { return replace_ext( filename, FILEEXT_LST ); }
char *get_def_filename( char *filename ) { return replace_ext( filename, FILEEXT_DEF ); }
char *get_err_filename( char *filename ) { return replace_ext( filename, FILEEXT_ERR ); }
char *get_bin_filename( char *filename ) { return replace_ext( filename, FILEEXT_BIN ); }
char *get_lib_filename( char *filename ) { return replace_ext( filename, FILEEXT_LIB ); }
char *get_sym_filename( char *filename ) { return replace_ext( filename, FILEEXT_SYM ); }
char *get_map_filename( char *filename ) { return replace_ext( filename, FILEEXT_MAP ); }

char *get_asm_filename( char *filename ) 
{ 
	char ext[ FILENAME_MAX ];
	g_snprintf( ext, sizeof(ext), "%s%s", FILEEXT_SEPARATOR, opts.asm_ext );
	return replace_ext( filename, ext ); 
}

char *get_obj_filename( char *filename ) 
{ 
	char ext[ FILENAME_MAX ];
	g_snprintf( ext, sizeof(ext), "%s%s", FILEEXT_SEPARATOR, opts.obj_ext );
	return replace_ext( filename, ext ); 
}

char *get_segbin_filename( char *filename, int segment ) 
{
	char ext[ FILENAME_MAX ];
	int len;

	g_strlcpy( ext, FILEEXT_SEGBIN, sizeof(ext) );
	len = strlen(ext);
	g_snprintf( ext + len - 1, sizeof(ext) - (len-1), "%d", segment );
	return replace_ext( filename, ext ); 
}







/* $Log: options.c,v $
/* Revision 1.34  2013-10-01 22:09:33  pauloscustodio
/* Parse command line options via look-up tables:
/* -sdcc
/*
/* Revision 1.33  2013/09/30 00:24:25  pauloscustodio
/* Parse command line options via look-up tables:
/* -e, --asm-ext
/* -M, --obj-ext
/* Move filename extension functions to options.c
/*
/* Revision 1.32  2013/09/29 21:43:48  pauloscustodio
/* Parse command line options via look-up tables:
/* move @file handling to options.c
/*
/* Revision 1.31  2013/09/27 01:14:33  pauloscustodio
/* Parse command line options via look-up tables:
/* --help, --verbose
/*
/* Revision 1.30  2013/09/23 23:14:10  pauloscustodio
/* Renamed SzList to StringList, simplified interface by assuming that
/* list lives in memory util program ends; it is used for directory searches
/* only. Moved interface to strutil.c, removed strlist.c.
/*
/* Revision 1.29  2013/09/08 00:43:59  pauloscustodio
/* New error module with one error function per error, no need for the error
/* constants. Allows compiler to type-check error message arguments.
/* Included the errors module in the init() mechanism, no need to call
/* error initialization from main(). Moved all error-testing scripts to
/* one file errors.t.
/*
/* Revision 1.28  2013/09/01 12:00:07  pauloscustodio
/* Cleanup compilation warnings
/*
/* Revision 1.27  2013/09/01 00:18:28  pauloscustodio
/* - Replaced e4c exception mechanism by a much simpler one based on a few
/*   macros. The former did not allow an exit(1) to be called within a
/*   try-catch block.
/*
/* Revision 1.26  2013/06/08 23:37:32  pauloscustodio
/* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
/*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
/* Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
/*
/* Revision 1.25  2013/06/08 23:07:53  pauloscustodio
/* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
/* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
/*  and define_global_def_sym().
/*
/* Revision 1.24  2013/06/01 01:24:22  pauloscustodio
/* CH_0022 : Replace avltree by hash table for symbol table
/*
/* Revision 1.23  2013/04/07 22:26:07  pauloscustodio
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
#include "strutil.h"
#include "strpool.h"
#include "symbol.h"
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
enum flag force_xlib;
enum flag listing;
enum flag option_list;
enum flag option_symtable;
enum flag symfile;
enum flag z80bin;
enum flag mapref;
enum flag globaldef;
enum flag autorelocate;
enum flag deforigin;
enum flag expl_binflnm;
char *libfilename;				/* -i, -x library file, kept in strpool */
char binfilename[FILENAME_MAX]; /* -o explicit filename buffer (BUG_0012) */
int  cpu_type;
enum flag library;
enum flag createlibrary;


/* directory list for search_lib_file() */
static StringList *lib_path = NULL;

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
static void reset_options( void )
{
    ti83plus        = OFF;
    swapIXIY        = OFF;
    clinemode       = OFF;
    clineno         = 0;
    codesegment     = OFF;
    datestamp       = OFF;
    force_xlib      = OFF;
    listing         = OFF;
    option_list     = OFF;
    option_symtable = ON;
    symfile         = ON;
    z80bin          = OFF;
    mapref          = ON;
    globaldef       = OFF;
    autorelocate    = OFF;
    deforigin       = OFF;
    expl_binflnm    = OFF;
    cpu_type        = CPU_Z80;
	library			= OFF;
	createlibrary   = OFF;

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
    /** Check whether this is for the RCM2000/RCM3000 series of Z80-like CPU's */
    if ( strcmp( flagid, "RCMX000" ) == 0 )
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
        sscanf( flagid + 1, "%x", (size_t *)&EXPLICIT_ORIGIN );
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
		warn_option_deprecated(flagid);		/* CH_0017 */
    }

    else if ( *flagid == 'I' )
    {
        add_source_file_path( flagid + 1 );
    }

    else if ( *flagid == 'L' )
    {
        add_StringList( &lib_path, flagid + 1 );
    }

    else if ( *flagid == 'D' )
    {
        int i;

        strcpy( ident, ( flagid + 1 ) ); /* copy argument string */

        if ( !isalpha( ident[0] ) )
        {
            error_illegal_ident();  /* symbol must begin with alpha */
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
                        error_illegal_ident();      /* illegal char in identifier */
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
                error_illegal_ident();              /* illegal char in identifier */
                return;
            }

            ++i;
        }

        define_static_def_sym( ident, 1 );
    }

    else
    {
        /* BUG_0003 was missing Illegal Option error */
        error_illegal_option_OLD( flagid );
    }
}


