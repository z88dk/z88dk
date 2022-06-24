//-----------------------------------------------------------------------------
// file utilities
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "die.h"
#include "fileutil.h"
#include "zutils.h"

#include <limits.h>
#include <stdio.h>

void t_fileutil_path_canon(void)
{
	// files
	TEST_ASSERT_EQUAL_STRING(".", path_canon(""));
	TEST_ASSERT_EQUAL_STRING(".", path_canon("."));
	TEST_ASSERT_EQUAL_STRING("..", path_canon(".."));
	TEST_ASSERT_EQUAL_STRING("abc", path_canon("abc"));

	// multiple slashes are colapsed
	TEST_ASSERT_EQUAL_STRING("abc/def", path_canon("abc//\\//def"));
	TEST_ASSERT_EQUAL_STRING("abc/def", path_canon("abc//\\//def//\\//"));
	TEST_ASSERT_EQUAL_STRING("c:abc/def", path_canon("c:abc//\\//def//\\//"));
	TEST_ASSERT_EQUAL_STRING("c:/abc/def", path_canon("c://\\//abc//\\//def//\\//"));

	// handle multiple trainling slashes
	TEST_ASSERT_EQUAL_STRING("abc", path_canon("abc//"));
	TEST_ASSERT_EQUAL_STRING("/", path_canon("//"));
	TEST_ASSERT_EQUAL_STRING("c:/", path_canon("c://"));

	// handle dir/..
	TEST_ASSERT_EQUAL_STRING(".", path_canon("abc/.."));
	TEST_ASSERT_EQUAL_STRING(".", path_canon("abc/../"));
	TEST_ASSERT_EQUAL_STRING("def", path_canon("abc/../def"));
	TEST_ASSERT_EQUAL_STRING("../def", path_canon("abc/../../def"));

	TEST_ASSERT_EQUAL_STRING("c:", path_canon("c:abc/.."));
	TEST_ASSERT_EQUAL_STRING("c:", path_canon("c:abc/../"));
	TEST_ASSERT_EQUAL_STRING("c:def", path_canon("c:abc/../def"));
	TEST_ASSERT_EQUAL_STRING("c:../def", path_canon("c:abc/../../def"));

	TEST_ASSERT_EQUAL_STRING("c:/", path_canon("c:/abc/.."));
	TEST_ASSERT_EQUAL_STRING("c:/", path_canon("c:/abc/../"));
	TEST_ASSERT_EQUAL_STRING("c:/def", path_canon("c:/abc/../def"));
	TEST_ASSERT_EQUAL_STRING("c:/../def", path_canon("c:/abc/../../def"));

	// handle ./
	TEST_ASSERT_EQUAL_STRING("abc", path_canon("./abc"));
	TEST_ASSERT_EQUAL_STRING("abc", path_canon("./abc/."));
	TEST_ASSERT_EQUAL_STRING("c:abc", path_canon("c:./abc/."));
	TEST_ASSERT_EQUAL_STRING("c:/abc", path_canon("c:/././abc/."));

	// handle initial ../
	TEST_ASSERT_EQUAL_STRING("../abc", path_canon("../abc"));
	TEST_ASSERT_EQUAL_STRING("../../abc", path_canon("../../abc"));
	TEST_ASSERT_EQUAL_STRING("../../../abc", path_canon("../../../abc"));
}

void t_fileutil_path_os(void)
{
#ifdef _WIN32
	TEST_ASSERT_EQUAL_STRING("c:\\abc\\def", path_os("c://\\//abc//\\//def//\\//"));
#else
	TEST_ASSERT_EQUAL_STRING("c:/abc/def", path_os("c://\\//abc//\\//def//\\//"));
#endif
}

void t_fileutil_path_combine(void)
{
	TEST_ASSERT_EQUAL_STRING("a/b", path_combine("a", "b"));
	TEST_ASSERT_EQUAL_STRING("a/b", path_combine("a/", "b"));
	TEST_ASSERT_EQUAL_STRING("a/b", path_combine("a", "/b"));
	TEST_ASSERT_EQUAL_STRING("a/b", path_combine("a/", "/b"));
	TEST_ASSERT_EQUAL_STRING("a/c/b", path_combine("a/", "c:/b"));
}

void t_fileutil_path_dir(void)
{
	TEST_ASSERT_EQUAL_STRING(".", path_dir("abc"));
	TEST_ASSERT_EQUAL_STRING(".", path_dir("abc.xx"));
	TEST_ASSERT_EQUAL_STRING(".", path_dir("./abc"));

	TEST_ASSERT_EQUAL_STRING("/a/b/c", path_dir("/a/b/c/abc"));
	TEST_ASSERT_EQUAL_STRING("a/b/c", path_dir("a/b/c/abc"));
	TEST_ASSERT_EQUAL_STRING("c:/a/b/c", path_dir("c:/a/b/c/abc"));
	TEST_ASSERT_EQUAL_STRING("c:a/b/c", path_dir("c:a/b/c/abc"));

	TEST_ASSERT_EQUAL_STRING("c:", path_dir("c:abc"));
	TEST_ASSERT_EQUAL_STRING("c:/", path_dir("c:/abc"));
}

void t_fileutil_path_file(void)
{
	TEST_ASSERT_EQUAL_STRING("abc", path_file("abc"));
	TEST_ASSERT_EQUAL_STRING("abc.xx", path_file("abc.xx"));
	TEST_ASSERT_EQUAL_STRING("abc", path_file(".x/abc"));

	TEST_ASSERT_EQUAL_STRING("abc", path_file("/a/b/c/abc"));
	TEST_ASSERT_EQUAL_STRING("abc", path_file("a/b/c/abc"));
	TEST_ASSERT_EQUAL_STRING("abc", path_file("c:/a/b/c/abc"));
	TEST_ASSERT_EQUAL_STRING("abc", path_file("c:a/b/c/abc"));

	TEST_ASSERT_EQUAL_STRING("abc", path_file("c:abc"));
	TEST_ASSERT_EQUAL_STRING("abc", path_file("c:/abc"));
}

void t_fileutil_path_ext(void)
{
	TEST_ASSERT_EQUAL_STRING("", path_ext("abc"));
	TEST_ASSERT_EQUAL_STRING(".xx", path_ext("abc.xx"));
	TEST_ASSERT_EQUAL_STRING("", path_ext(".x/abc"));

	TEST_ASSERT_EQUAL_STRING("", path_ext("c:abc"));
	TEST_ASSERT_EQUAL_STRING("", path_ext("c:/abc"));

	TEST_ASSERT_EQUAL_STRING(".c", path_ext("c:abc.c"));
	TEST_ASSERT_EQUAL_STRING(".c", path_ext("c:/abc.c"));

	TEST_ASSERT_EQUAL_STRING("", path_ext("c:.c"));
	TEST_ASSERT_EQUAL_STRING("", path_ext("c:/.c"));
}

void t_fileutil_path_remove_ext(void)
{
	TEST_ASSERT_EQUAL_STRING("abc", path_remove_ext("abc"));
	TEST_ASSERT_EQUAL_STRING("abc", path_remove_ext("abc."));
	TEST_ASSERT_EQUAL_STRING("abc", path_remove_ext("abc.xpt"));
	TEST_ASSERT_EQUAL_STRING("abc.xpt", path_remove_ext("abc.xpt."));
	TEST_ASSERT_EQUAL_STRING("abc.xpt", path_remove_ext("abc.xpt.obj"));

	TEST_ASSERT_EQUAL_STRING(".x/abc", path_remove_ext(".x/abc"));
	TEST_ASSERT_EQUAL_STRING(".x/abc", path_remove_ext(".x\\abc"));
	TEST_ASSERT_EQUAL_STRING(".x/abc", path_remove_ext(".x/abc."));
	TEST_ASSERT_EQUAL_STRING(".x/abc", path_remove_ext(".x\\abc."));
	TEST_ASSERT_EQUAL_STRING(".x/abc", path_remove_ext(".x/abc.xpt"));
	TEST_ASSERT_EQUAL_STRING(".x/abc.xpt", path_remove_ext(".x/abc.xpt."));
	TEST_ASSERT_EQUAL_STRING(".x/abc.xpt", path_remove_ext(".x/abc.xpt.obj"));

	TEST_ASSERT_EQUAL_STRING(".rc", path_remove_ext(".rc"));
	TEST_ASSERT_EQUAL_STRING("/.rc", path_remove_ext("/.rc"));
	TEST_ASSERT_EQUAL_STRING(".x/.rc", path_remove_ext(".x/.rc"));
}

void t_fileutil_path_replace_ext(void)
{
	TEST_ASSERT_EQUAL_STRING("abc", path_replace_ext("abc", ""));
	TEST_ASSERT_EQUAL_STRING("abc", path_replace_ext("abc.", ""));

	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc", "obj"));
	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc.", "obj"));
	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc", ".obj"));
	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc.", ".obj"));

	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc", "obj"));
	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc.", "obj"));
	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc", ".obj"));
	TEST_ASSERT_EQUAL_STRING("abc.obj", path_replace_ext("abc.", ".obj"));

	TEST_ASSERT_EQUAL_STRING("x./abc.obj", path_replace_ext("x./abc", "obj"));
	TEST_ASSERT_EQUAL_STRING("x./abc.obj", path_replace_ext("x./abc.", "obj"));
	TEST_ASSERT_EQUAL_STRING("x./abc.obj", path_replace_ext("x./abc", ".obj"));
	TEST_ASSERT_EQUAL_STRING("x./abc.obj", path_replace_ext("x./abc.", ".obj"));
}

void t_fileutil_xfopen(void)
{
	char buffer[6];

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite("hello", 1, 5, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread(buffer, 1, 5, fp);
	buffer[5] = '\0';
	TEST_ASSERT_EQUAL_STRING("hello", buffer);

	xfclose(fp);
	remove("test.out");
}

void run_fileutil_xfopen(void)
{
	FILE *fp = xfopen("/x/x/x/x/x/x/x/x/x", "rb");
	xassert(0);
	xfclose(fp); // not reached, silence warning on unused fp
}

void t_fileutil_xfclose_remove_empty(void)
{
	remove("test.out");
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite("hello", 1, 5, fp);
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

	UT_string *s = utstr_new();
	xfread_str(5, s, fp);
	TEST_ASSERT_EQUAL_STRING("hello", utstr_body(s));

	xfclose(fp);
	remove("test.out");
	utstr_free(s);
}

void t_fileutil_xfwrite_str(void)
{
	UT_string *s = utstr_new();
	utstr_set(s, "hello");

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_str(s, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	utstr_clear(s);
	TEST_ASSERT_EQUAL_STRING("", utstr_body(s));

	xfread_str(5, s, fp);
	TEST_ASSERT_EQUAL_STRING("hello", utstr_body(s));

	xfclose(fp);
	remove("test.out");
	utstr_free(s);
}

void run_fileutil_xfwrite_str(void)
{
	UT_string *s = utstr_new();
	utstr_set(s, "hello");

	FILE *fp = xfopen("test.out", "wb");
	xfwrite_str(s, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");	// open for read, try to write
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_str(s, fp);				// dies
	xassert(0);
}

void t_fileutil_xfwrite_bcount_str_1(void)
{
	UT_string *s = utstr_new();
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);

	utstr_clear(s);
	xfwrite_bcount_str(s, fp);
	fputc(0xFF, fp);

	utstr_set(s, "h");
	xfwrite_bcount_str(s, fp);
	fputc(0xFF, fp);

	xfwrite_bcount_bytes("hel", 3, fp);
	fputc(0xFF, fp);

	xfwrite_bcount_cstr("hel", fp);
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
	TEST_ASSERT_EQUAL(3, fgetc(fp));
	TEST_ASSERT_EQUAL('h', fgetc(fp));
	TEST_ASSERT_EQUAL('e', fgetc(fp));
	TEST_ASSERT_EQUAL('l', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(3, fgetc(fp));
	TEST_ASSERT_EQUAL('h', fgetc(fp));
	TEST_ASSERT_EQUAL('e', fgetc(fp));
	TEST_ASSERT_EQUAL('l', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfclose(fp);
	remove("test.out");
	utstr_free(s);
}

void t_fileutil_xfwrite_bcount_str_2(void)
{
	UT_string *s = utstr_new();
	utstr_set(s,  
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcde");
	TEST_ASSERT_EQUAL(255, utstr_len(s));

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_bcount_str(s, fp);
	xfclose(fp);

	UT_string *r = utstr_new();

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread_bcount_str(r, fp);
	TEST_ASSERT_EQUAL(255, utstr_len(s));
	TEST_ASSERT_EQUAL_STRING(utstr_body(s), utstr_body(r));

	xfclose(fp);
	remove("test.out");
	utstr_free(s);
	utstr_free(r);
}

void run_fileutil_xfwrite_bcount_str(void)
{
	UT_string *s = utstr_new();
	utstr_set(s, 
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef"
		"0123456789abcdef" "0123456789abcdef" "0123456789abcdef" "0123456789abcdef");
	TEST_ASSERT_EQUAL(256, utstr_len(s));

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_bcount_str(s, fp);		// dies
	xassert(0);
}

void t_fileutil_xfwrite_wcount_str_1(void)
{
	size_t sz = 0xFFFF;
	UT_string *s = utstr_new();
	utstr_reserve(s, sz);
	memset(utstr_body(s), 'x', sz);
	utstr_body(s)[utstr_len(s) = sz] = '\0';

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_wcount_str(s, fp);
	xfclose(fp);

	utstr_clear(s);
	TEST_ASSERT_EQUAL_STRING("", utstr_body(s));

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	xfread_wcount_str(s, fp);

	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	TEST_ASSERT_EQUAL(sz, utstr_len(s));
	for (size_t i = 0; i < sz; i++)
		TEST_ASSERT_EQUAL('x', utstr_body(s)[i]);

	xfclose(fp);
	remove("test.out");
	utstr_free(s);
}

void t_fileutil_xfwrite_wcount_str_2(void)
{
	UT_string *s = utstr_new();
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(0xFF, fp);

	utstr_clear(s);
	xfwrite_wcount_str(s, fp);

	fputc(0xFF, fp);

	utstr_set(s, "h");
	xfwrite_wcount_str(s, fp);

	fputc(0xFF, fp);

	utstr_reserve(s, 256);
	memset(utstr_body(s), ' ', 256);
	utstr_body(s)[utstr_len(s) = 256] = '\0';

	xfwrite_wcount_str(s, fp);
	fputc(0xFF, fp);

	xfwrite_wcount_bytes("hel", 3, fp);
	fputc(0xFF, fp);

	xfwrite_wcount_cstr("hel", fp);
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
	TEST_ASSERT_EQUAL(3, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL('h', fgetc(fp));
	TEST_ASSERT_EQUAL('e', fgetc(fp));
	TEST_ASSERT_EQUAL('l', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(3, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL('h', fgetc(fp));
	TEST_ASSERT_EQUAL('e', fgetc(fp));
	TEST_ASSERT_EQUAL('l', fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfclose(fp);
	remove("test.out");
	utstr_free(s);
}

void run_fileutil_xfwrite_wcount_str(void)
{
	size_t sz = 0x10000;
	UT_string *s = utstr_new();
	utstr_reserve(s, sz);
	memset(utstr_body(s), 'x', sz);
	utstr_body(s)[utstr_len(s) = sz] = '\0';

	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	xfwrite_wcount_str(s, fp);		// dies
	xassert(0);
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
	xfwrite_byte(-128, fp);
	fputc(0xFF, fp);

	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(128, fgetc(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(EOF, fgetc(fp));

	xfseek(fp, 0, SEEK_SET);
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(0, xfread_byte(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(255, xfread_byte(fp));
	TEST_ASSERT_EQUAL(0xFF, fgetc(fp));
	TEST_ASSERT_EQUAL(128, xfread_byte(fp));
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
	xfwrite_word(-32768, fp);
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
	TEST_ASSERT_EQUAL(0, fgetc(fp));
	TEST_ASSERT_EQUAL(128, fgetc(fp));
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
	TEST_ASSERT_EQUAL(32768, xfread_word(fp));
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
	xassert(0);
}

void run_fileutil_xfread_str(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc('h', fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	UT_string *s = utstr_new();
	xfread_str(2, s, fp);	// dies
	xassert(0);
}

void run_fileutil_xfread_bcount_str(void)
{
	FILE *fp = xfopen("test.out", "wb");
	TEST_ASSERT_NOT_NULL(fp);

	fputc(255, fp);
	xfclose(fp);

	fp = xfopen("test.out", "rb");
	TEST_ASSERT_NOT_NULL(fp);

	UT_string *s = utstr_new();
	xfread_bcount_str(s, fp);	// dies
	xassert(0);
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

	UT_string *s = utstr_new();
	xfread_wcount_str(s, fp);	// dies
	xassert(0);
}

void run_fileutil_xfseek(void)
{
#ifdef _WIN32
	// issues segmentation fault on Linux, fails silently on Win32
	xfseek(NULL, 0, SEEK_END);	// dies
#else
	fprintf(stderr, "failed to seek to 0 in file '?'\n");
	exit(1);
#endif
}

void t_fileutil_file_spew_slurp(void)
{
	remove("test.txt");
	TEST_ASSERT(!file_exists("test.txt"));
	TEST_ASSERT_EQUAL(-1, file_size("test.txt"));

	const char *text =
		"In the beginning God created the heaven and the earth. \n"
		"\n"
		"And the earth was without form, and void; and darkness was upon the face \n"
		"of the deep. And the Spirit of God moved upon the face of the waters. \n"
		"\n"
		"And God said, Let there be light: and there was light. \n"
		"\n"
		"And God saw the light, that it was good: and God divided the light from \n"
		"the darkness. \n"
		"\n"
		"And God called the light Day, and the darkness he called Night. And the \n"
		"evening and the morning were the first day. \n"
		"\n"
		"And God said, Let there be a firmament in the midst of the waters, and \n"
		"let it divide the waters from the waters. \n"
		"\n"
		"And God made the firmament, and divided the waters which were under the \n"
		"firmament from the waters which were above the firmament: and it was so. \n"
		"\n"
		"And God called the firmament Heaven. And the evening and the morning \n"
		"were the second day. \n"
		"\n"
		"And God said, Let the waters under the heaven be gathered together unto \n"
		"one place, and let the dry land appear: and it was so. \n"
		"\n"
		"And God called the dry land Earth; and the gathering together of the \n"
		"waters called he Seas: and God saw that it was good. \n"
		"\n"
		"And God said, Let the earth bring forth grass, the herb yielding seed, \n"
		"and the fruit tree yielding fruit after his kind, whose seed is in \n"
		"itself, upon the earth: and it was so. \n"
		"\n"
		"And the earth brought forth grass, and herb yielding seed after his \n"
		"kind, and the tree yielding fruit, whose seed was in itself, after his \n"
		"kind: and God saw that it was good. \n"
		"\n"
		"And the evening and the morning were the third day. \n"
		"\n"
		"And God said, Let there be lights in the firmament of the heaven to \n"
		"divide the day from the night; and let them be for signs, and for \n"
		"seasons, and for days, and years: \n"
		"\n"
		"And let them be for lights in the firmament of the heaven to give light \n"
		"upon the earth: and it was so. \n"
		"\n"
		"And God made two great lights; the greater light to rule the day, and \n"
		"the lesser light to rule the night: he made the stars also. \n"
		"\n"
		"And God set them in the firmament of the heaven to give light upon the \n"
		"earth, \n"
		"\n"
		"And to rule over the day and over the night, and to divide the light \n"
		"from the darkness: and God saw that it was good. \n"
		"\n"
		"And the evening and the morning were the fourth day. \n"
		"\n"
		"And God said, Let the waters bring forth abundantly the moving creature \n"
		"that hath life, and fowl that may fly above the earth in the open \n"
		"firmament of heaven. \n"
		"\n"
		"And God created great whales, and every living creature that moveth, \n"
		"which the waters brought forth abundantly, after their kind, and every \n"
		"winged fowl after his kind: and God saw that it was good. \n"
		"\n"
		"And God blessed them, saying, Be fruitful, and multiply, and fill the \n"
		"waters in the seas, and let fowl multiply in the earth. \n"
		"\n"
		"And the evening and the morning were the fifth day. \n"
		"\n"
		"And God said, Let the earth bring forth the living creature after his \n"
		"kind, cattle, and creeping thing, and beast of the earth after his kind: \n"
		"and it was so. \n"
		"\n"
		"And God made the beast of the earth after his kind, and cattle after \n"
		"their kind, and every thing that creepeth upon the earth after his kind: \n"
		"and God saw that it was good. \n"
		"\n"
		"And God said, Let us make man in our image, after our likeness: and let \n"
		"them have dominion over the fish of the sea, and over the fowl of the \n"
		"air, and over the cattle, and over all the earth, and over every \n"
		"creeping thing that creepeth upon the earth. \n"
		"\n"
		"So God created man in his own image, in the image of God created he him; \n"
		"male and female created he them. \n"
		"\n"
		"And God blessed them, and God said unto them, Be fruitful, and multiply, \n"
		"and replenish the earth, and subdue it: and have dominion over the fish \n"
		"of the sea, and over the fowl of the air, and over every living thing \n"
		"that moveth upon the earth. \n"
		"\n"
		"And God said, Behold, I have given you every herb bearing seed, which is \n"
		"upon the face of all the earth, and every tree, in the which is the \n"
		"fruit of a tree yielding seed; to you it shall be for meat. \n"
		"\n"
		"And to every beast of the earth, and to every fowl of the air, and to \n"
		"every thing that creepeth upon the earth, wherein there is life, I have \n"
		"given every green herb for meat: and it was so. \n"
		"\n"
		"And God saw every thing that he had made, and, behold, it was very good. \n"
		"And the evening and the morning were the sixth day. \n";

	size_t len = strlen(text);
	UT_string *s;

	// file_spew
	file_spew("test.txt", text);
	TEST_ASSERT(file_exists("test.txt"));
	TEST_ASSERT_EQUAL(len, file_size("test.txt"));

	s = file_slurp("test.txt");
	TEST_ASSERT_EQUAL(len, utstr_len(s));
	TEST_ASSERT_EQUAL_STRING(text, utstr_body(s));
	utstr_free(s);

	// file_spew_n
	file_spew_n("test.txt", text, strlen(text));
	TEST_ASSERT(file_exists("test.txt"));
	TEST_ASSERT_EQUAL(len, file_size("test.txt"));

	s = file_slurp("test.txt");
	TEST_ASSERT_EQUAL(len, utstr_len(s));
	TEST_ASSERT_EQUAL_STRING(text, utstr_body(s));
	utstr_free(s);

	// file_spew_str
	s = utstr_new_init(text);
	file_spew_str("test.txt", s);
	utstr_free(s);
	TEST_ASSERT(file_exists("test.txt"));
	TEST_ASSERT_EQUAL(len, file_size("test.txt"));

	s = file_slurp("test.txt");
	TEST_ASSERT_EQUAL(len, utstr_len(s));
	TEST_ASSERT_EQUAL_STRING(text, utstr_body(s));
	utstr_free(s);

	remove("test.txt");
	TEST_ASSERT(!file_exists("test.txt"));
	TEST_ASSERT_EQUAL(-1, file_size("test.txt"));
}

void t_fileutil_path_mkdir(void)
{
	path_rmdir("test_dir");
	TEST_ASSERT(!dir_exists("test_dir"));

	path_mkdir("test_dir/a/b");
	TEST_ASSERT(dir_exists("test_dir"));
	TEST_ASSERT(dir_exists("test_dir/a"));
	TEST_ASSERT(dir_exists("test_dir/a/b"));

	TEST_ASSERT(!file_exists("test_dir"));

	file_spew("test_dir/a/b/test.txt", "hello");
	TEST_ASSERT(file_exists("test_dir/a/b/test.txt"));

	path_rmdir("test_dir");
	TEST_ASSERT(!dir_exists("test_dir"));
}

void t_fileutil_path_search(void)
{
	path_rmdir("test_dir.x1");
	path_rmdir("test_dir.x2");
	path_rmdir("test_dir.x3");

	TEST_ASSERT(!dir_exists("test_dir.x1"));
	TEST_ASSERT(!dir_exists("test_dir.x2"));
	TEST_ASSERT(!dir_exists("test_dir.x3"));

	path_mkdir("test_dir.x1");
	path_mkdir("test_dir.x2");
	path_mkdir("test_dir.x3");

	TEST_ASSERT(dir_exists("test_dir.x1"));
	TEST_ASSERT(dir_exists("test_dir.x2"));
	TEST_ASSERT(dir_exists("test_dir.x3"));
		
	file_spew("test.f0", "");
	file_spew("test_dir.x1/test.f0", "");
	file_spew("test_dir.x1/test.f1", "");
	file_spew("test_dir.x2/test.f1", "");
	file_spew("test_dir.x2/test.f2", "");
	file_spew("test_dir.x3/test.f2", "");
	file_spew("test_dir.x3/test.f3", "");

	// NULL dir_list
	TEST_ASSERT_EQUAL_STRING("test.f0", path_search("test.f0", NULL));
	TEST_ASSERT_EQUAL_STRING("test.f1", path_search("test.f1", NULL));
	TEST_ASSERT_EQUAL_STRING("test.f2", path_search("test.f2", NULL));
	TEST_ASSERT_EQUAL_STRING("test.f3", path_search("test.f3", NULL));
	TEST_ASSERT_EQUAL_STRING("test.f4", path_search("test.f4", NULL));

	// empty dir_list
	argv_t *dirs = argv_new();
	TEST_ASSERT_EQUAL_STRING("test.f0", path_search("test.f0", dirs));
	TEST_ASSERT_EQUAL_STRING("test.f1", path_search("test.f1", dirs));
	TEST_ASSERT_EQUAL_STRING("test.f2", path_search("test.f2", dirs));
	TEST_ASSERT_EQUAL_STRING("test.f3", path_search("test.f3", dirs));
	TEST_ASSERT_EQUAL_STRING("test.f4", path_search("test.f4", dirs));

	// search path
	argv_push(dirs, "test_dir.x1");
	argv_push(dirs, "test_dir.x2");
	argv_push(dirs, "test_dir.x3");

	TEST_ASSERT_EQUAL_STRING("test.f0", path_search("test.f0", dirs));
	TEST_ASSERT_EQUAL_STRING("test_dir.x1/test.f1", path_search("test.f1", dirs));
	TEST_ASSERT_EQUAL_STRING("test_dir.x2/test.f2", path_search("test.f2", dirs));
	TEST_ASSERT_EQUAL_STRING("test_dir.x3/test.f3", path_search("test.f3", dirs));
	TEST_ASSERT_EQUAL_STRING("test.f4", path_search("test.f4", dirs));

	path_rmdir("test_dir.x1");
	path_rmdir("test_dir.x2");
	path_rmdir("test_dir.x3");

	TEST_ASSERT(!dir_exists("test_dir.x1"));
	TEST_ASSERT(!dir_exists("test_dir.x2"));
	TEST_ASSERT(!dir_exists("test_dir.x3"));
}

void t_fileutil_path_find_all(void)
{
	path_rmdir("test_dir");
	TEST_ASSERT(!dir_exists("test_dir"));

	path_mkdir("test_dir/x1");
	path_mkdir("test_dir/x2");
	path_mkdir("test_dir/x3");
	file_spew("test_dir/test.f0", "");
	file_spew("test_dir/x1/test.f0", "");
	file_spew("test_dir/x1/test.f1", "");
	file_spew("test_dir/x2/test.f1", "");
	file_spew("test_dir/x2/test.f2", "");
	file_spew("test_dir/x3/test.f2", "");
	file_spew("test_dir/x3/test.f3", "");
	TEST_ASSERT(dir_exists("test_dir"));

	argv_t *f = path_find_all("test_dir", false);
	argv_sort(f);
	char **p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/test.f0", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x3", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	f = path_find_files("test_dir", false);
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/test.f0", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	f = path_find_all("test_dir", true);
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/test.f0", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x1/test.f0", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x1/test.f1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x2/test.f1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x2/test.f2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x3", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x3/test.f2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x3/test.f3", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	f = path_find_files("test_dir", true);
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/test.f0", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x1/test.f0", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x1/test.f1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x2/test.f1", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x2/test.f2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x3/test.f2", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/x3/test.f3", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	path_rmdir("test_dir");
	TEST_ASSERT(!dir_exists("test_dir"));
}

void t_fileutil_path_find_glob(void)
{
	path_rmdir("test_dir");
	TEST_ASSERT(!dir_exists("test_dir"));

	int file = 0;
	UT_string *pad = utstr_new();
	for (int d1 = 'a'; d1 <= 'b'; d1++) {
		for (int d2 = '1'; d2 <= '2'; d2++) {
			utstr_set_fmt(pad, "test_dir/%c/%c", d1, d2); path_mkdir(utstr_body(pad));
			utstr_set_fmt(pad, "test_dir/%c/%c/d", d1, d2); path_mkdir(utstr_body(pad));

			utstr_set_fmt(pad, "test_dir/%c/%c/f%d.c", d1, d2, ++file); file_spew(utstr_body(pad), "");
			utstr_set_fmt(pad, "test_dir/%c/%c/f%d.c", d1, d2, ++file); file_spew(utstr_body(pad), "");
			utstr_set_fmt(pad, "test_dir/%c/%c/f%d.c", d1, d2, ++file); file_spew(utstr_body(pad), "");
		}
	}
	utstr_free(pad);

	// no wild card - file exists
	argv_t *f = path_find_glob("test_dir/a/1/f1.c");
	argv_sort(f);
	char **p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	// no wild card - file does not exist
	f = path_find_glob("test_dir/a/1/g1.c");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	// wildcard in file component
	f = path_find_glob("test_dir/a/1/f?.c");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f2.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f3.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	f = path_find_glob("test_dir/a/1/*.c");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f2.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f3.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	f = path_find_glob("test_dir/a/1/**");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f2.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f3.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	// wildcard in path
	f = path_find_glob("test_dir/*/*/f?.c");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f2.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f3.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f4.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f5.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f6.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f7.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f8.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f9.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);
	
	// recursive glob
	f = path_find_glob("test_dir/**/f?.c");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f2.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f3.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f4.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f5.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f6.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f7.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f8.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f9.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	f = path_find_glob("test_dir/**");
	argv_sort(f);
	p = argv_front(f);
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f1.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f2.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/1/f3.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f4.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f5.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/a/2/f6.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f7.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f8.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/1/f9.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/2/f10.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/2/f11.c", *p); p++;
	TEST_ASSERT_EQUAL_STRING("test_dir/b/2/f12.c", *p); p++;
	TEST_ASSERT_NULL(*p);
	argv_free(f);

	path_rmdir("test_dir");
	TEST_ASSERT(!dir_exists("test_dir"));
}
