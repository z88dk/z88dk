/*
Z88DK Z80 Macro Assembler

Unit test for ztypes.h

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include "ztypes.h"

static int test_types(void)
{
	mu_assert_int( MAXLINE, >=, 256 );
	mu_assert_int( MAXLINE, >=, FILENAME_MAX );
	
	return MU_PASS;
}

int main(int argc, char *argv[])
{
	mu_init(argc, argv);
    mu_run_test(MU_PASS, test_types);
	mu_fini();
}
