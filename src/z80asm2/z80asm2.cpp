//-----------------------------------------------------------------------------
// Main executable for z80asm
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include "messages.hpp"
#include "cmdline.hpp"

int main(int argc, char *argv[])
{
	init_messages();
	init_global(argv[0]);

	if (parse_cmdline(argc, argv, g_args)) {
		if (g_args.is_verbose)
			g_messages.information(MES_COPYRIGHT);

		// TODO: parse command line
		for (unsigned i = 0; i < g_args.files.size(); i++) {
			if (g_args.is_verbose)
				g_messages.information(MES_PARSING_FILE, g_args.files[i]);
		}
	}

	return g_errors.error_count() == 0 ? 0 : 1;
}
