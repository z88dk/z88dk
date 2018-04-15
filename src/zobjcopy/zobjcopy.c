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
"  -v|--verbose                      ; show what is going on\n"
"  -l|--list                         ; dump contents of file\n"
"  -s|--section old-regexp=new-name  ; rename all sections that match\n"
;

static struct optparse_long longopts[] = {
{ "verbose",	'v', OPTPARSE_NONE },
{ "list",		'l', OPTPARSE_NONE },
{ "section",	's', OPTPARSE_REQUIRED },
{ 0,0,0 }
};

//-----------------------------------------------------------------------------
// Parse command line
//-----------------------------------------------------------------------------
int main(int argc, char *argv[])
{
	UT_array *rename_section_args;
	char *old_regexp, *new_name, *p;

	utarray_new(rename_section_args, &ut_str_icd);

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
		case 's': 
			p = strchr(options.optarg, '=');
			if (!p)
				die("error: no '=' in --section argument '%s'\n", options.optarg);
			old_regexp = options.optarg; *p = '\0';
			utarray_push_back(rename_section_args, &old_regexp);

			new_name = p + 1;
			utarray_push_back(rename_section_args, &new_name);
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

	// rename sections
	while (utarray_len(rename_section_args) >= 2) {
		old_regexp = *(char**)utarray_eltptr(rename_section_args, 0);
		new_name = *(char**)utarray_eltptr(rename_section_args, 1);

		file_rename_sections(file, old_regexp, new_name);

		utarray_erase(rename_section_args, 0, 2);
	}

	// write changed file
	if (!opt_list) {
		assert(outfile);
		file_write(file, outfile);
	}

	// release memory
	file_free(file);
	utarray_free(rename_section_args);
}
