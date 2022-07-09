//-----------------------------------------------------------------------------
// Z88DK Z80 Macro Assembler
// Parse command line options
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../config.h"
#include "../portability.h"
#include "die.h"
#include "fileutil.h"
#include "hist.h"
#include "if.h"
#include "init.h"
#include "modlink.h"
#include "options.h"
#include "str.h"
#include "strutil.h"
#include "symtab.h"
#include "utarray.h"
#include "utstring.h"
#include "z80asm.h"
#include "zutils.h"
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <string.h>

/* default file name extensions */
#define FILEEXT_ASM     ".asm"    
#define FILEEXT_LIST    ".lis"    
#define FILEEXT_OBJ     ".o"	  
#define FILEEXT_DEF     ".def"    
#define FILEEXT_BIN     ".bin"    
#define FILEEXT_LIB     ".lib"    
#define FILEEXT_SYM     ".sym"    
#define FILEEXT_MAP     ".map"    
#define FILEEXT_RELOC   ".reloc"  

#define BL ' '

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
static void option_dummy(void);
static void option_origin(const char *origin );
static void option_define(const char *symbol );
static void option_make_lib(const char *library );
static void option_use_lib(const char *library );
static void option_cpu_z80(void);
static void option_cpu_z80n(void);
static void option_cpu_z180(void);
static void option_cpu_gbz80(void);
static void option_cpu_8080(void);
static void option_cpu_8085(void);
static void option_cpu_r2ka(void);
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

static void process_option(const char* option);
static void process_file(const char* filename_);
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

//-----------------------------------------------------------------------------
//	parse arguments from argv[], Z80ASM environment or @ files
//-----------------------------------------------------------------------------
static const char* delim_string(const char** ptext, char delim) {
	const char* p = *ptext;

	if (delim != BL && *p == delim) {	// skip start quotes
		p++;
		*ptext = p;
	}

	while (*p != '\0') {	// scan for end delimiter
		char c = *p;
		if (isspace(c))
			c = BL;
		if (c == delim)
			break;
		p++;
	}

	const char* ret = spool_add_n(*ptext, p - *ptext);

	if (*p != '\0' && delim != BL)		// skip end quote
		p++;

	*ptext = p;
	return ret;
}

static void parse_args_in_text(const char* text) {
	const char* p = text;

	while (*p != '\0') {
		if (isspace(*p)) {				// skip blanks
			while (isspace(*p))
				p++;
		}
		else {
			switch (*p) {
			case ';':					// comment
			case '#':
				return;
			case '-':					// option
			case '+':
				process_option(delim_string(&p, BL));
				break;
			case '"':
				process_file(delim_string(&p, '"'));
				break;
			case '\'':
				process_file(delim_string(&p, '\''));
				break;
			case '@':
			default:
				process_file(delim_string(&p, BL));
				break;
			}
		}
	}
}

static void parse_args(int argc, char* argv[]) {
	bool got_dash_dash = false;

	for (int i = 1; i < argc; i++) {		// parse options and files
		if (0 == strcmp(argv[i], "--")) {
			got_dash_dash = true;
		}
		else {
			if ((argv[i][0] == '-' || argv[i][0] == '+') && !got_dash_dash)
				process_option(argv[i]);
			else
				process_file(argv[i]);
		}

		if (get_num_errors())
			break;
	}
}

/*-----------------------------------------------------------------------------
*   Parse command line, set options, including opts.files with list of
*	input files, including parsing of '@' lists
*----------------------------------------------------------------------------*/
static void process_env_options() {
	const char *options = getenv("Z80ASM");
	if (options)
		parse_args_in_text(options);
}

void parse_argv(int argc, char* argv[]) {
	init_module();

	if (argc == 1)
		exit_copyright();					// exit if no arguments

	if (get_num_errors())
		return;

	process_env_options();					// process options from Z80ASM environment variable

	if (get_num_errors())
		return;

	parse_args(argc, argv);					// parse options and files

	if (get_num_errors())
		return;

	if (argv_len(opts.files) == 0)
		error_no_src_file();				// no source file

	if (get_num_errors())
		return;

	make_output_dir();						// create output directory if needed
	include_z80asm_lib();					// search for z88dk-z80asm-*.lib, append to library path
	define_assembly_defines();				// defined options-dependent constants
}

/*-----------------------------------------------------------------------------
*   process all options
*----------------------------------------------------------------------------*/
/* check if this option is matched, return char pointer after option, ready
   to retrieve an argument, if any */
static const char* check_option(const char* arg, const char* opt) {
	size_t len = strlen(opt);

	if (*opt &&					// ignore empty option strings
		strncmp(arg, opt, len) == 0)
	{
		if (arg[len] == '=')
			len++;				// skip '=' after option, to point at argument

		return arg + len;		// point to after argument
	}
	else
		return NULL;			// not found
}

static void process_option(const char* option)
{
    int		 j;
	const char *opt_arg_ptr;

	/* search options that are exceptions to the look-up table */
	if (strcmp(option, "-mz80n") == 0 || strcmp(option, "-m=z80n") == 0) {
		option_cpu_z80n();
		return;
	}
	else if (strcmp(option, "-mz80") == 0 || strcmp(option, "-m=z80") == 0) {
		option_cpu_z80();
		return;
	}
	else if (strcmp(option, "-mgbz80") == 0 || strcmp(option, "-m=gbz80") == 0) {
		option_cpu_gbz80();
		return;
	}
	else if (strcmp(option, "-m8080") == 0 || strcmp(option, "-m=8080") == 0) {
		option_cpu_8080();
		return;
	}
	else if (strcmp(option, "-m8085") == 0 || strcmp(option, "-m=8085") == 0) {
		option_cpu_8085();
		return;
	}
	else if (strcmp(option, "-mz180") == 0 || strcmp(option, "-m=z180") == 0) {
		option_cpu_z180();
		return;
	}
	else if(strcmp(option, "-mr2ka") == 0 || strcmp(option, "-m=r2ka") == 0) {
		option_cpu_r2ka();
		return;
	}
	else if(strcmp(option, "-mr3k") == 0 || strcmp(option, "-m=r3k") == 0) {
		option_cpu_r3k();
		return;
	}
	else if (strcmp(option, "-mti83") == 0 || strcmp(option, "-m=ti83") == 0) {
		option_cpu_ti83();
		return;
	}
	else if (strcmp(option, "-mti83plus") == 0 || strcmp(option, "-m=ti83plus") == 0) {
		option_cpu_ti83plus();
		return;
	}
	else if (strncmp(option, "-l", 2) == 0 && option[2] != '\0') {
		library_file_append(option + 2);
		return;
	}
	else if (strcmp(option, "-l") == 0) {
		opts.list = true;
		return;
	}
	else if (strcmp(option, "-reloc-info") == 0) {
		opts.reloc_info = true;
		return;
	}
	else if (strncmp(option, "-float", 6) == 0) {
		const char* format = option + 6;
		if (*format == '=') format++;
		if (!set_float_format(format))
			error_invalid_float_format();
	}
	else {
		/* search opts_lu[] */
		for (j = 0; j < NUM_ELEMS(opts_lu); j++)
		{
			if ((opt_arg_ptr = check_option(option, opts_lu[j].long_opt)) != NULL ||
				(opt_arg_ptr = check_option(option, opts_lu[j].short_opt)) != NULL)
			{
				/* found option, opt_arg_ptr points to after option */
				switch (opts_lu[j].type)
				{
				case OptSet:
					if (*opt_arg_ptr)
						error_illegal_option(option);
					else
						*((bool *)(opts_lu[j].arg)) = true;

					break;

				case OptCall:
					if (*opt_arg_ptr)
						error_illegal_option(option);
					else
						((void(*)(void))(opts_lu[j].arg))();

					break;

				case OptCallArg:
					if (*opt_arg_ptr) {
						opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
						((void(*)(const char *))(opts_lu[j].arg))(opt_arg_ptr);
					}
					else
						error_illegal_option(option);

					break;

				case OptString:
					if (*opt_arg_ptr) {
						opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
						*((const char **)(opts_lu[j].arg)) = opt_arg_ptr;
					}
					else
						error_illegal_option(option);

					break;

				case OptStringList:
					if (*opt_arg_ptr)
					{
						UT_array **p_path = (UT_array **)opts_lu[j].arg;
						opt_arg_ptr = expand_environment_variables(opt_arg_ptr);
						argv_push(*p_path, opt_arg_ptr);
					}
					else
						error_illegal_option(option);

					break;

				default:
					xassert(0);
				}

				return;
			}
		}

		/* not found */
		error_illegal_option(option);

	}
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

	// test plain filename
	if (file_exists(filename))
		return filename;

	f = path_search(filename, opts.inc_path);
	if (file_exists(f))
		return f;

	// test filename - extension + ".asm"
	f = get_asm_filename(filename);
	if (file_exists(f))
		return f;

	f = path_search(f, opts.inc_path);
	if (file_exists(f))
		return f;

	// test filename - extension + ".o"
	f = get_obj_filename(filename);
	if (file_exists(f))
		return f;

	f = path_search(f, opts.inc_path);
	if (file_exists(f))
		return f;

	// not found
	error_file_open(filename);
	return filename;
}

static void process_file(const char *filename_ )
{
	char* filename_copy = xstrdup(filename_);
	char* filename = filename_copy;
	{
		strstrip(filename);
		switch (filename[0])
		{
		case '\0':		/* no file */
			break;

		case '@':		/* file list */
			filename++;						/* point to after '@' */
			strstrip(filename);
			filename = (char*)expand_environment_variables(filename);
			expand_list_glob(filename);
			break;
		case ';':     /* comment */
		case '#':
			break;
		default:
			filename = (char*)expand_environment_variables(filename);
			expand_source_glob(filename);
		}
	}
	xfree(filename_copy);
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

void expand_list_glob(const char* filename)
{
	if (strpbrk(filename, "*?") != NULL) {		// is a pattern
		argv_t* files = path_find_glob(filename);

		if (argv_len(files) == 0)
			error_glob_no_files(filename);		// error if pattern matched no file

		for (char** p = argv_front(files); *p; p++) {
			char* filename = *p;

			// append the directoy of the list file to the include path	and remove it at the end
			argv_push(opts.inc_path, path_dir(filename));

			if (sfile_open(filename, false)) {
				char* line;
				while ((line = sfile_getline()) != NULL) {
					parse_args_in_text(line);
					xfree(line);
				}
			}

			// finished assembly, remove dirname from include path
			argv_pop(opts.inc_path);
		}
		argv_free(files);
	}
	else {
		// append the directoy of the list file to the include path	and remove it at the end
		argv_push(opts.inc_path, path_dir(filename));

		if (sfile_open(filename, false)) {
			char* line;
			while ((line = sfile_getline()) != NULL) {
				parse_args_in_text(line);
				xfree(line);
			}
		}

		// finished assembly, remove dirname from include path
		argv_pop(opts.inc_path);
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
        Str_append_sprintf( msg, "%s", help_arg );
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
	
	if (p[0] == '\0') {		// empty
		return -1;
	}
	else if (p[0] == '$') {
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

static void option_dummy(void) {}

static void option_origin(const char * origin_text)
{
	int value = number_arg(origin_text);
	if (value < 0)		// value can be >0xffff for banked address
		error_invalid_org_option(origin_text);
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
	if (!isalpha(symbol[0]) && symbol[0] != '_') {
		error_illegal_ident();
		return;
	}

	for (i = 1; symbol[i] != 0 && symbol[i] != '='; i++) {
		if (!isalnum(symbol[i]) && symbol[i] != '_') {
			error_illegal_ident();
			return;
		}
	}

	if (symbol[i] != '=') {		// -Dvar
		define_static_def_sym(symbol, 1);
	}
	else {						// -Dvar=nn
		char* variable = xstrdup(symbol);
		variable[i] = '\0';		// truncate after variable name
		int value = number_arg(symbol + i + 1);
		if (value < 0)
			error_invalid_define_option(symbol);
		else
			define_static_def_sym(variable, value);
		xfree(variable);
	}
}

static void option_make_lib(const char *library )
{
    opts.lib_file = library;		/* may be empty string */
}

static void option_use_lib(const char *library) {
	library_file_append(library);
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

static void option_cpu_gbz80(void)
{
	opts.cpu = CPU_GBZ80;
	opts.cpu_name = CPU_GBZ80_NAME;
}

static void option_cpu_8080(void)
{
	opts.cpu = CPU_8080;
	opts.cpu_name = CPU_8080_NAME;
}

static void option_cpu_8085(void)
{
	opts.cpu = CPU_8085;
	opts.cpu_name = CPU_8085_NAME;
}

static void option_cpu_z180(void)
{
	opts.cpu = CPU_Z180;
	opts.cpu_name = CPU_Z180_NAME;
}

static void option_cpu_r2ka(void)
{
	opts.cpu = CPU_R2KA;
	opts.cpu_name = CPU_R2KA_NAME;
}

static void option_cpu_r3k(void)
{
	opts.cpu = CPU_R3K;
	opts.cpu_name = CPU_R3K_NAME;
}

static void option_cpu_ti83(void)
{
	option_cpu_z80();
	opts.ti83 = true;
	opts.ti83plus = false;
}

static void option_cpu_ti83plus(void)
{
	option_cpu_z80();
	opts.ti83 = false;
	opts.ti83plus = true;
}

static void define_assembly_defines()
{
	switch (opts.cpu) {
	case CPU_Z80:
	    define_static_def_sym("__CPU_Z80__", 1);
	    define_static_def_sym("__CPU_ZILOG__", 1);
		break;
	case CPU_Z80N:
	    define_static_def_sym("__CPU_Z80N__", 1);
	    define_static_def_sym("__CPU_ZILOG__", 1);
		break;
	case CPU_Z180:
	    define_static_def_sym("__CPU_Z180__", 1);
	    define_static_def_sym("__CPU_ZILOG__", 1);
		break;
	case CPU_R2KA:
	    define_static_def_sym("__CPU_R2KA__", 1);
	    define_static_def_sym("__CPU_RABBIT__", 1);
		break;
	case CPU_R3K:
	    define_static_def_sym("__CPU_R3K__", 1);
	    define_static_def_sym("__CPU_RABBIT__", 1);
		break;
	case CPU_8080:
	    define_static_def_sym("__CPU_8080__", 1);
	    define_static_def_sym("__CPU_INTEL__", 1);
		break;
	case CPU_8085:
	    define_static_def_sym("__CPU_8085__", 1);
	    define_static_def_sym("__CPU_INTEL__", 1);
		break;
	case CPU_GBZ80:
		define_static_def_sym("__CPU_GBZ80__", 1);
		break;
	default:
		xassert(0);
	}

	if (opts.swap_ix_iy) {
		define_static_def_sym("__SWAP_IX_IY__", 1);
	}

	if (opts.ti83) {
		define_static_def_sym("__CPU_TI83__", 1);
	}
	else if (opts.ti83plus) {
		define_static_def_sym("__CPU_TI83PLUS__", 1);
	}

	// __FLOAT__xxx__
	define_static_def_sym(get_float_format_define(), 1);
}

/*-----------------------------------------------------------------------------
*   Change extension of given file name, return pointer to file name in
*	strpool
*	Extensions may be changed by options.
*----------------------------------------------------------------------------*/
const char *path_prepend_output_dir(const char *filename)
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

// argument is binary file, already has the output_dir prepended
const char *get_reloc_filename(const char *filename)
{
	init_module();
	return path_replace_ext(filename, FILEEXT_RELOC);
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

			Str_sprintf(cmd, "z88dk-appmake %s -b \"%s\" -o \"%s\" --org %d",
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

bool option_ucase() {
	return opts.ucase;
}

bool option_list_file() {
	return opts.list;
}

bool option_cur_list() {
	return opts.cur_list;
}

bool option_single_binary_block() {
	return opts.relocatable || opts.appmake;
}

bool option_verbose() {
	return opts.verbose;
}

const char* search_includes(const char* filename) {
	const char* filename_path = path_search(filename, opts.inc_path);
	return filename_path;
}
