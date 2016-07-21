//-----------------------------------------------------------------------------
// Main executable for z80asm
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include <limits.h>
#include "dprintf.hpp"
#include "messages.hpp"
#include "global.hpp"

int main(int argc, char *argv[])
{
	init_messages();
	init_global(argv[0]);

	if (argc <= 1) {
		g_messages.information(MES_COPYRIGHT);
		g_messages.plaintext("");
		g_messages.information(MES_USAGE);
	}
	else {
		std::string arg1 = argv[1];
		if (argc == 2 && (arg1 == "-h" || arg1 == "--help")) {
			g_messages.information(MES_COPYRIGHT);
			g_messages.plaintext("");
			g_messages.information(MES_USAGE);
			g_messages.plaintext("");
			g_messages.information(MES_HELP);
		}
		else {
			// TODO: parse command line
			g_errors.error(ERR_CMD_LINE_ARGS);
		}
	}

	return g_errors.error_count() == 0 ? 0 : 1;
}
