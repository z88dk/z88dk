//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "strutil.h"
#include "unity.h"

void t_str_new(void)
{
	str_t *s = str_new();
	
	TEST_ASSERT_NOT_NULL(s);
	TEST_ASSERT_NOT_NULL(str_data(s));
	TEST_ASSERT_EQUAL('\0', *str_data(s));
	TEST_ASSERT_EQUAL(0, str_len(s));
	TEST_ASSERT_EQUAL_STRING("", str_data(s));
	
	str_free(s);
}

void t_str_new_copy(void)
{
	str_t *s = str_new_copy("hello");
	
	TEST_ASSERT_NOT_NULL(s);
	TEST_ASSERT_NOT_NULL(str_data(s));
	TEST_ASSERT_EQUAL(5, str_len(s));
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));
	
	str_free(s);
}

void t_str_clear(void)
{
	str_t *s = str_new_copy("hello");
	
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));
	
	str_clear(s);
	TEST_ASSERT_EQUAL_STRING("", str_data(s));
	
	str_free(s);
}

void t_str_reserve(void)
{
	const char *init = "1234567890123456789012345678901234567890"
					   "1234567890123456789012345678901234567890";
	size_t init_len = strlen(init);

	str_t *s = str_new_copy(init);
	str_reserve(s, 100);

	TEST_ASSERT_GREATER_OR_EQUAL(init_len + 100, s->n);

	str_free(s);
}

void t_str_set(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_set(s, "hello");
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	str_set(s, "world");
	TEST_ASSERT_EQUAL_STRING("world", str_data(s));

	str_free(s);
}

void t_str_set_f(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_set_f(s, "%s %d", "hello", 21);
	TEST_ASSERT_EQUAL_STRING("hello 21", str_data(s));

	str_set_f(s, "%s %d", "world", 42);
	TEST_ASSERT_EQUAL_STRING("world 42", str_data(s));

	str_free(s);
}

void t_str_set_bin(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_set_bin(s, "\0\1\2\3", 4);
	TEST_ASSERT_EQUAL(4, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\0\1\2\3\0", 5));

	str_set_bin(s, "\3\2\1\0", 4);
	TEST_ASSERT_EQUAL(4, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\3\2\1\0\0", 5));

	str_free(s);
}

void t_str_set_str(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_t *s1 = str_new_copy("hello");
	str_set_str(s, s1);
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	str_t *s2 = str_new_copy("world");
	str_set_str(s, s2);
	TEST_ASSERT_EQUAL_STRING("world", str_data(s));

	str_free(s);
	str_free(s1);
	str_free(s2);
}

void t_str_append(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_append(s, "hello");
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	str_append(s, "world");
	TEST_ASSERT_EQUAL_STRING("helloworld", str_data(s));

	str_free(s);
}

void t_str_append_f(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_append_f(s, "%s %d", "hello", 21);
	TEST_ASSERT_EQUAL_STRING("hello 21", str_data(s));

	str_append_f(s, "%s %d", "world", 42);
	TEST_ASSERT_EQUAL_STRING("hello 21world 42", str_data(s));

	str_free(s);
}

void t_str_append_bin(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_append_bin(s, "\0\1\2\3", 4);
	TEST_ASSERT_EQUAL(4, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\0\1\2\3\0", 5));

	str_append_bin(s, "\3\2\1\0", 4);
	TEST_ASSERT_EQUAL(8, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\0\1\2\3\3\2\1\0\0", 9));

	str_free(s);
}

void t_str_append_str(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_t *s1 = str_new_copy("hello");
	str_append_str(s, s1);
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	str_t *s2 = str_new_copy("world");
	str_append_str(s, s2);
	TEST_ASSERT_EQUAL_STRING("helloworld", str_data(s));

	str_free(s);
	str_free(s1);
	str_free(s2);
}
