//-----------------------------------------------------------------------------
// Main executable for z80asm
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include <limits.h>

#include "dprintf.hpp"
#include "global.hpp"

// show copyright and 1..N USAGE_xx lines
static void usage(int max_usage_lines = INT_MAX)
{
	g_messages.information("COPYRIGHT");
	g_messages.plaintext("");

	bool done = false;
	int mes_nr = 0;
	while (!done && mes_nr < max_usage_lines) {
		try {
			g_messages.information(stlplus::dformat("USAGE_%02d", ++mes_nr));
		}
		catch (stlplus::message_handler_id_error&) {
			done = true;
		}
	}
}

int main(int argc, char *argv[])
{
	// TODO: compute message file name based on arv[0]
	g_messages.add_message_file("z80asm2.mes");
	g_errors.add_message_file("z80asm2.mes");

	if (argc <= 1)
		usage(1);
	else {
		std::string arg1 = argv[1];
		if (argc == 2 && (arg1 == "-h" || arg1 == "--help"))
			usage();
		else {
			// TODO: parse command line
			g_errors.error("ERR_CMD_LINE_ARGS");
		}
	}

	return g_errors.error_count() == 0 ? 0 : 1;
}
