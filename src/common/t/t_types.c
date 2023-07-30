//-----------------------------------------------------------------------------
// types - common types and macros
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "types.h"
#include <limits.h>

void t_types_bool(void)
{
	/* bool */
	bool v = false;
	TEST_ASSERT(!v);
	v = !v;
	TEST_ASSERT(v);

	v = true;
	TEST_ASSERT(v);
	v = !v;
	TEST_ASSERT(!v);
}

void t_types_byte(void)
{
	byte_t v;

	TEST_ASSERT_EQUAL(1, sizeof(v));
	v = 255; 
	v++;
	TEST_ASSERT_EQUAL(0, v);
	v--;
	TEST_ASSERT_EQUAL(255, v);
}

void t_types_word(void)
{
	word_t v;

	TEST_ASSERT_EQUAL(2, sizeof(v));
	v = 65535;
	v++;
	TEST_ASSERT_EQUAL(0, v);
	v--;
	TEST_ASSERT_EQUAL(65535, v);
}

void t_types_uint(void)
{
	uint_t v;

	TEST_ASSERT_EQUAL(sizeof(int), sizeof(v));
	v = UINT_MAX;
	v++;
	TEST_ASSERT_EQUAL(0, v);
	v--;
	TEST_ASSERT_EQUAL(UINT_MAX, v);
}

void t_types_min(void)
{
	TEST_ASSERT_EQUAL(0, MIN(1, 0));
	TEST_ASSERT_EQUAL(1, MIN(1, 1));
	TEST_ASSERT_EQUAL(1, MIN(1, 2));
}

void t_types_max(void)
{
	TEST_ASSERT_EQUAL(1, MAX(1, 0));
	TEST_ASSERT_EQUAL(1, MAX(1, 1));
	TEST_ASSERT_EQUAL(2, MAX(1, 2));
}

void t_types_abs(void)
{
	TEST_ASSERT_EQUAL(1, ABS(-1));
	TEST_ASSERT_EQUAL(0, ABS(0));
	TEST_ASSERT_EQUAL(1, ABS(1));
}

void t_types_clamp(void)
{
	TEST_ASSERT_EQUAL(2, CLAMP(1, 2, 4));
	TEST_ASSERT_EQUAL(2, CLAMP(2, 2, 4));
	TEST_ASSERT_EQUAL(3, CLAMP(3, 2, 4));
	TEST_ASSERT_EQUAL(4, CLAMP(4, 2, 4));
	TEST_ASSERT_EQUAL(4, CLAMP(5, 2, 4));
}

void t_types_num_elems(void)
{
	int nums[10];

	TEST_ASSERT_EQUAL(10, NUM_ELEMS(nums));
}
