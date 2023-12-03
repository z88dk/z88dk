//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "strutil.h"
#include "unity.h"
#include "utstring.h"

void t_strutil_cstr_toupper(void)
{
	char buff[10];
	strcpy(buff, "abc1"); TEST_ASSERT_EQUAL_STRING("ABC1", strtoupper(buff));
	strcpy(buff, "Abc1"); TEST_ASSERT_EQUAL_STRING("ABC1", strtoupper(buff));
	strcpy(buff, "ABC1"); TEST_ASSERT_EQUAL_STRING("ABC1", strtoupper(buff));
}

void t_strutil_cstr_tolower(void)
{
	char buff[10];
	strcpy(buff, "abc1"); TEST_ASSERT_EQUAL_STRING("abc1", strtolower(buff));
	strcpy(buff, "Abc1"); TEST_ASSERT_EQUAL_STRING("abc1", strtolower(buff));
	strcpy(buff, "ABC1"); TEST_ASSERT_EQUAL_STRING("abc1", strtolower(buff));
}

void t_strutil_cstr_chomp(void)
{
	char buff[100];
	strcpy(buff, ""); TEST_ASSERT_EQUAL_STRING("", strchomp(buff));
	strcpy(buff, "\r\n \t\f \r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("", strchomp(buff));
	strcpy(buff, "\r\n \t\fx\r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("\r\n \t\fx", strchomp(buff));
}

void t_strutil_cstr_strip(void)
{
	char buff[100];
	strcpy(buff, ""); TEST_ASSERT_EQUAL_STRING("", strstrip(buff));
	strcpy(buff, "\r\n \t\f \r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("", strstrip(buff));
	strcpy(buff, "\r\n \t\fx\r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("x", strstrip(buff));
}

void t_strutil_cstr_strip_compress_escapes(void)
{
    UT_string* s;
    utstring_new(s);
	char cs[100];

#define T(in, out_len, out_str) \
			strcpy(cs, in); \
			TEST_ASSERT_EQUAL(out_len, str_compress_escapes(cs)); \
			TEST_ASSERT_EQUAL(0, memcmp(cs, out_str, out_len)); \
            utstring_clear(s)

	// trailing backslash ignored 
	T("\\", 0, "");

	// escape any 
	T("\\" "?" "\\" "\"" "\\" "'",
		3, "?\"'");

	// escape chars 
	T("0" "\\a"
		"1" "\\b"
		"2" "\\e"
		"3" "\\f"
		"4" "\\n"
		"5" "\\r"
		"6" "\\t"
		"7" "\\v"
		"8",
		17,
		"0" "\a"
		"1" "\b"
		"2" "\x1B"
		"3" "\f"
		"4" "\n"
		"5" "\r"
		"6" "\t"
		"7" "\v"
		"8");

	// octal and hexadecimal, including '\0' 
	for (int i = 0; i < 256; i++)
	{
		sprintf(cs, "\\%o \\x%x", i, i);
		int len = (int)str_compress_escapes(cs);
		TEST_ASSERT_EQUAL(3, len);
		TEST_ASSERT_EQUAL((char)i, cs[0]);
		TEST_ASSERT_EQUAL(' ', cs[1]);
		TEST_ASSERT_EQUAL((char)i, cs[2]);
		TEST_ASSERT_EQUAL(0, cs[3]);
	}

	// octal and hexadecimal with longer digit string 
	T("\\3770\\xff0",
		4,
		"\xFF" "0" "\xFF" "0");

	utstring_free(s);
#undef T
}

void t_strutil_cstr_case_cmp(void)
{
	TEST_ASSERT(strcasecmp("", "") == 0);
	TEST_ASSERT(strcasecmp("a", "") > 0);
	TEST_ASSERT(strcasecmp("", "a") < 0);
	TEST_ASSERT(strcasecmp("a", "a") == 0);
	TEST_ASSERT(strcasecmp("a", "A") == 0);
	TEST_ASSERT(strcasecmp("A", "a") == 0);
	TEST_ASSERT(strcasecmp("ab", "a") > 0);
	TEST_ASSERT(strcasecmp("a", "ab") < 0);
	TEST_ASSERT(strcasecmp("ab", "ab") == 0);
}

void t_strutil_cstr_case_ncmp(void)
{
	TEST_ASSERT(strncasecmp("", "", 0) == 0);
	TEST_ASSERT(strncasecmp("x", "y", 0) == 0);
	TEST_ASSERT(strncasecmp("a", "", 1) > 0);
	TEST_ASSERT(strncasecmp("", "a", 1) < 0);
	TEST_ASSERT(strncasecmp("ax", "ay", 1) == 0);
	TEST_ASSERT(strncasecmp("ax", "Ay", 1) == 0);
	TEST_ASSERT(strncasecmp("Ax", "ay", 1) == 0);
	TEST_ASSERT(strncasecmp("abx", "a", 2) > 0);
	TEST_ASSERT(strncasecmp("a", "aby", 2) < 0);
	TEST_ASSERT(strncasecmp("abx", "aby", 2) == 0);
}

void t_strutil_argv_new(void)
{
	argv_t *argv = argv_new();
	TEST_ASSERT_EQUAL(0, argv_len(argv));
	TEST_ASSERT_NULL(*argv_front(argv));
	TEST_ASSERT_NULL(*argv_back(argv));
	TEST_ASSERT(argv_front(argv) == argv_back(argv));

	argv_push(argv, "1");
	argv_push(argv, "2");
	argv_push(argv, "3");
	TEST_ASSERT_EQUAL(3, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[2]);
	TEST_ASSERT_NULL((argv_front(argv))[3]);
	TEST_ASSERT(argv_front(argv) + 3 == argv_back(argv));

	argv_unshift(argv, "0");
	argv_unshift(argv, "-1");
	argv_unshift(argv, "-2");
	TEST_ASSERT_EQUAL(6, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("-2", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("-1", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[5]);
	TEST_ASSERT_NULL((argv_front(argv))[6]);
	TEST_ASSERT(argv_front(argv) + 6 == argv_back(argv));

	argv_insert(argv, 3, "0.5");
	TEST_ASSERT_EQUAL(7, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("-2", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("-1", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("0.5", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[6]);
	TEST_ASSERT_NULL((argv_front(argv))[7]);
	TEST_ASSERT(argv_front(argv) + 7 == argv_back(argv));

	argv_insert(argv, 6, "2.5");
	TEST_ASSERT_EQUAL(8, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("-2", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("-1", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("0.5", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("2.5", (argv_front(argv))[6]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[7]);
	TEST_ASSERT_NULL((argv_front(argv))[8]);
	TEST_ASSERT(argv_front(argv) + 8 == argv_back(argv));

	argv_insert(argv, 8, "3.5");
	TEST_ASSERT_EQUAL(9, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("-2", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("-1", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("0.5", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("2.5", (argv_front(argv))[6]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[7]);
	TEST_ASSERT_EQUAL_STRING("3.5", (argv_front(argv))[8]);
	TEST_ASSERT_NULL((argv_front(argv))[9]);
	TEST_ASSERT(argv_front(argv) + 9 == argv_back(argv));

	argv_insert(argv, 10, "4");
	TEST_ASSERT_EQUAL(11, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("-2", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("-1", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("0.5", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("2.5", (argv_front(argv))[6]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[7]);
	TEST_ASSERT_EQUAL_STRING("3.5", (argv_front(argv))[8]);
	TEST_ASSERT_NULL((argv_front(argv))[9]);
	TEST_ASSERT_EQUAL_STRING("4", (argv_front(argv))[10]);
	TEST_ASSERT_NULL((argv_front(argv))[11]);
	TEST_ASSERT(argv_front(argv) + 11 == argv_back(argv));

	argv_erase(argv, 9, 10);
	TEST_ASSERT_EQUAL(9, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("-2", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("-1", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("0.5", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("2.5", (argv_front(argv))[6]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[7]);
	TEST_ASSERT_EQUAL_STRING("3.5", (argv_front(argv))[8]);
	TEST_ASSERT_NULL((argv_front(argv))[9]);
	TEST_ASSERT(argv_front(argv) + 9 == argv_back(argv));

	argv_erase(argv, 0, 2);
	TEST_ASSERT_EQUAL(7, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("0.5", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("2.5", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("3.5", (argv_front(argv))[6]);
	TEST_ASSERT_NULL((argv_front(argv))[7]);
	TEST_ASSERT(argv_front(argv) + 7 == argv_back(argv));

	argv_set(argv, 1, "0,5");
	TEST_ASSERT_EQUAL(7, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("0", (argv_front(argv))[0]);
	TEST_ASSERT_EQUAL_STRING("0,5", (argv_front(argv))[1]);
	TEST_ASSERT_EQUAL_STRING("1", (argv_front(argv))[2]);
	TEST_ASSERT_EQUAL_STRING("2", (argv_front(argv))[3]);
	TEST_ASSERT_EQUAL_STRING("2.5", (argv_front(argv))[4]);
	TEST_ASSERT_EQUAL_STRING("3", (argv_front(argv))[5]);
	TEST_ASSERT_EQUAL_STRING("3.5", (argv_front(argv))[6]);
	TEST_ASSERT_NULL((argv_front(argv))[7]);
	TEST_ASSERT(argv_front(argv) + 7 == argv_back(argv));

	char **p = argv_front(argv);
	TEST_ASSERT_EQUAL_STRING("0", *p); p++;
	TEST_ASSERT_EQUAL_STRING("0,5", *p); p++;
	TEST_ASSERT_EQUAL_STRING("1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("2.5", *p); p++;
	TEST_ASSERT_EQUAL_STRING("3", *p); p++;
	TEST_ASSERT_EQUAL_STRING("3.5", *p); p++;
	TEST_ASSERT_NULL(*p);

	TEST_ASSERT_EQUAL(7, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("0", argv_get(argv, 0));
	TEST_ASSERT_EQUAL_STRING("0,5", argv_get(argv, 1));
	TEST_ASSERT_EQUAL_STRING("1", argv_get(argv, 2));
	TEST_ASSERT_EQUAL_STRING("2", argv_get(argv, 3));
	TEST_ASSERT_EQUAL_STRING("2.5", argv_get(argv, 4));
	TEST_ASSERT_EQUAL_STRING("3", argv_get(argv, 5));
	TEST_ASSERT_EQUAL_STRING("3.5", argv_get(argv, 6));
	TEST_ASSERT_NULL(argv_get(argv, 7));

	argv_pop(argv);
	TEST_ASSERT_EQUAL(6, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("0", argv_get(argv, 0));
	TEST_ASSERT_EQUAL_STRING("0,5", argv_get(argv, 1));
	TEST_ASSERT_EQUAL_STRING("1", argv_get(argv, 2));
	TEST_ASSERT_EQUAL_STRING("2", argv_get(argv, 3));
	TEST_ASSERT_EQUAL_STRING("2.5", argv_get(argv, 4));
	TEST_ASSERT_EQUAL_STRING("3", argv_get(argv, 5));
	TEST_ASSERT_NULL(argv_get(argv, 6));

	argv_shift(argv);
	TEST_ASSERT_EQUAL(5, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("0,5", argv_get(argv, 0));
	TEST_ASSERT_EQUAL_STRING("1", argv_get(argv, 1));
	TEST_ASSERT_EQUAL_STRING("2", argv_get(argv, 2));
	TEST_ASSERT_EQUAL_STRING("2.5", argv_get(argv, 3));
	TEST_ASSERT_EQUAL_STRING("3", argv_get(argv, 4));
	TEST_ASSERT_NULL(argv_get(argv, 5));

	argv_pop(argv); 
	argv_pop(argv);
	argv_pop(argv);
	argv_pop(argv);
	TEST_ASSERT_EQUAL(1, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("0,5", argv_get(argv, 0));
	TEST_ASSERT_NULL(argv_get(argv, 1));

	argv_pop(argv);
	TEST_ASSERT_EQUAL(0, argv_len(argv));
	TEST_ASSERT_NULL(argv_get(argv, 0));

	argv_pop(argv);
	TEST_ASSERT_EQUAL(0, argv_len(argv));
	TEST_ASSERT_NULL(argv_get(argv, 0));

	argv_push(argv, "1");
	TEST_ASSERT_EQUAL(1, argv_len(argv));
	TEST_ASSERT_EQUAL_STRING("1", argv_get(argv, 0));
	TEST_ASSERT_NULL(argv_get(argv, 1));

	argv_shift(argv);
	TEST_ASSERT_EQUAL(0, argv_len(argv));
	TEST_ASSERT_NULL(argv_get(argv, 0));

	argv_shift(argv);
	TEST_ASSERT_EQUAL(0, argv_len(argv));
	TEST_ASSERT_NULL(argv_get(argv, 0));

	argv_clear(argv);
	TEST_ASSERT_EQUAL(0, argv_len(argv));
	
	argv_free(argv);
}

void t_strutil_argv_sort(void)
{
	argv_t *argv = argv_new();
	argv_push(argv, "22");
	argv_push(argv, "2");
	argv_push(argv, "25");
	argv_push(argv, "11");
	argv_push(argv, "1");

	argv_sort(argv);
	char **p = argv_front(argv);
	TEST_ASSERT_EQUAL_STRING("1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("11", *p); p++;
	TEST_ASSERT_EQUAL_STRING("2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("22", *p); p++;
	TEST_ASSERT_EQUAL_STRING("25", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(argv);
}

