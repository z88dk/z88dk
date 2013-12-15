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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.c,v 1.62 2013-12-15 19:01:07 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "scan.h"
#include "file.h"
#include "hist.h"
#include "options.h"
#include "strpool.h"
#include "symtab.h"
#include "z80asm.h"
#include <ctype.h>
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

/* types */
enum OptType 
{ 
	OptClear, OptSet, 
	OptCall, OptCallArg, OptCallOptArg, 
	OptString, OptStringList, 
	OptDeprecated,
};

/* declare functions */
static void exit_help(void);
static void exit_copyright(void);
static void display_options(void);
static void option_make_updated_bin(void);
static void option_origin(char *origin_hex);
static void option_define(char *symbol);
static void option_make_lib(char *library);
static void option_use_lib(char *library);
static void option_cpu_RCM2000(void);

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
*   Initialize module
*----------------------------------------------------------------------------*/
void init_options(void)
{
    char *directory = getenv("Z80_OZFILES");
    if ( directory )
		add_StringList( &opts.inc_path, directory );
}


/*-----------------------------------------------------------------------------
*   Parse command line, set options, call back for each non-option, 
*	process @lists
*----------------------------------------------------------------------------*/
void parse_argv(int argc, char *argv[], 
 			    void (*process_file)(char *filename) )
{
	int arg;

	if ( argc == 1 )
		exit_copyright();				/* exit if no arguments */

	parse_options(&arg, argc, argv);	/* process all options, set arg to next */

    if ( arg >= argc )
        error_no_src_file();			/* no source file */

    if ( opts.verbose )
        display_options();				/* display status messages of select assembler options */

	if ( ! get_num_errors() )
		parse_files(arg, argc, argv, process_file);		/* process each source file */
}

/*-----------------------------------------------------------------------------
*   process all options
*----------------------------------------------------------------------------*/
/* check if this oprion is matched, return char pointer after option, ready
   to retrieve an argument, if any */
static char *check_option(char *arg, char *opt)
{
	size_t len = strlen(opt);
	if ( *opt &&				/* ignore empty option strings */
		 strncmp( arg, opt, len ) == 0 )
	{
		if ( arg[len] == '=' )	
			len++;				/* skip '=' after option, to point at argument */
		return arg + len;		/* point to after argument */
	}
	else
		return NULL;			/* not found */
}

static void process_opt(int *parg, int argc, char *argv[])
{
#define i (*parg)
	int		 j;
	char	*opt_arg_ptr;

	/* search opts_lu[] */
	for ( j = 0; j < NUM_ELEMS(opts_lu); j++ )
	{
		if ( (opt_arg_ptr = check_option( argv[i], opts_lu[j].long_opt )) != NULL ||
			 (opt_arg_ptr = check_option( argv[i], opts_lu[j].short_opt )) != NULL )
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

			case OptCallArg:
				if ( *opt_arg_ptr )
					((void (*)(char *))(opts_lu[j].arg)) ( opt_arg_ptr );
				else
					error_illegal_option( argv[i] );
				break;

			case OptCallOptArg:
				((void (*)(char *))(opts_lu[j].arg)) ( opt_arg_ptr );
				break;

			case OptString:
				if ( *opt_arg_ptr )
					*((char **)(opts_lu[j].arg)) = opt_arg_ptr;
				else
					error_illegal_option( argv[i] );
				break;

			case OptStringList:
				if ( *opt_arg_ptr )
					add_StringList( (StringList **)(opts_lu[j].arg), opt_arg_ptr );
				else
					error_illegal_option( argv[i] );
				break;

			case OptDeprecated:
				if ( *opt_arg_ptr )
					*opt_arg_ptr = '\0';		/* delete option argument for warning message */
				warn_option_deprecated( argv[i] );
				break;

			default:
				die( "missing case at %s:%d\n", __FILE__, __LINE__ );
			}
			return;
		}
	}

	/* not found */
	error_illegal_option( argv[i] );

#undef i
}

static void parse_options(int *parg, int argc, char *argv[])
{
#define i (*parg)

    for ( i = 1; i < argc && argv[i][0] == '-'; i++ )
		process_opt( &i, argc, argv );

#undef i
}

/*-----------------------------------------------------------------------------
*   process a file
*----------------------------------------------------------------------------*/
static void parse_file( char *filename, void (*process_file)(char *filename) )
{
	g_strstrip(filename);
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
static void parse_file_list( Scan *files, 
						     char *filename, void (*process_file)(char *filename) )
{
	char *line;

	g_strstrip(filename);
	if ( filename[0] == '@' )
	{
		g_strstrip(filename+1);
		scan_file_Scan( files, filename+1 );

		while ( (line = get_line_Scan( files )) != NULL )
		{
			g_strstrip(line);
			if ( line[0] == '@' )
			{
				g_strstrip(line+1);
				scan_file_Scan( files, line+1 );		/* recurse */
			}
			else 
			{
				parse_file( line, process_file );
			}
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
	Scan *files = OBJ_NEW(Scan);
	{
		int i; 

		/* Assemble file list */
		for ( i = arg; i < argc; i++ )
			parse_file_list( files, argv[i], process_file );
	}
	OBJ_DELETE(files);
}

/*-----------------------------------------------------------------------------
*   Show information and exit - functions
*----------------------------------------------------------------------------*/
#define OPT_TITLE(text)		puts(""); puts(text);
#define OPT(type, arg, short_opt, long_opt, help_text, help_arg) \
							show_option(type, (BOOL *)arg, \
										short_opt, long_opt, help_text, help_arg);

#define ALIGN_HELP	24

static void show_option(enum OptType type, BOOL *pflag, 
						char *short_opt, char *long_opt, char *help_text, char *help_arg)
{
	char msg[ MAXLINE ];
	int count_opts = 0;

	if ( type == OptDeprecated )
		return;							/* skip deprecated options */

	/* show default option */
	if ( type == OptSet   &&   *pflag ||
		 type == OptClear && ! *pflag )
		g_snprintf( msg, sizeof(msg), "* " );
	else
		g_snprintf( msg, sizeof(msg), "  " );

	if ( *short_opt )
	{
		/* dont show short_opt if short_opt is same as long_opt, except for extra '-',
		   e.g. -sdcc and --sdcc */
		if ( ! (*long_opt && strcmp(short_opt, long_opt+1) == 0) )
		{
			g_snprintf( msg + strlen(msg), sizeof(msg) - strlen(msg), 
						"%s", short_opt );
			count_opts++;
		}
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

	exit(0);
}

static void exit_copyright(void)
{
    printf("%s\n", copyrightmsg);
	exit(0);
}

static void display_options(void)
{
    if ( opts.date_stamp )						puts( OPT_HELP_DATE_STAMP );
    else										puts( OPT_HELP_NO_DATE_STAMP );	
    if ( opts.symtable )						puts( OPT_HELP_SYMTABLE );
    if ( opts.list )							puts( OPT_HELP_LIST );
    if ( opts.globaldef )    					puts( OPT_HELP_GLOBALDEF );
    if ( opts.lib_file )						puts( OPT_HELP_MAKE_LIB );
    if ( opts.make_bin )						puts( OPT_HELP_MAKE_BIN );
    if ( opts.library )							puts( OPT_HELP_USE_LIB );
    if ( opts.make_bin && opts.map )			puts( OPT_HELP_MAP );
    if ( opts.code_seg && ! opts.relocatable )	puts( OPT_HELP_CODE_SEG );
    if ( opts.relocatable )						puts( OPT_HELP_RELOCATABLE );

    putchar( '\n' );
}

/*-----------------------------------------------------------------------------
*   Option functions called from Opts table
*----------------------------------------------------------------------------*/
static void option_make_updated_bin(void)
{
    opts.make_bin = opts.date_stamp = TRUE;
}

static void option_origin(char *origin_hex)
{
	long origin = strtol( origin_hex, NULL, 16 );
	if ( origin < 0 || origin > 0xFFFF )
		error_int_range(origin);
	opts.origin = (int) origin;
}

static void option_define(char *symbol)
{
	int i;

	strtoupper(symbol);			/* convert to upper case */

	/* check syntax */
	if ( ! isalpha( symbol[0] ) )
	{
		error_illegal_ident();
		return;
	}

	for ( i = 1; symbol[i]; i++ )
	{
		if ( ! isalnum( symbol[i] ) && symbol[i] != '_' )
		{
			error_illegal_ident();
			return;
		}
	}

    define_static_def_sym( symbol, 1 );
}

static void option_make_lib(char *library)
{
	opts.lib_file = CreateLibfile( library );
}

static void option_use_lib(char *library)
{
	GetLibfile( library );
}

static void option_cpu_RCM2000(void)
{
	opts.cpu = CPU_RCM2000;
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







/* 
* $Log: options.c,v $
* Revision 1.62  2013-12-15 19:01:07  pauloscustodio
* Move platform specific defines from types.h to config.h.
* Remove dependency of types.h from glib.h.
* Use NUM_ELEMS() instead of glib G_N_ELEMENTS().
*
* Revision 1.61  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.60  2013/11/11 23:47:03  pauloscustodio
* Move source code generation tools to dev/Makefile, only called on request,
* and keep the generated files in z80asm directory, so that build does
* not require tools used for the code generation (ragel, perl).
* Remove code generation for structs - use CLASS macro instead.
*
* Revision 1.59  2013/10/16 00:14:37  pauloscustodio
* Move FileStack implementation to scan.c, remove FileStack.
* Move getline_File() to scan.c.
*
* Revision 1.58  2013/10/15 23:16:02  pauloscustodio
* includes
*
* Revision 1.57  2013/10/05 13:43:05  pauloscustodio
* Parse command line options via look-up tables:
* -i, --use-lib
* -x, --make-lib
*
* Revision 1.56  2013/10/05 11:31:46  pauloscustodio
* Parse command line options via look-up tables:
* -D, --define
*
* Revision 1.55  2013/10/05 10:54:36  pauloscustodio
* Parse command line options via look-up tables:
* -I, --inc-path
* -L, --lib-path
*
* Revision 1.54  2013/10/05 09:24:13  pauloscustodio
* Parse command line options via look-up tables:
* -t (deprecated)
*
* Revision 1.53  2013/10/05 08:54:01  pauloscustodio
* Parse command line options via look-up tables:
* -forcexlib, --forcexlib
*
* Revision 1.52  2013/10/05 08:14:43  pauloscustodio
* Parse command line options via look-up tables:
* -C, --line-mode
*
* Revision 1.51  2013/10/04 23:31:50  pauloscustodio
* Parse command line options via look-up tables:
* -IXIY, --swap-ix-iy
*
* Revision 1.50  2013/10/04 23:20:21  pauloscustodio
* Parse command line options via look-up tables:
* -plus, --ti83plus
*
* Revision 1.49  2013/10/04 23:09:25  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
*
* Revision 1.48  2013/10/04 22:24:01  pauloscustodio
* Parse command line options via look-up tables:
* -c, --code-seg
*
* Revision 1.47  2013/10/04 22:04:52  pauloscustodio
* Unify option describing texts
*
* Revision 1.46  2013/10/04 21:18:34  pauloscustodio
* dont show short_opt if short_opt is same as long_opt, except for extra '-',
* e.g. -sdcc and --sdcc
*
* Revision 1.45  2013/10/03 23:48:31  pauloscustodio
* Parse command line options via look-up tables:
* -r, --origin=ORG_HEX
*
* Revision 1.44  2013/10/03 22:54:06  pauloscustodio
* Parse command line options via look-up tables:
* -a, --make-updated-bin
*
* Revision 1.43  2013/10/03 22:35:21  pauloscustodio
* Parse command line options via look-up tables:
* -d, --date-stamp
* -nd, --no-date-stamp
*
* Revision 1.42  2013/10/03 22:20:10  pauloscustodio
* Parse command line options via look-up tables:
* -o, --output
*
* Revision 1.41  2013/10/03 21:58:41  pauloscustodio
* Parse command line options via look-up tables:
* -b, --make-bin
* -nb, --no-make-bin
*
* Revision 1.40  2013/10/03 00:04:38  pauloscustodio
* log
*
* Revision 1.39  2013/10/02 23:34:44  pauloscustodio
* Parse command line options via look-up tables:
* show default option in help
*
* Revision 1.38  2013/10/02 23:20:43  pauloscustodio
* Parse command line options via look-up tables:
* -g, --globaldef
* -ng, --no-globaldef
*
* Revision 1.37  2013/10/01 23:46:28  pauloscustodio
* Parse command line options via look-up tables:
* -m, --map
* -nm, --no-map
*
* Revision 1.36  2013/10/01 23:23:53  pauloscustodio
* Parse command line options via look-up tables:
* -l, --list
* -nl, --no-list
*
* Revision 1.35  2013/10/01 22:50:26  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
*
* Revision 1.34  2013/10/01 22:09:33  pauloscustodio
* Parse command line options via look-up tables:
* -sdcc
*
* Revision 1.33  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
*
* Revision 1.32  2013/09/29 21:43:48  pauloscustodio
* Parse command line options via look-up tables:
* move @file handling to options.c
*
* Revision 1.31  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
*
* Revision 1.30  2013/09/23 23:14:10  pauloscustodio
* Renamed SzList to StringList, simplified interface by assuming that
* list lives in memory util program ends; it is used for directory searches
* only. Moved interface to strutil.c, removed strlist.c.
*
* Revision 1.29  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.28  2013/09/01 12:00:07  pauloscustodio
* Cleanup compilation warnings
*
* Revision 1.27  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.26  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
*
* Revision 1.25  2013/06/08 23:07:53  pauloscustodio
* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
*  and define_global_def_sym().
*
* Revision 1.24  2013/06/01 01:24:22  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
*
* Revision 1.23  2013/04/07 22:26:07  pauloscustodio
* Removed global variable smallc_source, no longer used
*
* Revision 1.22  2013/04/06 13:15:04  pauloscustodio
* Move default asm and obj extension handling to file.c.
* srcfilename and objfilename are now pointers to static variables in file.c
*
* Revision 1.21  2013/04/03 22:52:56  pauloscustodio
* Move libfilename to options.c, keep it in strpool
*
* Revision 1.20  2013/02/27 22:34:16  pauloscustodio
* Move include path search to srcfile.c
*
* Revision 1.19  2013/02/27 20:47:30  pauloscustodio
* Renamed StrList to SzList to solve conflict with CLASS_LIST( Str ) also generating a class StrList
*
* Revision 1.18  2013/02/25 21:36:17  pauloscustodio
* Uniform the APIs of classhash, classlist, strhash, strlist
*
* Revision 1.17  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
* Revision 1.16  2013/02/12 00:55:00  pauloscustodio
* CH_0017 : Align with spaces, deprecate -t option
*
* Revision 1.15  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.14  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.13  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.12  2012/05/24 21:48:24  pauloscustodio
* Remove the global variables include_dir, lib_dir, and respective
* counts, create instead the paths in the options module and
* create new search_include_file() and search_lib_file()
* functions to replace SearchFile().
*
* Revision 1.11  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.10  2012/05/24 15:04:20  pauloscustodio
* Make invalid option error fatal
*
* Revision 1.9  2012/05/17 21:36:06  pauloscustodio
* Remove global ASMERROR, redundant with TOTALERRORS.
* Remove IllegalArgumentException, replace by FatalErrorException.
*
* Revision 1.8  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.7  2011/10/14 14:57:45  pauloscustodio
* - Move cpu_type to options.c.
* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
*
* Revision 1.6  2011/08/21 20:25:31  pauloscustodio
* BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX
* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
* - Factor all pathname manipulation into module file.c.
* - Make default extensions constants.
* - Move asm_ext[] and obj_ext[] to the options.c module.
*
* Revision 1.5  2011/08/05 19:58:28  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
* removing all the test code after each memory allocation.
* Replaced all exit(1) by an exception.
*
* Revision 1.4  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*
* Revision 1.3  2011/07/14 01:32:08  pauloscustodio
*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
*
* Revision 1.2  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.1  2011/07/11 15:40:46  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c
*/
