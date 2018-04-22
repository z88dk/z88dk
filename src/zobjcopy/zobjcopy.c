//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "zobjcopy.h"

// global variables
bool opt_verbose = false;
bool opt_list = false;

//-----------------------------------------------------------------------------
// Usage and command line options
//-----------------------------------------------------------------------------
static char usage[] =
//   x   x   x   x   x   x   x   x   x   x   x   x   x   x   x   x   x   x   x
"Usage: zobjcopy input [options] [output]\n"
"  -v|--verbose                          ; show what is going on\n"
"  -l|--list                             ; dump contents of file\n"
"  -s|--section old-regexp=new-name      ; rename all sections that match\n"
"  -p|--add-prefix symbol-regexp,prefix  ; add prefix to all symbols that match\n"
"  -y|--symbol old-name=new-name         ; rename global and extern symbols\n"
"  -L|--local regexp                     ; make symbols that match local\n"
"  -G|--global regexp                    ; make symbols that match global\n"
"  -F|--filler nn|0xhh                   ; use nn as filler for align\n"
;

#define OPT_SECTION			's'
#define OPT_ADD_PREFIX		'p'
#define OPT_SYMBOL			'y'
#define OPT_LOCAL			'L'
#define OPT_GLOBAL			'G'
#define OPT_FILLER			'F'

static struct optparse_long longopts[] = {
{ "verbose",	'v',				OPTPARSE_NONE },
{ "list",		'l',				OPTPARSE_NONE },
{ "section",	OPT_SECTION,		OPTPARSE_REQUIRED },
{ "add-prefix",	OPT_ADD_PREFIX,		OPTPARSE_REQUIRED },
{ "symbol",		OPT_SYMBOL,			OPTPARSE_REQUIRED },
{ "local",		OPT_LOCAL,			OPTPARSE_REQUIRED },
{ "global",		OPT_GLOBAL,			OPTPARSE_REQUIRED },
{ "filler",		OPT_FILLER,			OPTPARSE_REQUIRED },
{ 0,0,0 }
};

//-----------------------------------------------------------------------------
// Parse command line
//-----------------------------------------------------------------------------
int main(int argc, char *argv[])
{
	UT_array *commands;
	utarray_new(commands, &ut_str_icd);

	char *command = xstrdup("X");
	char *regexp, *old_name, *name, *prefix, *p;
	int val;

	// show usage
	if (argc < 2) {
		printf("%s", usage);
		exit(EXIT_SUCCESS);
	}

	// parse options
	struct optparse options;
	int option;

	optparse_init(&options, argv);
	while ((option = optparse_long(&options, longopts, NULL)) != -1) {
		switch (option) {
		case 'l': opt_list = true; break;
		case 'v': opt_verbose = true; break;
		case OPT_SECTION:
			*command = OPT_SECTION;
			utarray_push_back(commands, &command);

			p = strchr(options.optarg, '=');
			if (!p)
				die("error: no '=' in --section argument '%s'\n", options.optarg);

			regexp = options.optarg; *p = '\0';
			utarray_push_back(commands, &regexp);

			name = p + 1;
			utarray_push_back(commands, &name);
			break;
		case OPT_ADD_PREFIX: 
			*command = OPT_ADD_PREFIX;
			utarray_push_back(commands, &command);

			p = strchr(options.optarg, ',');
			if (!p)
				die("error: no ',' in --add-prefix argument '%s'\n", options.optarg);

			regexp = options.optarg; *p = '\0';
			utarray_push_back(commands, &regexp);

			prefix = p + 1;
			utarray_push_back(commands, &prefix);
			break;
		case OPT_SYMBOL:
			*command = OPT_SYMBOL;
			utarray_push_back(commands, &command);

			p = strchr(options.optarg, '=');
			if (!p)
				die("error: no '=' in --symbol argument '%s'\n", options.optarg);

			old_name = options.optarg; *p = '\0';
			utarray_push_back(commands, &old_name);

			name = p + 1;
			utarray_push_back(commands, &name);
			break;
		case OPT_LOCAL:
			*command = OPT_LOCAL;
			utarray_push_back(commands, &command);
			utarray_push_back(commands, &options.optarg);
			break;
		case OPT_GLOBAL:
			*command = OPT_GLOBAL;
			utarray_push_back(commands, &command);
			utarray_push_back(commands, &options.optarg);
			break;
		case OPT_FILLER:
			val = DEFAULT_ALIGN_FILLER;
			if (strncmp(options.optarg, "0x", 2) == 0)
				sscanf(options.optarg + 2, "%x", &val);
			else
				sscanf(options.optarg, "%d", &val);
			opt_obj_align_filler = val & 0xFF;
			if (opt_verbose)
				printf("Filler byte: $%02X\n", opt_obj_align_filler);
			break;
		case '?':
			die("error: %s\n", options.errmsg);
		default: assert(0);
		}
	}

	// collect input file
	char *infile = optparse_arg(&options);
	if (!infile)
		die("error: no input file\n");

	// collect output file
	char *outfile = optparse_arg(&options);
	if (opt_list && outfile)
		die("error: too many arguments\n");
	else if (!opt_list && !outfile)
		die("error: no output file\n");
	else
		;

	if (optparse_arg(&options) != NULL) 
		die("error: too many arguments\n");

	// read file
	file_t *file = file_new();
	file_read(file, infile);

	// execute commands
	while (utarray_len(commands) > 0) {
		char *command = *(char**)utarray_eltptr(commands, 0);
		switch (*command) {
		case OPT_SECTION:
			regexp = *(char**)utarray_eltptr(commands, 1);
			name = *(char**)utarray_eltptr(commands, 2);
			file_rename_sections(file, regexp, name);
			utarray_erase(commands, 0, 3);
			break;
		case OPT_ADD_PREFIX:
			regexp = *(char**)utarray_eltptr(commands, 1);
			prefix = *(char**)utarray_eltptr(commands, 2);
			file_add_symbol_prefix(file, regexp, prefix);
			utarray_erase(commands, 0, 3);
			break;
		case OPT_SYMBOL:
			old_name = *(char**)utarray_eltptr(commands, 1);
			name = *(char**)utarray_eltptr(commands, 2);
			file_rename_symbol(file, old_name, name);
			utarray_erase(commands, 0, 3);
			break;
		case OPT_LOCAL:
			regexp = *(char**)utarray_eltptr(commands, 1);
			file_make_symbols_local(file, regexp);
			utarray_erase(commands, 0, 2);
			break;
		case OPT_GLOBAL:
			regexp = *(char**)utarray_eltptr(commands, 1);
			file_make_symbols_global(file, regexp);
			utarray_erase(commands, 0, 2);
			break;
		default:
			assert(0);
		}
	}

	// write changed file
	if (!opt_list) {
		assert(outfile);
		file_write(file, outfile);
	}

	// release memory
	file_free(file);
	utarray_free(commands);
	xfree(command);
}
