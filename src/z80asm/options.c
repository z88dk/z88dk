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
Copyright (C) Paulo Custodio, 2011-2014

Parse command line options

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options.c,v 1.92 2014-10-03 22:57:50 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "fileutil.h"
#include "hist.h"
#include "init.h"
#include "model.h"
#include "options.h"
#include "srcfile.h"
#include "strpool.h"
#include "strutil.h"
#include "symtab.h"
#include "z80asm.h"
#include <ctype.h>
#include <string.h>
#include <assert.h>

/* default file name extensions */
#define FILEEXT_ASM     FILEEXT_SEPARATOR "asm"    /* ".asm" / "_asm" */
#define FILEEXT_LST     FILEEXT_SEPARATOR "lst"    /* ".lst" / "_lst" */
#define FILEEXT_OBJ     FILEEXT_SEPARATOR "obj"    /* ".obj" / "_obj" */
#define FILEEXT_DEF     FILEEXT_SEPARATOR "def"    /* ".def" / "_def" */
#define FILEEXT_ERR     FILEEXT_SEPARATOR "err"    /* ".err" / "_err" */
#define FILEEXT_BIN     FILEEXT_SEPARATOR "bin"    /* ".bin" / "_bin" */
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
static void exit_help( void );
static void exit_copyright( void );
static void display_options( void );
static void option_make_updated_bin( void );
static void option_origin( char *origin_hex );
static void option_define( char *symbol );
static void option_make_lib( char *library );
static void option_use_lib( char *library );
static void option_cpu_RCM2000( void );

static void process_options( int *parg, int argc, char *argv[] );
static void process_files( int arg, int argc, char *argv[] );

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
DEFINE_init()
{
    char *directory = getenv( "Z80_OZFILES" );

    if ( directory )
        List_push( &opts.inc_path, strpool_add( directory ) );
}

DEFINE_fini()
{
}

/*-----------------------------------------------------------------------------
*   Parse command line, set options, including opts.files with list of
*	input files, including parsing of '@' lists
*----------------------------------------------------------------------------*/
void parse_argv( int argc, char *argv[] )
{
    int arg;

    init();

    if ( argc == 1 )
        exit_copyright();				/* exit if no arguments */

    process_options( &arg, argc, argv );	/* process all options, set arg to next */

    if ( arg >= argc )
        error_no_src_file();			/* no source file */

    if ( opts.verbose )
        display_options();				/* display status messages of select assembler options */

    if ( ! get_num_errors() )
        process_files( arg, argc, argv );	/* process each source file */
}

/*-----------------------------------------------------------------------------
*   process all options
*----------------------------------------------------------------------------*/
/* check if this option is matched, return char pointer after option, ready
   to retrieve an argument, if any */
static char *check_option( char *arg, char *opt )
{
    size_t len = strlen( opt );

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

static void process_opt( int *parg, int argc, char *argv[] )
{
#define i (*parg)
    int		 j;
    char	*opt_arg_ptr;

    /* search opts_lu[] */
    for ( j = 0; j < NUM_ELEMS( opts_lu ); j++ )
    {
        if ( ( opt_arg_ptr = check_option( argv[i], opts_lu[j].long_opt ) ) != NULL ||
                ( opt_arg_ptr = check_option( argv[i], opts_lu[j].short_opt ) ) != NULL )
        {
            /* found option, opt_arg_ptr points to after option */
            switch ( opts_lu[j].type )
            {
            case OptClear:
                if ( *opt_arg_ptr )
                    error_illegal_option( argv[i] );
                else
                    *( ( Bool * )( opts_lu[j].arg ) ) = FALSE;

                break;

            case OptSet:
                if ( *opt_arg_ptr )
                    error_illegal_option( argv[i] );
                else
                    *( ( Bool * )( opts_lu[j].arg ) ) = TRUE;

                break;

            case OptCall:
                if ( *opt_arg_ptr )
                    error_illegal_option( argv[i] );
                else
                    ( ( void ( * )( void ) )( opts_lu[j].arg ) )();

                break;

            case OptCallArg:
                if ( *opt_arg_ptr )
                    ( ( void ( * )( char * ) )( opts_lu[j].arg ) )( opt_arg_ptr );
                else
                    error_illegal_option( argv[i] );

                break;

            case OptCallOptArg:
                ( ( void ( * )( char * ) )( opts_lu[j].arg ) )( opt_arg_ptr );
                break;

            case OptString:
                if ( *opt_arg_ptr )
                    *( ( char ** )( opts_lu[j].arg ) ) = opt_arg_ptr;
                else
                    error_illegal_option( argv[i] );

                break;

            case OptStringList:
                if ( *opt_arg_ptr )
                    List_push( ( List ** ) opts_lu[j].arg, strpool_add( opt_arg_ptr ) );
                else
                    error_illegal_option( argv[i] );

                break;

            case OptDeprecated:
                if ( *opt_arg_ptr )
                    *opt_arg_ptr = '\0';		/* delete option argument for warning message */

                warn_option_deprecated( argv[i] );
                break;

            default:
                assert(0);
            }

            return;
        }
    }

    /* not found */
    error_illegal_option( argv[i] );

#undef i
}

static void process_options( int *parg, int argc, char *argv[] )
{
#define i (*parg)

    for ( i = 1; i < argc && argv[i][0] == '-'; i++ )
        process_opt( &i, argc, argv );

#undef i
}

/*-----------------------------------------------------------------------------
*   process a file
*----------------------------------------------------------------------------*/
static void process_file( char *filename )
{
	char *line;

    strip( filename );

    switch ( filename[0] )
    {
    case '-':		/* Illegal source file name */
        error_illegal_src_filename( filename );
        break;

    case '\0':		/* no file */
        break;

	case '@':		/* file list */
		filename++;						/* point to after '@' */
		strip( filename );

		/* loop on file to read each line and recurse */
		src_push();
		{
			src_open( filename, NULL );
			while ( (line = src_getline()) != NULL )
				process_file( line );
		}
		src_pop();
		break;

    default:
        List_push( &opts.files, strpool_add(filename) );
    }
}

/*-----------------------------------------------------------------------------
*   process all files
*----------------------------------------------------------------------------*/
static void process_files( int arg, int argc, char *argv[] )
{
    int i;

    /* Assemble file list */
    for ( i = arg; i < argc; i++ )
        process_file( argv[i] );
}

/*-----------------------------------------------------------------------------
*   Show information and exit - functions
*----------------------------------------------------------------------------*/
#define OPT_TITLE(text)		puts(""); puts(text);
#define OPT(type, arg, short_opt, long_opt, help_text, help_arg) \
							show_option(type, (Bool *)arg, \
										short_opt, long_opt, help_text, help_arg);

#define ALIGN_HELP	24

static void show_option( enum OptType type, Bool *pflag,
                         char *short_opt, char *long_opt, char *help_text, char *help_arg )
{
    DEFINE_STR( msg, MAXLINE );
    int count_opts = 0;

    if ( type == OptDeprecated )
        return;							/* skip deprecated options */

    /* show default option */
    if ( ( type == OptSet   &&   *pflag ) ||
            ( type == OptClear && ! *pflag ) )
        Str_set( msg, "* " );
    else
        Str_set( msg, "  " );

    if ( *short_opt )
    {
        /* dont show short_opt if short_opt is same as long_opt, except for extra '-',
           e.g. -sdcc and --sdcc */
        if ( !( *long_opt && strcmp( short_opt, long_opt + 1 ) == 0 ) )
        {
            Str_append_sprintf( msg, "%s", short_opt );
            count_opts++;
        }
    }

    if ( *long_opt )
    {
        if ( count_opts )
            Str_append( msg, ", " );

        Str_append_sprintf( msg, "%s", long_opt );
        count_opts++;
    }

    if ( *help_arg )
    {
        Str_append_sprintf( msg, "=%s", help_arg );
    }

    if ( msg->len > ALIGN_HELP )
        printf( "%s\n%-*s %s\n", msg->str, ALIGN_HELP, "",       help_text );
    else
        printf( "%-*s %s\n",           ALIGN_HELP, msg->str, help_text );
}
#undef ALIGN_HELP

static void exit_help( void )
{
    puts( copyrightmsg );
    puts( "" );
    puts( "Usage:" );
    puts( "  z80asm [options] { @<modulefile> | <filename> }" );
    puts( "" );
    puts( "  [] = optional, {} = may be repeated, | = OR clause." );
    puts( "" );
    printf( "  To assemble 'fred%s%s' use 'fred' or 'fred%s%s'\n",
            FILEEXT_SEPARATOR, opts.asm_ext,
            FILEEXT_SEPARATOR, opts.asm_ext );
    puts( "" );
    puts( "  <modulefile> contains list of file names of all modules to be linked," );
    puts( "  one module per line." );
    puts( "" );
    puts( "  File types recognized or created by z80asm:" );
    printf( "    %s%s = source file (default), or alternative -e<ext>\n",
            FILEEXT_SEPARATOR, opts.asm_ext );
    printf( "    %s%s = object file (default), or alternative -M<ext>\n",
            FILEEXT_SEPARATOR, opts.obj_ext );
    printf( "    %s = list file\n", FILEEXT_LST );
    printf( "    %s = Z80 binary file\n", FILEEXT_BIN );
    printf( "    %s = symbols file\n", FILEEXT_SYM );
    printf( "    %s = map file\n", FILEEXT_MAP );
    printf( "    %s = global address definition file\n", FILEEXT_DEF );
    printf( "    %s = error file\n", FILEEXT_ERR );

#include "options_def.h"

    exit( 0 );
}

static void exit_copyright( void )
{
    printf( "%s\n", copyrightmsg );
    exit( 0 );
}

static void display_options( void )
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

    if ( opts.relocatable )						puts( OPT_HELP_RELOCATABLE );

    putchar( '\n' );
}

/*-----------------------------------------------------------------------------
*   Option functions called from Opts table
*----------------------------------------------------------------------------*/
static void option_make_updated_bin( void )
{
    opts.make_bin = opts.date_stamp = TRUE;
}

static void option_origin( char *origin_hex )
{
	Section *default_section;
    Int origin = strtol( origin_hex, NULL, 16 );

    if ( origin < 0 || origin > 0xFFFF )
        error_int_range( origin );

	default_section = get_first_section(NULL);
	default_section->origin			= origin;
	default_section->origin_opts	= TRUE;
}

static void option_define( char *symbol )
{
    int i;

    /* check syntax - BUG_0045 */
    if ( (! isalpha( symbol[0] )) && (symbol[0] != '_') )
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

static void option_make_lib( char *library )
{
    opts.lib_file = library;		/* may be empty string */
}

static void option_use_lib( char *library )
{
    GetLibfile( library );
}

static void option_cpu_RCM2000( void )
{
    opts.cpu = CPU_RCM2000;
}

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/

static char *get_opts_ext_filename( char *filename, char *opts_ext )
{
    DEFINE_FILE_STR( ext );

    init();

    Str_set( ext, FILEEXT_SEPARATOR );
    Str_append( ext, opts_ext );
    return path_replace_ext( filename, ext->str );
}

char *get_lst_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_LST );
}

char *get_def_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_DEF );
}

char *get_err_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_ERR );
}

char *get_bin_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_BIN );
}

char *get_lib_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_LIB );
}

char *get_sym_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_SYM );
}

char *get_map_filename( char *filename )
{
    init();
	return path_replace_ext( filename, FILEEXT_MAP );
}

char *get_asm_filename( char *filename )
{
    return get_opts_ext_filename( filename, opts.asm_ext );
}

char *get_obj_filename( char *filename )
{
    return get_opts_ext_filename( filename, opts.obj_ext );
}
