/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2021
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Handle assembly listing and symbol table listing.
*/

#include "codearea.h"
#include "if.h"
#include "listfile.h"
#include "options.h"
#include <stdio.h>

void got_source_line(const char* filename, int line_num, const char* text) {
	set_error_location(filename, line_num);
	set_error_source_line(text);

	// send line to list file
	if (filename && opts.cur_list) {
		list_source_line(filename, line_num,
			get_PC(), get_phased_PC() >= 0 ? get_phased_PC() : get_PC(),
			text);
	}
#ifdef LOG_INPUT
	printf("%s:%d:%s", filename, line_num, text);
#endif
}

void got_expanded_line(const char* filename, int line_num, const char* text) {
	set_error_expanded_line(text);

	// send line to list file
	if (filename && opts.cur_list && opts.verbose) {
		UT_string* line;
		utstring_new(line);
		utstring_printf(line, "      + %s", text);

		list_expanded_line(get_PC(), get_phased_PC() >= 0 ? get_phased_PC() : get_PC(),
			utstring_body(line));

		utstring_free(line);
	}
#ifdef LOG_INPUT
	printf("%s:%d:      + %s", filename, line_num, text);
#endif
}
