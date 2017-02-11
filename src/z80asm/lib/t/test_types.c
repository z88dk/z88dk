/*
Z88DK Z80 Macro Assembler

Unit test for types.h

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include "types.h"

static int test_types(void)
{
	Byte byte_var;
	Bool bool_var;
	int  nums[10];
	
	/* byte */
	mu_assert_int( sizeof(byte_var), ==, 1 );
	byte_var = 255;
	mu_assert_int( (int)byte_var, ==, 255 );
	byte_var++;
	mu_assert_int( (int)byte_var, ==, 0 );
	byte_var--;
	mu_assert_int( (int)byte_var, ==, 255 );
	
	/* bool */
	bool_var = FALSE;
	mu_assert_int( !!bool_var, ==, !!0 );
	bool_var = TRUE;
	mu_assert_int( !!bool_var, ==, !!1 );
	
	/* min, max, abs, clamp, num_elems */
	mu_assert_int( MIN(1, 0), ==, 0 );
	mu_assert_int( MIN(1, 1), ==, 1 );
	mu_assert_int( MIN(1, 2), ==, 1 );
	
	mu_assert_int( MAX(1, 0), ==, 1 );
	mu_assert_int( MAX(1, 1), ==, 1 );
	mu_assert_int( MAX(1, 2), ==, 2 );
	
	mu_assert_int( ABS(-1), ==, 1 );
	mu_assert_int( ABS( 0), ==, 0 );
	mu_assert_int( ABS( 1), ==, 1 );
	
	mu_assert_int( CLAMP( 1, 2, 4 ), ==, 2 );
	mu_assert_int( CLAMP( 2, 2, 4 ), ==, 2 );
	mu_assert_int( CLAMP( 3, 2, 4 ), ==, 3 );
	mu_assert_int( CLAMP( 4, 2, 4 ), ==, 4 );
	mu_assert_int( CLAMP( 5, 2, 4 ), ==, 4 );
	
	mu_assert_int( NUM_ELEMS( nums ), ==, 10 );
	
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
