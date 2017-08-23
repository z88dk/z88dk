/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Parse command line options
*/

#include "errors.h"
#include "fileutil.h"
#include "hist.h"
#include "init.h"
#include "model.h"
#include "options.h"
#include "srcfile.h"
#include "strpool.h"
#include "str.h"
#include "symtab.h"
#include "utarray.h"
#include "z80asm.h"
#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <string.h>

/* default file name extensions */
#define FILEEXT_ASM     ".asm"    
#define FILEEXT_LIST    ".lis"    
#define FILEEXT_OBJ     ".o"	  
#define FILEEXT_DEF     ".def"    
#define FILEEXT_ERR     ".err"    
#define FILEEXT_BIN     ".bin"    
#define FILEEXT_LIB     ".lib"    
#define FILEEXT_SYM     ".sym"    
#define FILEEXT_MAP     ".map"    
#define FILEEXT_RELOC   ".reloc"  

/* types */
enum OptType
{
    OptSet,
    OptCall, OptCallArg, 
    OptString, OptStringList,
};

/* declare functions */
static void exit_help( void );
static void exit_copyright( void );
static void option_origin( char *origin );
static void option_define( char *symbol );
static void option_make_lib( char *library );
static void option_use_lib( char *library );
static void option_cpu_z80(void);
static void option_cpu_z80_zxn(void);
static void option_cpu_z180(void);
static void option_cpu_r2k(void);
static void option_cpu_r3k(void);
static void option_appmake_zx(void);
static void option_appmake_zx81(void);
static void option_filler( char *filler_arg );

static void process_options( int *parg, int argc, char *argv[] );
static void process_files( int arg, int argc, char *argv[] );

static char *expand_environment_variables(char *arg);
static char *replace_str(const char *str, const char *old, const char *new);

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
DEFINE_init_module()
{
	utarray_new(opts.inc_path, &ut_str_icd);
	utarray_new(opts.lib_path, &ut_str_icd);
	utarray_new(opts.files, &ut_str_icd);
}

DEFINE_dtor_module()
{
	utarray_free(opts.inc_path);
	utarray_free(opts.lib_path);
	utarray_free(opts.files);
}

/*-----------------------------------------------------------------------------
*   Parse command line, set options, including opts.files with list of
*	input files, including parsing of '@' lists
*----------------------------------------------------------------------------*/
void parse_argv( int argc, char *argv[] )
{
    int arg;

    init_module();

    if ( argc == 1 )
        exit_copyright();				/* exit if no arguments */

    process_options( &arg, argc, argv );	/* process all options, set arg to next */

    if ( arg >= argc )
        error_no_src_file();			/* no source file */

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
#define II (*parg)
    int		 j;
    char	*opt_arg_ptr;

    /* search opts_lu[] */
    for ( j = 0; j < NUM_ELEMS( opts_lu ); j++ )
    {
        if ( ( opt_arg_ptr = check_option( argv[II], opts_lu[j].long_opt ) ) != NULL ||
                ( opt_arg_ptr = check_option( argv[II], opts_lu[j].short_opt ) ) != NULL )
        {
            /* found option, opt_arg_ptr points to after option */
            switch ( opts_lu[j].type )
            {
            case OptSet:
                if ( *opt_arg_ptr )
                    error_illegal_option( argv[II] );
                else
                    *( ( Bool * )( opts_lu[j].arg ) ) = TRUE;

                break;

            case OptCall:
                if ( *opt_arg_ptr )
                    error_illegal_option( argv[II] );
                else
                    ( ( void ( * )( void ) )( opts_lu[j].arg ) )();

                break;

            case OptCallArg:
				if (*opt_arg_ptr) {
					opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
					((void(*)(char *))(opts_lu[j].arg))(opt_arg_ptr);
				}
                else
                    error_illegal_option( argv[II] );

                break;

            case OptString:
				if (*opt_arg_ptr) {
					opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
                    *( ( char ** )( opts_lu[j].arg ) ) = opt_arg_ptr;
				}
                else
                    error_illegal_option( argv[II] );

                break;

            case OptStringList:
				if (*opt_arg_ptr)
				{
					UT_array **p_path = (UT_array **)opts_lu[j].arg;
					opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
					utarray_push_back(*p_path, &opt_arg_ptr);
				}
                else
                    error_illegal_option( argv[II] );

                break;

            default:
                assert(0);
            }

            return;
        }
    }

    /* not found */
    error_illegal_option( argv[II] );

#undef II
}

static void process_options( int *parg, int argc, char *argv[] )
{
#define II (*parg)

    for ( II = 1; II < argc && (argv[II][0] == '-' || argv[II][0] == '+'); II++ )
        process_opt( &II, argc, argv );

#undef II
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
	case '+':
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
			if (src_open(filename, NULL))
			{
				while ((line = src_getline()) != NULL)
					process_file(line);
			}
		}
		src_pop();
		break;
	case ';':     /* comment */
	case '#':
		break;
	default:
		filename = expand_environment_variables(filename);
		utarray_push_back(opts.files, &filename);
    }
}

/*-----------------------------------------------------------------------------
*   replace environment variables in filenames
*----------------------------------------------------------------------------*/

static char *expand_environment_variables(char *arg)
{
	char  *ptr, *nval = NULL;
	char  *rep, *start;
	char  *value = strdup(arg);
	char   varname[300];
	char  *ret;

	start = value;
	while ((ptr = strchr(start, '$')) != NULL) 
	{
		if (*(ptr + 1) == '{') 
		{
			char  *end = strchr(ptr + 1, '}');

			if (end != NULL) {
				snprintf(varname, sizeof(varname), "%.*s", (int)(end - ptr - 2), ptr + 2);
				rep = getenv(varname);
				if (rep == NULL) 
				{
					rep = "";
				}

				snprintf(varname, sizeof(varname), "%.*s", (int)(end - ptr + 1), ptr);
				nval = replace_str(value, varname, rep);
				free(value);
				value = nval;
				start = value + (ptr - start);
			}
		}
		else 
		{
			start++;
		}
	}

	ret = strpool_add(value);		// free memory, return pooled string
	free(value);
	return ret;
}

/* From: http://creativeandcritical.net/str-replace-c/ */
static char *replace_str(const char *str, const char *old, const char *new)
{
	char *ret, *r;
	const char *p, *q;
	size_t oldlen = strlen(old);
	size_t count, retlen, newlen = strlen(new);

	if (oldlen != newlen) 
	{
		for (count = 0, p = str; (q = strstr(p, old)) != NULL; p = q + oldlen)
			count++;
		/* this is undefined if p - str > PTRDIFF_MAX */
		retlen = p - str + strlen(p) + count * (newlen - oldlen);
	}
	else
		retlen = strlen(str);

	ret = malloc(retlen + 1);

	for (r = ret, p = str; (q = strstr(p, old)) != NULL; p = q + oldlen) 
	{
		/* this is undefined if q - p > PTRDIFF_MAX */
		ptrdiff_t l = q - p;
		memcpy(r, p, l);
		r += l;
		memcpy(r, new, newlen);
		r += newlen;
	}
	strcpy(r, p);

	return ret;
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
	STR_DEFINE(msg, STR_SIZE);
    int count_opts = 0;

    str_set( msg, "  " );

    if ( *short_opt )
    {
        /* dont show short_opt if short_opt is same as long_opt, except for extra '-' */
        if ( !( *long_opt && strcmp( short_opt, long_opt + 1 ) == 0 ) )
        {
            str_append_sprintf( msg, "%s", short_opt );
            count_opts++;
        }
    }

    if ( *long_opt )
    {
        if ( count_opts )
            str_append( msg, ", " );

        str_append_sprintf( msg, "%s", long_opt );
        count_opts++;
    }

    if ( *help_arg )
    {
        str_append_sprintf( msg, "=%s", help_arg );
    }

    if ( str_len(msg) > ALIGN_HELP )
        printf( "%s\n%-*s %s\n", str_data(msg), ALIGN_HELP, "",       help_text );
    else
        printf( "%-*s %s\n",                    ALIGN_HELP, str_data(msg), help_text );

	STR_DELETE(msg);
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
	printf("  To assemble 'fred%s' use 'fred' or 'fred%s'\n", FILEEXT_ASM, FILEEXT_ASM);
    puts( "" );
    puts( "  <modulefile> contains list of file names of all modules to be linked," );
    puts( "  one module per line." );
    puts( "" );
    puts( "  File types recognized or created by z80asm:" );
	printf("    %-6s = source file\n", FILEEXT_ASM);
	printf("    %-6s = object file\n", FILEEXT_OBJ);
    printf( "    %-6s = list file\n", FILEEXT_LIST );
    printf( "    %-6s = Z80 binary file\n", FILEEXT_BIN );
    printf( "    %-6s = symbols file\n", FILEEXT_SYM );
    printf( "    %-6s = map file\n", FILEEXT_MAP );
	printf( "    %-6s = reloc file\n", FILEEXT_RELOC);
	printf( "    %-6s = global address definition file\n", FILEEXT_DEF);
    printf( "    %-6s = error file\n", FILEEXT_ERR );

#include "options_def.h"

    exit( 0 );
}

static void exit_copyright( void )
{
    printf( "%s\n", copyrightmsg );
    exit( 0 );
}

/*-----------------------------------------------------------------------------
*   Option functions called from Opts table
*----------------------------------------------------------------------------*/
int number_arg(char *arg)
{
	char *end;
	char *p = arg;
	long lval;
	int radix;
	char suffix = '\0';
	
	if (p[0] == '$') {
		p++;
		radix = 16;
	}
	else if (p[0] == '0' && tolower(p[1]) == 'x') {
		p += 2;
		radix = 16;
	}
	else if (isdigit(p[0]) && tolower(p[strlen(p)-1]) == 'h') {
		suffix = p[strlen(p) - 1];
		radix = 16;
	}
	else {
		radix = 10;
	}

	lval = strtol(p, &end, radix);
	if (*end != suffix || errno == ERANGE || lval < 0 || lval > INT_MAX)
		return -1;
	else
		return (int)lval;
}

static void option_origin( char *origin )
{
	int value = number_arg(origin);
	if (value < 0 || value > 0xFFFF)
		error_invalid_org_option(origin);
	else
		set_origin_option(value);
}

static void option_filler( char *filler_arg )
{
	int value = number_arg(filler_arg);
	if (value < 0 || value > 0xFF)
		error_invalid_filler_option(filler_arg);
	else
		opts.filler = value;
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

static void option_cpu_z80(void)
{
	opts.cpu = CPU_Z80;
}

static void option_cpu_z80_zxn(void)
{
	opts.cpu = CPU_Z80_ZXN;
}

static void option_cpu_z180(void)
{
	opts.cpu = CPU_Z180;
}

static void option_cpu_r2k(void)
{
    opts.cpu = CPU_R2K;
}

static void option_cpu_r3k(void)
{
	opts.cpu = CPU_R3K;
}

void define_assembly_defines()
{
	switch (opts.cpu) {
	case CPU_Z80:
	    define_static_def_sym("__CPU_Z80__", 1);
		break;
	case CPU_Z80_ZXN:
	    define_static_def_sym("__CPU_Z80_ZXN__", 1);
		break;
	case CPU_Z180:
	    define_static_def_sym("__CPU_Z180__", 1);
		break;
	case CPU_R2K:
	    define_static_def_sym("__CPU_R2K__", 1);
		break;
	case CPU_R3K:
	    define_static_def_sym("__CPU_R3K__", 1);
		break;
	default:
		assert(0);
	}
}

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/

char *get_list_filename( char *filename )
{
    init_module();
	return path_replace_ext( filename, FILEEXT_LIST );
}

char *get_def_filename( char *filename )
{
    init_module();
	return path_replace_ext( filename, FILEEXT_DEF );
}

char *get_err_filename( char *filename )
{
    init_module();
	return path_replace_ext( filename, FILEEXT_ERR );
}

char *get_bin_filename( char *filename )
{
    init_module();
	return path_replace_ext( filename, FILEEXT_BIN );
}

char *get_lib_filename( char *filename )
{
    init_module();
	return path_replace_ext( filename, FILEEXT_LIB );
}

char *get_sym_filename( char *filename )
{
    init_module();
	return path_replace_ext( filename, FILEEXT_SYM );
}

char *get_map_filename(char *filename)
{
	init_module();
	return path_replace_ext(filename, FILEEXT_MAP);
}

char *get_reloc_filename(char *filename)
{
	init_module();
	return path_replace_ext(filename, FILEEXT_RELOC);
}

char *get_asm_filename(char *filename)
{
	return path_replace_ext(filename, FILEEXT_ASM);
}

char *get_obj_filename( char *filename )
{
    return path_replace_ext( filename, FILEEXT_OBJ);
}

/*-----------------------------------------------------------------------------
*   Appmake options
*	+zx without ORG - sets org at 25760, in a REM statement
*	+zx with ORG - uses that org
*----------------------------------------------------------------------------*/
static void option_appmake_zx(void)
{
	opts.appmake = APPMAKE_ZX;
	opts.appmake_opts = "+zx";
	opts.appmake_ext = ZX_APP_EXT;
	opts.appmake_origin_min = ZX_ORIGIN_MIN;
	opts.appmake_origin_max = ZX_ORIGIN_MAX;
	set_origin_option(ZX_ORIGIN);
	opts.make_bin = TRUE;
}

static void option_appmake_zx81(void)
{
	opts.appmake = APPMAKE_ZX81;
	opts.appmake_opts = "+zx81";
	opts.appmake_ext = ZX81_APP_EXT;
	opts.appmake_origin_min = ZX81_ORIGIN_MIN;
	opts.appmake_origin_max = ZX81_ORIGIN_MAX;
	set_origin_option(ZX81_ORIGIN);
	opts.make_bin = TRUE;
}

void checkrun_appmake(void)
{
	STR_DEFINE(cmd, STR_SIZE);

	if (opts.appmake) {
		Section *first_section = get_first_section(NULL);
		int origin = first_section->origin;
		if (origin < opts.appmake_origin_min || origin > opts.appmake_origin_max) {
			error_invalid_org(origin);
		}
		else {
			char *bin_filename = get_bin_filename(get_first_module(NULL)->filename);
			char *out_filename = path_replace_ext(bin_filename, opts.appmake_ext);

			str_sprintf(cmd, "appmake %s -b \"%s\" -o \"%s\" --org %d",
				opts.appmake_opts,
				bin_filename,
				out_filename,
				origin);

			if (opts.verbose)
				puts(str_data(cmd));

			int rv = system(str_data(cmd));
			if (rv != 0)
				error_cmd_failed(str_data(cmd));
		}
	}
}
