/*
Unit test for init.h

Copyright (C) Paulo Custodio, 2011-2015

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/test_init.c,v 1.3 2015-02-09 21:57:46 pauloscustodio Exp $
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
