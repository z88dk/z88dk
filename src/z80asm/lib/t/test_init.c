/*
Z88DK Z80 Macro Assembler

Unit test for init.h

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include "init.h"

DEFINE_init_module()
{
	warn("init called\n");
}

DEFINE_dtor_module()
{
	warn("fini called\n");
}

static int test_init(void)
{
	warn("before init\n");
	init_module();
	warn("after init\n");
	init_module();
	warn("end\n");

	return MU_PASS;
}
	
	
int main(int argc, char *argv[])
{
	mu_init(argc, argv);
    mu_run_test(MU_PASS, test_init);
	mu_fini();
}
