/*
Z88DK Z80 Macro Assembler

Unit test for alloc.c

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include "strpool.h"
#include <assert.h>
#include <stdio.h>

#define NUM_STRINGS 1000
#define STRING_SIZE	5

struct strings
{
	char  source[STRING_SIZE];
	char *pool;
}
strings[NUM_STRINGS];

int test_strpool(void)
{
	char *pool, *pool2;
	int i;

	/* first run - create pool for all strings */
	for (i = 0; i < NUM_STRINGS; i++)
	{
		sprintf(strings[i].source, "%d", i);		/* number i */

		pool = strpool_exists(strings[i].source);
		mu_assert_ptr_null(pool);

		pool = strpool_add(strings[i].source);
		mu_assert_ptr(pool);
		mu_assert(pool != strings[i].source, "wrong pool");
		mu_assert_str(pool, == , strings[i].source);

		strings[i].pool = pool;
	}

	/* second run - check that pool did not move */
	for (i = 0; i < NUM_STRINGS; i++) 
	{
		pool = strpool_exists(strings[i].source);
		mu_assert_ptr(pool);
		mu_assert(pool != strings[i].source, "wrong pool");
		mu_assert_str(pool, == , strings[i].source);
		mu_assert(pool == strings[i].pool, "wrong pool");

		pool2 = strpool_add(strings[i].source);
		mu_assert(pool == pool2, "wrong pool");
	}

	/* check NULL case */
	pool = strpool_exists(NULL);
	mu_assert_ptr_null(pool);

	pool = strpool_add(NULL);
	mu_assert_ptr_null(pool);

	return MU_PASS;
}

int main(int argc, char *argv[])
{
	mu_init(argc, argv);
	mu_run_test(MU_PASS, test_strpool);
	mu_fini();
}
