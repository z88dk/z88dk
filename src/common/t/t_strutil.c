//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "strutil.h"
#include "unity.h"

void t_strutil_cstr_toupper(void)
{
	char buff[10];
	strcpy(buff, "abc1"); TEST_ASSERT_EQUAL_STRING("ABC1", cstr_toupper(buff));
	strcpy(buff, "Abc1"); TEST_ASSERT_EQUAL_STRING("ABC1", cstr_toupper(buff));
	strcpy(buff, "ABC1"); TEST_ASSERT_EQUAL_STRING("ABC1", cstr_toupper(buff));
}

void t_strutil_cstr_tolower(void)
{
	char buff[10];
	strcpy(buff, "abc1"); TEST_ASSERT_EQUAL_STRING("abc1", cstr_tolower(buff));
	strcpy(buff, "Abc1"); TEST_ASSERT_EQUAL_STRING("abc1", cstr_tolower(buff));
	strcpy(buff, "ABC1"); TEST_ASSERT_EQUAL_STRING("abc1", cstr_tolower(buff));
}

void t_strutil_cstr_chomp(void)
{
	char buff[100];
	strcpy(buff, ""); TEST_ASSERT_EQUAL_STRING("", cstr_chomp(buff));
	strcpy(buff, "\r\n \t\f \r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("", cstr_chomp(buff));
	strcpy(buff, "\r\n \t\fx\r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("\r\n \t\fx", cstr_chomp(buff));
}

void t_strutil_cstr_strip(void)
{
	char buff[100];
	strcpy(buff, ""); TEST_ASSERT_EQUAL_STRING("", cstr_strip(buff));
	strcpy(buff, "\r\n \t\f \r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("", cstr_strip(buff));
	strcpy(buff, "\r\n \t\fx\r\n \t\f\v"); TEST_ASSERT_EQUAL_STRING("x", cstr_strip(buff));
}

void t_strutil_cstr_strip_compress_escapes(void)
{
	str_t *s = str_new();
	char cs[100];

#define T(in, out_len, out_str) \
			strcpy(cs, in); \
			TEST_ASSERT_EQUAL(out_len, cstr_compress_escapes(cs)); \
			TEST_ASSERT_EQUAL(0, memcmp(cs, out_str, out_len)); \
			str_set(s, in); \
			str_compress_escapes(s); \
			TEST_ASSERT_EQUAL(out_len, str_len(s)); \
			TEST_ASSERT_EQUAL(0, memcmp(str_data(s), out_str, out_len))

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
		int len = cstr_compress_escapes(cs);
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

	str_free(s);
#undef T
}

void t_strutil_cstr_case_cmp(void)
{
	TEST_ASSERT(cstr_case_cmp("", "") == 0);
	TEST_ASSERT(cstr_case_cmp("a", "") > 0);
	TEST_ASSERT(cstr_case_cmp("", "a") < 0);
	TEST_ASSERT(cstr_case_cmp("a", "a") == 0);
	TEST_ASSERT(cstr_case_cmp("a", "A") == 0);
	TEST_ASSERT(cstr_case_cmp("A", "a") == 0);
	TEST_ASSERT(cstr_case_cmp("ab", "a") > 0);
	TEST_ASSERT(cstr_case_cmp("a", "ab") < 0);
	TEST_ASSERT(cstr_case_cmp("ab", "ab") == 0);
}

void t_strutil_cstr_case_ncmp(void)
{
	TEST_ASSERT(cstr_case_ncmp("", "", 0) == 0);
	TEST_ASSERT(cstr_case_ncmp("x", "y", 0) == 0);
	TEST_ASSERT(cstr_case_ncmp("a", "", 1) > 0);
	TEST_ASSERT(cstr_case_ncmp("", "a", 1) < 0);
	TEST_ASSERT(cstr_case_ncmp("ax", "ay", 1) == 0);
	TEST_ASSERT(cstr_case_ncmp("ax", "Ay", 1) == 0);
	TEST_ASSERT(cstr_case_ncmp("Ax", "ay", 1) == 0);
	TEST_ASSERT(cstr_case_ncmp("abx", "a", 2) > 0);
	TEST_ASSERT(cstr_case_ncmp("a", "aby", 2) < 0);
	TEST_ASSERT(cstr_case_ncmp("abx", "aby", 2) == 0);
}

void t_strutil_str_new(void)
{
	str_t *s = str_new();
	
	TEST_ASSERT_NOT_NULL(s);
	TEST_ASSERT_NOT_NULL(str_data(s));
	TEST_ASSERT_EQUAL('\0', *str_data(s));
	TEST_ASSERT_EQUAL(0, str_len(s));
	TEST_ASSERT_EQUAL_STRING("", str_data(s));
	
	str_free(s);
}

void t_strutil_str_new_copy(void)
{
	str_t *s = str_new_copy("hello");
	
	TEST_ASSERT_NOT_NULL(s);
	TEST_ASSERT_NOT_NULL(str_data(s));
	TEST_ASSERT_EQUAL(5, str_len(s));
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));
	
	str_data(s)[3] = '\0';
	str_sync_len(s);

	TEST_ASSERT_EQUAL(3, str_len(s));
	TEST_ASSERT_EQUAL_STRING("hel", str_data(s));

	str_free(s);
}

void t_strutil_str_clear(void)
{
	str_t *s = str_new_copy("hello");
	
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));
	
	str_clear(s);
	TEST_ASSERT_EQUAL_STRING("", str_data(s));
	
	str_free(s);
}

void t_strutil_str_reserve(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL(0, s->i);
	TEST_ASSERT_EQUAL(100, s->n);
	TEST_ASSERT_EQUAL(0, s->d[0]);

	str_reserve(s, 99);
	TEST_ASSERT_EQUAL(0, s->i);
	TEST_ASSERT_EQUAL(100, s->n);
	TEST_ASSERT_EQUAL(0, s->d[99]);

	str_reserve(s, 100);
	TEST_ASSERT_EQUAL(0, s->i);
	TEST_ASSERT_EQUAL(101, s->n);
	TEST_ASSERT_EQUAL(0, s->d[100]);
	str_free(s);

	s = str_new_copy("1234567890");
	str_reserve(s, 89);
	TEST_ASSERT_EQUAL(10, s->i);
	TEST_ASSERT_EQUAL(100, s->n);
	TEST_ASSERT_EQUAL(0, s->d[99]);

	str_reserve(s, 90);
	TEST_ASSERT_EQUAL(10, s->i);
	TEST_ASSERT_EQUAL(101, s->n);
	TEST_ASSERT_EQUAL(0, s->d[100]);
	str_free(s);
}

void t_strutil_str_set(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_set(s, "hello");
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	str_set(s, "world");
	TEST_ASSERT_EQUAL_STRING("world", str_data(s));

	str_free(s);
}

void t_strutil_str_set_f(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_set_f(s, "%s %d", "hello", 21);
	TEST_ASSERT_EQUAL_STRING("hello 21", str_data(s));

	str_set_f(s, "%s %d", "world", 42);
	TEST_ASSERT_EQUAL_STRING("world 42", str_data(s));

	str_free(s);
}

void t_strutil_str_set_n(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_set_n(s, "\0\1\2\3", 4);
	TEST_ASSERT_EQUAL(4, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\0\1\2\3\0", 5));

	str_set_n(s, "\3\2\1\0", 4);
	TEST_ASSERT_EQUAL(4, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\3\2\1\0\0", 5));

	str_free(s);
}

void t_strutil_str_set_str(void)
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

void t_strutil_str_append(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_append(s, "hello");
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	str_append(s, "world");
	TEST_ASSERT_EQUAL_STRING("helloworld", str_data(s));

	str_free(s);
}

void t_strutil_str_append_f(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_append_f(s, "%s %d", "hello", 21);
	TEST_ASSERT_EQUAL_STRING("hello 21", str_data(s));

	str_append_f(s, "%s %d", "world", 42);
	TEST_ASSERT_EQUAL_STRING("hello 21world 42", str_data(s));

	str_free(s);
}

void t_strutil_str_append_n(void)
{
	str_t *s = str_new();
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	str_append_n(s, "\0\1\2\3", 4);
	TEST_ASSERT_EQUAL(4, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\0\1\2\3\0", 5));

	str_append_n(s, "\3\2\1\0", 4);
	TEST_ASSERT_EQUAL(8, str_len(s));
	TEST_ASSERT_EQUAL(0, memcmp(str_data(s), "\0\1\2\3\3\2\1\0\0", 9));

	str_free(s);
}

void t_strutil_str_append_str(void)
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

void t_strutil_str_toupper(void)
{
	str_t *s = str_new();
	str_set(s, "abc1"); str_toupper(s); TEST_ASSERT_EQUAL_STRING("ABC1", str_data(s));
	str_set(s, "Abc1"); str_toupper(s); TEST_ASSERT_EQUAL_STRING("ABC1", str_data(s));
	str_set(s, "ABC1"); str_toupper(s); TEST_ASSERT_EQUAL_STRING("ABC1", str_data(s));
	str_free(s);
}

void t_strutil_str_tolower(void)
{
	str_t *s = str_new();
	str_set(s, "abc1"); str_tolower(s); TEST_ASSERT_EQUAL_STRING("abc1", str_data(s));
	str_set(s, "Abc1"); str_tolower(s); TEST_ASSERT_EQUAL_STRING("abc1", str_data(s));
	str_set(s, "ABC1"); str_tolower(s); TEST_ASSERT_EQUAL_STRING("abc1", str_data(s));
	str_free(s);
}

void t_strutil_str_chomp(void)
{
	str_t *s = str_new();
	str_set(s, ""); str_chomp(s); TEST_ASSERT_EQUAL_STRING("", str_data(s));
	str_set(s, "\r\n \t\f \r\n \t\f\v"); str_chomp(s); TEST_ASSERT_EQUAL_STRING("", str_data(s));
	str_set(s, "\r\n \t\fx\r\n \t\f\v"); str_chomp(s); TEST_ASSERT_EQUAL_STRING("\r\n \t\fx", str_data(s));
	str_free(s);
}

void t_strutil_str_strip(void)
{
	str_t *s = str_new();
	str_set(s, ""); str_strip(s); TEST_ASSERT_EQUAL_STRING("", str_data(s));
	str_set(s, "\r\n \t\f \r\n \t\f\v"); str_strip(s); TEST_ASSERT_EQUAL_STRING("", str_data(s));
	str_set(s, "\r\n \t\fx\r\n \t\f\v"); str_strip(s); TEST_ASSERT_EQUAL_STRING("x", str_data(s));
	str_free(s);
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

void t_strutil_spool_add(void)
{
#define NUM_STRINGS 10
#define STRING_SIZE	5
	struct {
		char source[STRING_SIZE];
		const char *pool;
	} strings[NUM_STRINGS];

	const char *pool;
	int i;

	// first run - create pool for all strings
	for (i = 0; i < NUM_STRINGS; i++) {
		sprintf(strings[i].source, "%d", i);		// number i

		pool = spool_add(strings[i].source);
		TEST_ASSERT_NOT_NULL(pool);
		TEST_ASSERT(pool != strings[i].source);
		TEST_ASSERT_EQUAL_STRING(strings[i].source, pool);

		strings[i].pool = pool;
	}

	// second run - check that pool did not move
	for (i = 0; i < NUM_STRINGS; i++) {
		pool = spool_add(strings[i].source);
		TEST_ASSERT_NOT_NULL(pool);
		TEST_ASSERT(pool != strings[i].source);
		TEST_ASSERT_EQUAL_STRING(strings[i].source, pool);
		TEST_ASSERT_EQUAL(strings[i].pool, pool);
	}

	// check NULL case
	pool = spool_add(NULL);
	TEST_ASSERT_NULL(pool);
}

