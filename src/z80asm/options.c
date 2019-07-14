//-----------------------------------------------------------------------------
// Z88DK Z80 Module Assembler
// Parse command line options
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../config.h"
#include "../portability.h"

#include "errors.h"
#include "fileutil.h"
#include "hist.h"
#include "init.h"
#include "model.h"
#include "options.h"
#include "srcfile.h"
#include "str.h"
#include "strutil.h"
#include "symtab.h"
#include "utarray.h"
#include "z80asm.h"
#include "die.h"

#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <string.h>

#ifdef _MSC_VER
#define snprintf _snprintf
#endif

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
static void option_origin(const char *origin );
static void option_define(const char *symbol );
static void option_make_lib(const char *library );
static void option_use_lib(const char *library );
static void option_cpu_z80(void);
static void option_cpu_z80n(void);
static void option_cpu_z180(void);
static void option_cpu_r2k(void);
static void option_cpu_r3k(void);
static void option_cpu_ti83(void);
static void option_cpu_ti83plus(void);
static void option_appmake_zx(void);
static void option_appmake_zx81(void);
static void option_filler(const char *filler_arg );
static void option_debug_info();
static void define_assembly_defines();
static void include_z80asm_lib();
static const char *search_z80asm_lib();
static void make_output_dir();

static void process_options( int *parg, int argc, char *argv[] );
static void process_files( int arg, int argc, char *argv[] );
static void expand_source_glob(const char *pattern);
static void expand_list_glob(const char *filename);

static const char *expand_environment_variables(const char *arg);
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
	opts.inc_path = argv_new();
	opts.lib_path = argv_new();
	opts.files = argv_new();
}

DEFINE_dtor_module()
{
	argv_free(opts.inc_path);
	argv_free(opts.lib_path);
	argv_free(opts.files);
}

/*-----------------------------------------------------------------------------
*   Parse command line, set options, including opts.files with list of
*	input files, including parsing of '@' lists
*----------------------------------------------------------------------------*/
static void process_env_options()
{
	const char *opts = getenv("Z80ASM");
	if (!opts)
		return;

	// add dummy program name option
	argv_t* args = argv_new();
	argv_push(args, "z80asm");

	char *opts_copy = xstrdup(opts);		// strtok needs writeable string
	char *tok = strtok(opts_copy, " ");
	while (tok) {
		argv_push(args, tok);
		tok = strtok(NULL, " ");
	}

	// parse args
	int argc = argv_len(args);
	int arg;
	process_options(&arg, argc, argv_front(args));

	xfree(opts_copy);
	argv_free(args);
}

void parse_argv( int argc, char *argv[] )
{
    int arg;

    init_module();

    if ( argc == 1 )
        exit_copyright();					/* exit if no arguments */

	if (!get_num_errors())
		process_env_options();				/* process options from Z80ASM environment variable */

	if (!get_num_errors())
		process_options( &arg, argc, argv );/* process all options, set arg to next */

	if (!get_num_errors() && arg >= argc)
		error_no_src_file();				/* no source file */

	if ( ! get_num_errors() )
        process_files( arg, argc, argv );	/* process each source file */

	make_output_dir();						/* create output directory if needed */
	include_z80asm_lib();					/* search for z80asm-*.lib, append to library path */
	define_assembly_defines();				/* defined options-dependent constants */
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
	const char *opt_arg_ptr;

	/* search options that are exceptions to the look-up table */
	if (strcmp(argv[II], "-mz80n") == 0 || strcmp(argv[II], "-m=z80n") == 0) {
		option_cpu_z80n();
		return;
	}
	else if (strcmp(argv[II], "-mz80") == 0 || strcmp(argv[II], "-m=z80") == 0) {
		option_cpu_z80();
		return;
	}
	else if (strcmp(argv[II], "-mz180") == 0 || strcmp(argv[II], "-m=z180") == 0) {
		option_cpu_z180();
		return;
	}
	else if(strcmp(argv[II], "-mr2k") == 0 || strcmp(argv[II], "-m=r2k") == 0) {
		option_cpu_r2k();
		return;
	}
	else if(strcmp(argv[II], "-mr3k") == 0 || strcmp(argv[II], "-m=r3k") == 0) {
		option_cpu_r3k();
		return;
	}
	else if (strcmp(argv[II], "-mti83") == 0 || strcmp(argv[II], "-m=ti83") == 0) {
		option_cpu_ti83();
		return;
	}
	else if (strcmp(argv[II], "-mti83plus") == 0 || strcmp(argv[II], "-m=ti83plus") == 0) {
		option_cpu_ti83plus();
		return;
	}
	else {
		/* search opts_lu[] */
		for (j = 0; j < NUM_ELEMS(opts_lu); j++)
		{
			if ((opt_arg_ptr = check_option(argv[II], opts_lu[j].long_opt)) != NULL ||
				(opt_arg_ptr = check_option(argv[II], opts_lu[j].short_opt)) != NULL)
			{
				/* found option, opt_arg_ptr points to after option */
				switch (opts_lu[j].type)
				{
				case OptSet:
					if (*opt_arg_ptr)
						error_illegal_option(argv[II]);
					else
						*((bool *)(opts_lu[j].arg)) = true;

					break;

				case OptCall:
					if (*opt_arg_ptr)
						error_illegal_option(argv[II]);
					else
						((void(*)(void))(opts_lu[j].arg))();

					break;

				case OptCallArg:
					if (*opt_arg_ptr) {
						opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
						((void(*)(const char *))(opts_lu[j].arg))(opt_arg_ptr);
					}
					else
						error_illegal_option(argv[II]);

					break;

				case OptString:
					if (*opt_arg_ptr) {
						opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
						*((const char **)(opts_lu[j].arg)) = opt_arg_ptr;
					}
					else
						error_illegal_option(argv[II]);

					break;

				case OptStringList:
					if (*opt_arg_ptr)
					{
						UT_array **p_path = (UT_array **)opts_lu[j].arg;
						opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
						argv_push(*p_path, opt_arg_ptr);
					}
					else
						error_illegal_option(argv[II]);

					break;

				default:
					xassert(0);
				}

				return;
			}
		}

		/* not found */
		error_illegal_option(argv[II]);

	}

#undef II
}

static void process_options( int *parg, int argc, char *argv[] )
{
#define II (*parg)
	for (II = 1; II < argc && (argv[II][0] == '-' || argv[II][0] == '+'); II++) {
		if (strcmp(argv[II], "--") == 0) {
			// end of options
			II++;
			break;
		}
		else {
			process_opt(&II, argc, argv);
		}
	}
#undef II
}

/*-----------------------------------------------------------------------------
*   process a file
*----------------------------------------------------------------------------*/

/* search for the first file in path, with the given extension,
* with .asm extension and with .o extension
* if not found, return original file */
static const char *search_source(const char *filename)
{
	const char *f;

	if (file_exists(filename))
		return filename;

	f = path_search(filename, opts.inc_path);
	if (file_exists(f))
		return f;

	f = get_asm_filename(filename);
	if (file_exists(f))
		return f;

	f = path_search(f, opts.inc_path);
	if (file_exists(f))
		return f;

	f = get_obj_filename(filename);
	if (file_exists(f))
		return f;

	f = path_search(f, opts.inc_path);
	if (file_exists(f))
		return f;

	error_read_file(filename);
	return filename;
}

static void process_file(char *filename )
{
	cstr_strip(filename);
	switch (filename[0])
	{
	case '\0':		/* no file */
		break;

	case '@':		/* file list */
		filename++;						/* point to after '@' */
		cstr_strip(filename);
		filename = (char *)expand_environment_variables(filename);
		expand_list_glob(filename);
		break;
	case ';':     /* comment */
	case '#':
		break;
	default:
		filename = (char *)expand_environment_variables(filename);
		expand_source_glob(filename);
	}
}

void expand_source_glob(const char *pattern)
{
	if (strpbrk(pattern, "*?") != NULL) {		// is a pattern
		argv_t *files = path_find_glob(pattern);

		if (argv_len(files) == 0)
			error_glob_no_files(pattern);		// error if pattern matched no file

		for (char **p = argv_front(files); *p; p++) {
			argv_push(opts.files, search_source(*p));
		}

		argv_free(files);
	}
	else {
		argv_push(opts.files, search_source(pattern));
	}
}

void expand_list_glob(const char *filename)
{
	if (strpbrk(filename, "*?") != NULL) {		// is a pattern
		argv_t *files = path_find_glob(filename);

		if (argv_len(files) == 0)
			error_glob_no_files(filename);		// error if pattern matched no file

		for (char **p = argv_front(files); *p; p++) {
			char *filename = *p;
			src_push();
			{
				char *line;

				// append the directoy of the list file to the include path	and remove it at the end
				argv_push(opts.inc_path, path_dir(filename));

				if (src_open(filename, NULL)) {
					while ((line = src_getline()) != NULL)
						process_file(line);
				}

				// finished assembly, remove dirname from include path
				argv_pop(opts.inc_path);
			}
			src_pop();
		}
		argv_free(files);
	}
	else {
		src_push();
		{
			char *line;

			// append the directoy of the list file to the include path	and remove it at the end
			argv_push(opts.inc_path, path_dir(filename));

			if (src_open(filename, NULL)) {
				while ((line = src_getline()) != NULL)
					process_file(line);
			}

			// finished assembly, remove dirname from include path
			argv_pop(opts.inc_path);
		}
		src_pop();
	}
}

/*-----------------------------------------------------------------------------
*   replace environment variables in filenames
*----------------------------------------------------------------------------*/

static const char *expand_environment_variables(const char *arg)
{
	char  *ptr, *nval = NULL;
	char  *rep, *start;
	char  *value = strdup(arg);
	char   varname[300];
	const char  *ret;

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

	ret = spool_add(value);		// free memory, return pooled string
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
							show_option(type, (bool *)arg, \
										short_opt, long_opt, help_text, help_arg);

#define ALIGN_HELP	24

static void show_option( enum OptType type, bool *pflag,
                         char *short_opt, char *long_opt, char *help_text, char *help_arg )
{
	STR_DEFINE(msg, STR_SIZE);
    int count_opts = 0;

    Str_set( msg, "  " );

    if ( *short_opt )
    {
        /* dont show short_opt if short_opt is same as long_opt, except for extra '-' */
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

    if ( Str_len(msg) > ALIGN_HELP )
        printf( "%s\n%-*s %s\n", Str_data(msg), ALIGN_HELP, "",       help_text );
    else
        printf( "%-*s %s\n",                    ALIGN_HELP, Str_data(msg), help_text );

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
int number_arg(const char *arg)
{
	char *end;
	const char *p = arg;
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

static void option_origin(const char *origin )
{
	int value = number_arg(origin);
	if (value < 0 || value > 0xFFFF)
		error_invalid_org_option(origin);
	else
		set_origin_option(value);
}

static void option_filler(const char *filler_arg )
{
	int value = number_arg(filler_arg);
	if (value < 0 || value > 0xFF)
		error_invalid_filler_option(filler_arg);
	else
		opts.filler = value;
}

static void option_debug_info()
{
	opts.debug_info = true;
	opts.map = true;
}

static void option_define(const char *symbol )
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

static void option_make_lib(const char *library )
{
    opts.lib_file = library;		/* may be empty string */
}

static void option_use_lib(const char *library )
{
    GetLibfile( library );
}

static void option_cpu_z80(void)
{
	opts.cpu = CPU_Z80;
	opts.cpu_name = CPU_Z80_NAME;
}

static void option_cpu_z80n(void)
{
	opts.cpu = CPU_Z80N;
	opts.cpu_name = CPU_Z80N_NAME;
}

static void option_cpu_z180(void)
{
	opts.cpu = CPU_Z180;
	opts.cpu_name = CPU_Z180_NAME;
}

static void option_cpu_r2k(void)
{
	opts.cpu = CPU_R2K;
	opts.cpu_name = CPU_R2K_NAME;
}

static void option_cpu_r3k(void)
{
	opts.cpu = CPU_R3K;
	opts.cpu_name = CPU_R3K_NAME;
}

static void option_cpu_ti83(void)
{
	option_cpu_z80();
	opts.ti83plus = false;
}

static void option_cpu_ti83plus(void)
{
	option_cpu_z80();
	opts.ti83plus = true;
}

static void define_assembly_defines()
{
	switch (opts.cpu) {
	case CPU_Z80:
	    define_static_def_sym("__CPU_Z80__", 1);
		break;
	case CPU_Z80N:
	    define_static_def_sym("__CPU_Z80N__", 1);
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
		xassert(0);
	}

	if (opts.swap_ix_iy) {
		define_static_def_sym("__SWAP_IX_IY__", 1);
	}
}

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/
static const char *path_prepend_output_dir(const char *filename)
{
	char path[FILENAME_MAX];
	if (opts.output_directory) {
		if (isalpha(filename[0]) && filename[1] == ':')	// it's a win32 absolute path
			snprintf(path, sizeof(path), "%s/%c/%s", 
				opts.output_directory, filename[0], filename + 2);
		else
			snprintf(path, sizeof(path), "%s/%s", 
				opts.output_directory, filename);
		return spool_add(path);
	}
	else {
		return filename;
	}
}

const char *get_list_filename(const char *filename )
{
    init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_LIST));
}

const char *get_def_filename(const char *filename )
{
    init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_DEF));
}

const char *get_err_filename(const char *filename )
{
    init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_ERR));
}

const char *get_bin_filename(const char *filename )
{
    init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_BIN));
}

const char *get_lib_filename(const char *filename )
{
    init_module();
	return path_replace_ext(filename, FILEEXT_LIB);
}

const char *get_sym_filename(const char *filename )
{
    init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_SYM));
}

const char *get_map_filename(const char *filename)
{
	init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_MAP));
}

const char *get_reloc_filename(const char *filename)
{
	init_module();
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_RELOC));
}

const char *get_asm_filename(const char *filename)
{
	return path_replace_ext(filename, FILEEXT_ASM);
}

const char *get_obj_filename(const char *filename )
{
	return path_prepend_output_dir(path_replace_ext(filename, FILEEXT_OBJ));
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
	opts.make_bin = true;
}

static void option_appmake_zx81(void)
{
	opts.appmake = APPMAKE_ZX81;
	opts.appmake_opts = "+zx81";
	opts.appmake_ext = ZX81_APP_EXT;
	opts.appmake_origin_min = ZX81_ORIGIN_MIN;
	opts.appmake_origin_max = ZX81_ORIGIN_MAX;
	set_origin_option(ZX81_ORIGIN);
	opts.make_bin = true;
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
			const char *bin_filename = get_bin_filename(get_first_module(NULL)->filename);
			const char *out_filename = path_replace_ext(bin_filename, opts.appmake_ext);

			Str_sprintf(cmd, "appmake %s -b \"%s\" -o \"%s\" --org %d",
				opts.appmake_opts,
				bin_filename,
				out_filename,
				origin);

			if (opts.verbose)
				puts(Str_data(cmd));

			int rv = system(Str_data(cmd));
			if (rv != 0)
				error_cmd_failed(Str_data(cmd));
		}
	}
}

/*-----------------------------------------------------------------------------
*   z80asm standard library
*	search in current die, then in exe path, then in exe path/../lib, then in ZCCCFG/..
*	Ignore if not found, probably benign - user will see undefined symbols
*	__z80asm__xxx if the library routines are called
*----------------------------------------------------------------------------*/
static void include_z80asm_lib()
{
	const char *library = search_z80asm_lib();

	if (library != NULL)
		option_use_lib(library);
}

static const char *check_library(const char *lib_name)
{
	if (file_exists(lib_name))
		return lib_name;
	
	if (opts.verbose)
		printf("Library '%s' not found\n", path_canon(lib_name));

	return NULL;
}

static const char *search_z80asm_lib()
{
	STR_DEFINE(lib_name_str, STR_SIZE);
	const char *lib_name;
	STR_DEFINE(f, STR_SIZE);
	const char *ret;

	/* Build libary file name */
	Str_sprintf(lib_name_str, Z80ASM_LIB, opts.cpu_name, SWAP_IX_IY_NAME);
	lib_name = spool_add(Str_data(lib_name_str));

	/* try to read from current directory */
	if (check_library(lib_name))
		return lib_name;

	/* try to read from PREFIX/lib */
	Str_sprintf(f, "%s/lib/%s", PREFIX, lib_name);
	ret = spool_add(Str_data(f));
	if (check_library(ret))
		return ret;

	/* try to read form -L path */
	ret = path_search(get_lib_filename(lib_name), opts.lib_path);
	if (strcmp(ret, lib_name) != 0) {		// found one in path
		if (check_library(ret))
			return ret;
	}

	/* try to read from ZCCCFG/.. */
	Str_sprintf(f, "${ZCCCFG}/../%s", lib_name);
	ret = expand_environment_variables(Str_data(f));
	if (check_library(ret))
		return ret;

	return NULL;		/* not found */
}

/*-----------------------------------------------------------------------------
*   output directory
*----------------------------------------------------------------------------*/
static void make_output_dir()
{
	if (opts.output_directory) {
		opts.output_directory = path_canon(opts.output_directory);
		path_mkdir(opts.output_directory);
	}
}
