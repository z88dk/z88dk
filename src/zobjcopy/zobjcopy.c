//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "zobjcopy.h"

// global variables
opts_t opts;
global_t global;

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
		case 'l': opts.list = true; break;
		case 'v': opts.verbose = true; break;
		case '?':
			fprintf(stderr, "error: %s\n", options.errmsg);
			exit(EXIT_FAILURE);
		default: assert(0);
		}
	}

	// collect file names
	char *infile = optparse_arg(&options);
	if (!infile) {
		fprintf(stderr, "error: no input file\n");
		exit(EXIT_FAILURE);
	}

	// may be NULL
	char *outfile = optparse_arg(&options);

	if (optparse_arg(&options)!=NULL) {
		fprintf(stderr, "error: too many arguments\n");
		exit(EXIT_FAILURE);
	}

	objcopy(infile, outfile);
}
