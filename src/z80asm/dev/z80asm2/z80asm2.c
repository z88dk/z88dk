//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "frontend.h"

int main(int argc, char* argv[]) {
	if (argc != 2) {
		fputs("Expected source file", stderr);
		exit(EXIT_FAILURE);
	}
	else {
		if (!assemble_file(argv[1])) exit(EXIT_FAILURE);
	}
}
