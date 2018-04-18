//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "zobjcopy.h"

// global variables
bool opt_verbose;
bool opt_list;

//-----------------------------------------------------------------------------
// Usage and command line options
//-----------------------------------------------------------------------------
static char usage[] =
	"Usage: zobjcopy [options] input [output]\n"
	"  -v|--verbose          show what is going on\n"
	"  -l|--list             dump contents of file\n"
;

static struct optparse_long longopts[] = {
	{ "verbose",	'v', OPTPARSE_NONE },
	{ "list",		'l', OPTPARSE_NONE },
	{ 0,0,0 }
};

//-----------------------------------------------------------------------------
// Do the object file copy
//-----------------------------------------------------------------------------
static void objcopy(char *infile, char *outfile)
{
	file_t *in = file_new();
	file_read(in, infile);

	if (!opt_list) {
		assert(outfile);
		file_write(in, outfile);
	}

	file_free(in);
}

//-----------------------------------------------------------------------------
// Parse command line
//-----------------------------------------------------------------------------
int main(int argc, char *argv[])
{
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
		case '?':
			die("error: %s\n", options.errmsg);
		default: assert(0);
		}
	}

	// collect file names
	char *infile = optparse_arg(&options);
	if (!infile)
		die("error: no input file\n");

	char *outfile = optparse_arg(&options);
	if (opt_list && outfile)
		die("error: too many arguments\n");
	else if (!opt_list && !outfile)
		die("error: no output file\n");
	else
		;

	if (optparse_arg(&options) != NULL) 
		die("error: too many arguments\n");

	objcopy(infile, outfile);
}
