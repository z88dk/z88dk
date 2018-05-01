//-----------------------------------------------------------------------------
// file utilities
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "fileutil.h"
#include <assert.h>
#include <limits.h>
#include <stdio.h>

void t_fileutil_xfopen(void)
{
	char buffer[6];

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite("hello", sizeof(char), 5, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread(buffer, sizeof(char), 5, fp);
	buffer[5] = '\0';
	TEST_ASSERT_EQUAL_STRING("hello", buffer);

	xfclose(fp);
	remove("test.out");
}

void t_fileutil_xfclose_remove_empty(void)
{
	remove("test.out");
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite("hello", sizeof(char), 5, fp);
	xfclose_remove_empty(fp);

	fp = xfopen("test.out", "rb");
	xfseek(fp, 0, SEEK_END);
	TEST_ASSERT_EQUAL(5, ftell(fp));
	xfclose(fp);

	fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);
	xfclose_remove_empty(fp);

	fp = fopen("test.out", "rb");
	TEST_ASSERT_NULL(fp);
}

void run_fileutil_xfopen(void)
{
	FILE *fp = xfopen("/x/x/x/x/x/x/x/x/x", "rb");
	assert(0);
	xfclose(fp); // not reached, silence warning on unused fp
}

void t_fileutil_xfwrite_bytes(void)
{
	char buffer[6];

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_bytes("hello", 5, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread_bytes(buffer, 5, fp);
	buffer[5] = '\0';
	TEST_ASSERT_EQUAL_STRING("hello", buffer);

	xfclose(fp);
	remove("test.out");
}

void t_fileutil_xfwrite_cstr(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_cstr("hello", fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	str_t *s = str_new();
	xfread_str(5, s, fp);
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	xfclose(fp);
	remove("test.out");
	str_free(s);
}

void t_fileutil_xfwrite_str(void)
{
	str_t *s = str_new();
	str_set(s, "hello");

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_str(s, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	str_clear(s);
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	xfread_str(5, s, fp);
	TEST_ASSERT_EQUAL_STRING("hello", str_data(s));

	xfclose(fp);
	remove("test.out");
	str_free(s);
}

void run_fileutil_xfwrite_str(void)
{
	str_t *s = str_new();
	str_set(s, "hello");

	FILE *fp = xfopen("test.out", "wb");
	xfwrite_str(s, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");	// open for read, try to write
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_str(s, fp);				// dies
	assert(0);
}

void t_fileutil_xfwrite_bcount_str_1(void)
{
	str_t *s = str_new();
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);

	str_clear(s);
	xfwrite_bcount_str(s, fp);

	fputc(0xFF, fp);

	str_set(s, "h");
	xfwrite_bcount_str(s, fp);

	fputc(0xFF, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(1, fgetc(fp));
	TEST_ASSERT_EQUAL('h', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfclose(fp);
	remove("test.out");
	str_free(s);
}

void t_fileutil_xfwrite_bcount_str_2(void)
{
	str_t *s = str_new();
	str_set(s, 
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcde");
	TEST_ASSERT_EQUAL(255, str_len(s));

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_bcount_str(s, fp);
	xfclose(fp);

	str_t *r = str_new();

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread_bcount_str(r, fp);
	TEST_ASSERT_EQUAL(255, str_len(s));
	TEST_ASSERT_EQUAL_STRING(str_data(s), str_data(r));

	xfclose(fp);
	remove("test.out");
	str_free(s);
	str_free(r);
}

void run_fileutil_xfwrite_bcount_str(void)
{
	str_t *s = str_new();
	str_set(s,
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef");
	TEST_ASSERT_EQUAL(256, str_len(s));

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_bcount_str(s, fp);		// dies
	assert(0);
}

void run_fileutil_xfwrite_wcount_str(void)
{
	size_t sz = 0x10000;
	str_t *s = str_new();
	str_reserve(s, sz);
	memset(str_data(s), 'x', sz);
	str_data(s)[str_len(s) = sz] = '\0';

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_wcount_str(s, fp);		// dies
	assert(0);
}

void t_fileutil_xfwrite_wcount_str_1(void)
{
	size_t sz = 0xFFFF;
	str_t *s = str_new();
	str_reserve(s, sz);
	memset(str_data(s), 'x', sz);
	str_data(s)[str_len(s) = sz] = '\0';

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_wcount_str(s, fp);
	xfclose(fp);

	str_clear(s);
	TEST_ASSERT_EQUAL_STRING("", str_data(s));

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread_wcount_str(s, fp);

	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	TEST_ASSERT_EQUAL(sz, str_len(s));
	for (size_t i = 0; i < sz; i++)
		TEST_ASSERT_EQUAL('x', str_data(s)[i]);

	xfclose(fp);
	remove("test.out");
	str_free(s);
}

void t_fileutil_xfwrite_wcount_str_2(void)
{
	str_t *s = str_new();
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);

	str_clear(s);
	xfwrite_wcount_str(s, fp);

	fputc(0xFF, fp);

	str_set(s, "h");
	xfwrite_wcount_str(s, fp);

	fputc(0xFF, fp);

	str_reserve(s, 256);
	memset(str_data(s), ' ', 256);
	str_data(s)[str_len(s) = 256] = '\0';

	xfwrite_wcount_str(s, fp);

	fputc(0xFF, fp);

	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(1, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL('h', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(1, fgetc(fp));
	for (int i = 0; i < 256; i++)
		TEST_ASSERT_EQUAL(' ', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfclose(fp);
	remove("test.out");
	str_free(s);
}

void t_fileutile_xfwrite_byte(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);
	xfwrite_byte(0, fp);
	fputc(0xFF, fp);
	xfwrite_byte(255, fp);
	fputc(0xFF, fp);

	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfseek(fp, 0, SEEK_SET);
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, xfread_byte(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, xfread_byte(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfclose(fp);
	remove("test.out");
}

void t_fileutile_xfwrite_word(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);
	xfwrite_word(0, fp);
	fputc(0xFF, fp);
	xfwrite_word(255, fp);
	fputc(0xFF, fp);
	xfwrite_word(256, fp);
	fputc(0xFF, fp);
	xfwrite_word(65535, fp);
	fputc(0xFF, fp);

	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(1, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfseek(fp, 0, SEEK_SET);
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, xfread_word(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, xfread_word(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(256, xfread_word(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(65535, xfread_word(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfclose(fp);
	remove("test.out");
}

void t_fileutile_xfwrite_dword(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);
	xfwrite_dword(0, fp);
	fputc(0xFF, fp);
	xfwrite_dword(255, fp);
	fputc(0xFF, fp);
	xfwrite_dword(256, fp);
	fputc(0xFF, fp);
	xfwrite_dword(65535, fp);
	fputc(0xFF, fp);
	xfwrite_dword(INT32_MAX, fp);
	fputc(0xFF, fp);
	xfwrite_dword(INT32_MIN, fp);
	fputc(0xFF, fp);

	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(1, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(127, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(128, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfseek(fp, 0, SEEK_SET);
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, xfread_dword(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, xfread_dword(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(256, xfread_dword(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(65535, xfread_dword(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(INT32_MAX, xfread_dword(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(INT32_MIN, xfread_dword(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));
	
	xfclose(fp);
	remove("test.out");
}

void run_fileutil_xfread(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc('h', fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	char buffer[2];
	xfread(buffer, sizeof(char), NUM_ELEMS(buffer), fp); // dies
	assert(0);
}

void run_fileutil_xfread_str(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc('h', fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	str_t *s = str_new();
	xfread_str(2, s, fp);	// dies
	assert(0);
}

void run_fileutil_xfread_bcount_str(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(255, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	str_t *s = str_new();
	xfread_bcount_str(s, fp);	// dies
	assert(0);
}

void run_fileutil_xfread_wcount_str(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(255, fp);
	fputc(255, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	str_t *s = str_new();
	xfread_wcount_str(s, fp);	// dies
	assert(0);
}

void run_fileutil_xfseek(void)
{
	xfseek(NULL, 0, SEEK_END);	// dies
}
