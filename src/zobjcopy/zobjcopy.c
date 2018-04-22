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
"     --add-prefix symbol-regexp,prefix  ; add prefix to all symbols that match\n"
;

#define OPT_SECTION			's'
#define OPT_ADD_PREFIX		'\1'

static struct optparse_long longopts[] = {
{ "verbose",	'v',				OPTPARSE_NONE },
{ "list",		'l',				OPTPARSE_NONE },
{ "section",	OPT_SECTION,		OPTPARSE_REQUIRED },
{ "add-prefix",	OPT_ADD_PREFIX,		OPTPARSE_REQUIRED },
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
	char *regexp, *name, *prefix, *p;

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
