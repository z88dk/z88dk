/*
 *	Library file snooper
 * 
 *	(C) 17/11/2002 Dominic Morris
 *
 *	Prints the contents of a z80asm library file including local symbols
 *	and dependencies of a particular library
 */

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include "objfile.h"

void usage(char *name)
{
	die("Usage %s [-a][-l][-e][-c] library\n"
		"Display the contents of a z80asm library file\n"
		"\n"
		"-a\tShow all\n"
		"-l\tShow local symbols\n"
		"-e\tShow expression patches\n"
		"-c\tShow code dump\n",
		name);
}

int main(int argc, char *argv[])
{
	opt_obj_list = true;
	opt_obj_hide_local = true;
	opt_obj_hide_expr = true;
	opt_obj_hide_code = true;

	int 	opt;
	while ((opt = getopt(argc, argv, "leca")) != -1) {
		switch (opt) {
		case 'l': opt_obj_hide_local = false; break;
		case 'e': opt_obj_hide_expr = false; break;
		case 'c': opt_obj_hide_code = false; break;
		case 'a': opt_obj_hide_local = opt_obj_hide_expr = opt_obj_hide_code = false; break;
		default:
			usage(argv[0]);
			return 0;
		}
	}

	if ( optind == argc ) 
		usage(argv[0]);

	while (optind < argc) {
		char *filename = argv[optind++];
		file_t *file = file_new();
		file_read(file, filename);
		file_free(file);
	}
}
