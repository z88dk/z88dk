/*
Z88DK Z80 Macro Assembler

Unit test for alloc.c

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include "str.h"
#include <assert.h>
#include <stdio.h>

#define TEST_FILE "test_str.tmp"

void dump_str ( Str *str, char *name )
{
	int i;

	warn("--------  "
		 "%s\nStr (len=%d size=%d%s%s) = \"",
		 name, str_len( str ), str_size( str ), 
		 str->flag.header_alloc ? " header_alloc" : "",
		 str->flag.data_alloc   ?   " data_alloc" : "" );
	assert( str_data( str )[ str_len( str ) ] == 0 );

	for (i = 0; i < str->len; i++) {
		char c = str_data(str)[i];

		if (isgraph(c))
			warn("%c", c);
		else if (c == '\r')
			warn("{\\r}");
		else if (c == '\n')
			warn("{\\n}");
		else
			warn("{%02X}", c);
	}

	warn("\"\n\n");
}

#define T_CONVERT_STR(func, str_func, in, out) \
			strcpy(s, in); \
			p = func(s); \
			mu_assert( p == s, #func " output != input" ); \
			mu_assert_str( s, ==, out ); \
			str_set(str, in); \
			str_func(str); \
			mu_assert_str( str_data(str), ==, out )

int test_convert_str(void)
{
	STR_DEFINE(str, STR_SIZE);
	char s[STR_SIZE], *p;

	/* toupper */
	T_CONVERT_STR(stoupper, str_toupper, "abc1", "ABC1");
	T_CONVERT_STR(stoupper, str_toupper, "Abc1", "ABC1");
	T_CONVERT_STR(stoupper, str_toupper, "ABC1", "ABC1");
	
	/* stolower */
	T_CONVERT_STR(stolower, str_tolower, "abc1", "abc1");
	T_CONVERT_STR(stolower, str_tolower, "Abc1", "abc1");
	T_CONVERT_STR(stolower, str_tolower, "ABC1", "abc1");
	
	/* chomp */
	T_CONVERT_STR(chomp, str_chomp, "", "");
	T_CONVERT_STR(chomp, str_chomp, "\r\n \t\f \r\n \t\f\v", "");
	T_CONVERT_STR(chomp, str_chomp, "\r\n \t\fxxxxxxxx\r\n \t\f\v", "\r\n \t\fxxxxxxxx");

	/* strip */
	T_CONVERT_STR(strip, str_strip, "", "");
	T_CONVERT_STR(strip, str_strip, "\r\n \t\f \r\n \t\f\v", "");
	T_CONVERT_STR(strip, str_strip, "\r\n \t\fxxxxxxxx\r\n \t\f\v", "xxxxxxxx");

	/* stricompare */
	mu_assert_int( stricompare( "",  ""   ), ==, 0);
	mu_assert_int( stricompare( "a", ""   ), > , 0);
	mu_assert_int( stricompare( "",  "a"  ), < , 0);
	mu_assert_int( stricompare( "a", "a"  ), ==, 0);
	mu_assert_int( stricompare( "a", "A"  ), ==, 0);
	mu_assert_int( stricompare( "A", "a"  ), ==, 0);
	mu_assert_int( stricompare( "ab","a"  ), > , 0);
	mu_assert_int( stricompare( "a", "ab" ), < , 0);
	mu_assert_int( stricompare( "ab","ab" ), ==, 0);
	
	return MU_PASS;
}

#define T_COMPRESS( in, out_len, out_str ) \
			strcpy(s, in); \
			len = compress_escapes(s); \
			mu_assert( len == out_len, "len=%d, out_len=%d", len, out_len ); \
			mu_assert( memcmp(s, out_str, out_len) == 0, "compress_escapes failed" ); \
			str_set(str, in); \
			str_compress_escapes(str); \
			mu_assert(str_len(str) == out_len, "str_len=%d, out_len=%d", len, out_len); \
			mu_assert( memcmp(str_data(str), out_str, out_len) == 0, "str_compress_escapes failed" )

int test_compress_escapes(void)
{
	STR_DEFINE(str, STR_SIZE);
	char s[STR_SIZE];
	int  len, i;

	/* trailing backslash ignored */
	T_COMPRESS( "\\", 0, "" );
		
	/* escape any */
	T_COMPRESS( "\\" "?" "\\" "\"" "\\" "'",
				3, "?\"'" );
		
	/* escape chars */
	T_COMPRESS( "0" "\\a" 
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
				"8" );
		
	/* octal and hexadecimal, including '\0' */
	for ( i = 0; i < 256; i++ )
	{
		sprintf(s, "\\%o \\x%x", i, i );
		len = compress_escapes(s);		
		mu_assert( len  == 3,		"len=%d", len );
		mu_assert( s[0] == (char)i,	"s[0]=%d", s[0] );
		mu_assert( s[1] == ' ',		"s[1]=%d", s[1] );
		mu_assert( s[2] == (char)i,	"s[2]=%d", s[2] );
		mu_assert( s[3] == '\0',	"s[3]=%d", s[3] );
	}
		
	/* octal and hexadecimal with longer digit string */
	T_COMPRESS( "\\3770\\xff0", 
				4,
				"\xFF" "0" "\xFF" "0");

	return MU_PASS;
}

STR_DECLARE( s1 );
STR_DEFINE( s1, STR_SIZE );

STR_DECLARE( s2 );
STR_DEFINE( s2, 10 );

/* check that static Str keeps its data */
char *static_str( int init )
{
	static STR_DEFINE( str, STR_SIZE );

	if ( init >= 0 )
		sprintf( str_data( str ), "%d", init );

	return str_data( str );
}

void call_vsprintf(Str *str, char *format, ...)
{
	va_list argptr;

	va_start(argptr, format);
	str_vsprintf(str, format, argptr);
	va_end(argptr);
}

void call_append_vsprintf(Str *str, char *format, ...)
{
	va_list argptr;

	va_start(argptr, format);
	str_append_vsprintf(str, format, argptr);
	va_end(argptr);
}

#define T_STR(s, xxx)	xxx; dump_str(s, #xxx)

int test_str(void)
{
	STR_DEFINE( s3, 10 );
	Str *s4, *s5;
	STR_DEFINE(s6, 10);
	STR_DEFINE(s7, 10);

	dump_str( s1, "s1" );
	dump_str( s2, "s2" );
	dump_str( s3, "s3" );

	/* check static strings keep their value */
	mu_assert_str( static_str(4),  ==, "4" );
	mu_assert_str( static_str(-1), ==, "4" );
	mu_assert_str( static_str(-1), ==, "4" );

	mu_assert_str( static_str(7),  ==, "7" );
	mu_assert_str( static_str(-1), ==, "7" );
	mu_assert_str( static_str(-1), ==, "7" );

	T_STR(s4, s4 = str_new(6));		/* alloc, keep memory leak */

	T_STR(s5, s5 = str_new(6));
	
	/* expand */
	T_STR(s3, str_clear(s3));
	T_STR(s3, str_reserve(s3, 9));
	T_STR(s3, str_reserve(s3, 10));
	T_STR(s3, str_reserve(s3, 11));
	T_STR(s3, str_clear(s3));

	/* char */
	T_STR(s4, str_set(s4, "xxxx"));
	T_STR(s4, str_set_char(s4, 0));
	T_STR(s4, str_append_char(s4, 1));
	T_STR(s4, str_append_char(s4, 2));
	T_STR(s4, str_append_char(s4, 3));
	T_STR(s4, str_append_char(s4, 4));
	T_STR(s4, str_append_char(s4, 5));
	T_STR(s4, str_append_char(s4, 6));
	T_STR(s4, str_append_char(s4, 7));
	T_STR(s4, str_append_char(s4, 8));
	T_STR(s4, str_append_char(s4, 9));
	T_STR(s4, str_append_char(s4, 10));
	T_STR(s4, str_clear(s4));

	/* string */
	T_STR(s5, str_set(s5, "1234"));
	T_STR(s5, str_append(s5, "56789"));
	T_STR(s5, str_append(s5, "0"));
	T_STR(s5, str_clear(s5));

	/* substring */
	T_STR(s5, str_set_n(s5, "1234xx", 4));
	T_STR(s5, str_append_n(s5, "56789xx", 5));
	T_STR(s5, str_append_n(s5, "01234567890xx", 11));
	T_STR(s5, str_clear(s5));

	/* bytes */
	T_STR(s5, str_set_bytes(s5, "\0\1\2\3x", 3));
	T_STR(s5, str_append_bytes(s5, "\4\5\6x", 3));
	T_STR(s5, str_clear(s5));

	/* sprintf - test repeated call to vsprintf when buffer grows, needs va_copy in MacOS */
	T_STR(s6, str_set(s6, "xxxx"));
	T_STR(s6, str_sprintf(s6, "%s %d", "hello", 123));
	T_STR(s6, str_sprintf(s6, "%s %d", "hello", 1234));
	T_STR(s6, str_append_sprintf(s6, "%s %d", "hello", 12345));
	T_STR(s6, str_clear(s6));

	/* vsprintf - test repeated call to vsprintf when buffer grows, needs va_copy in MacOS */
	T_STR(s7, str_set(s7, "xxxx"));
	T_STR(s7, call_vsprintf(s7, "%s %d", "hello", 123));
	T_STR(s7, call_vsprintf(s7, "%s %d", "hello", 1234));
	T_STR(s7, call_append_vsprintf(s7, "%s %d", "hello", 12345));
	T_STR(s7, str_clear(s7));

	str_delete(s5);
	mu_assert_ptr_null(s5);

	STR_DELETE(s3);
	mu_assert_ptr_null(s3);

	STR_DELETE(s6);
	mu_assert_ptr_null(s6);

	STR_DELETE(s7);
	mu_assert_ptr_null(s7);

	return MU_PASS;
}

#define T_GETLINE(_s) \
				str_set(s1, _s); \
				dump_str(s1, "input"); \
				fp = fopen(TEST_FILE, "wb"); \
				mu_assert_ptr(fp); \
				ret = fputs(str_data(s1), fp); \
				mu_assert(ret >= 0, "fputs=%d", ret); \
				ret = fclose(fp); \
				mu_assert(ret == 0, "fclose=%d", ret); \
				fp = fopen(TEST_FILE, "rb"); \
				mu_assert_ptr(fp); \
				warn("read lines\n"); \
				line_nr = 0; \
				str_set(s2, "xxxx"); \
				while (str_getline(s2, fp)) { \
					warn("line %d\n", ++line_nr); \
					dump_str(s2, "read line"); \
				} \
				warn("end of file, read %d lines\n", line_nr); \
				dump_str(s2, "last line"); \
				ret = fclose(fp); \
				mu_assert(ret == 0, "fclose=%d", ret); \
				ret = remove(TEST_FILE); \
				mu_assert(ret == 0, "remove=%d", ret)

int test_getline(void)
{
	STR_DEFINE(s1, 10);
	STR_DEFINE(s2, 10);
	FILE *fp;
	int ret;
	int line_nr;

	dump_str(s1, "s1");
	dump_str(s2, "s2");

	T_GETLINE("");
	T_GETLINE("A\nB\rC\r\nD\n\rE");
	T_GETLINE("A\nB\rC\r\nD\n\rE\n");
	T_GETLINE("A\nB\rC\r\nD\n\rE\r");
	T_GETLINE("A\nB\rC\r\nD\n\rE\n\r");
	T_GETLINE("A\nB\rC\r\nD\n\rE\r\n");
	T_GETLINE("1234567890" "1234567890" "1234567890" "1234567890");

	STR_DELETE(s1);
	mu_assert_ptr_null(s1);

	STR_DELETE(s2);
	mu_assert_ptr_null(s2);

	return MU_PASS;
}

int main(int argc, char *argv[])
{
	mu_init(argc, argv);
    mu_run_test(MU_PASS, test_convert_str);
    mu_run_test(MU_PASS, test_compress_escapes);
	mu_run_test(MU_PASS, test_str);
	mu_run_test(MU_PASS, test_getline);
	mu_fini();
}
