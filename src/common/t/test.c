//-----------------------------------------------------------------------------
// z80asm unit tests
// Copyright (C) Paulo Custodio, 2011-20180
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"

void setUp() {}
void tearDown() {}

#define T(name) \
			extern void name(void); \
			RUN_TEST(name)

int main(int argc, char *argv[])
{
	UNITY_BEGIN();
	
	T(t_str_new);
	T(t_str_new_copy);
	T(t_str_clear);
	T(t_str_reserve);
	T(t_str_set);
	T(t_str_set_f);
	T(t_str_set_bin);
	T(t_str_set_str);
	T(t_str_append);
	T(t_str_append_f);
	T(t_str_append_bin);
	T(t_str_append_str);
	
	return UNITY_END();
}
