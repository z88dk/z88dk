//-----------------------------------------------------------------------------
// file utilities
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "fileutil.h"
#include "die.h"
#include "utarray.h"
#include <assert.h>

//-----------------------------------------------------------------------------
// map fileno(FLIE*) to filename in this session
//-----------------------------------------------------------------------------
static UT_array *open_files = NULL;		// array indexed by fileno(fp)

static void add_open_file(FILE *stream, const char *filename);
static void deinit(void);

static void init()
{
	static bool inited = false;
	if (!inited) {
		inited = true;
		atexit(deinit);
		utarray_new(open_files, &ut_str_icd);
		add_open_file(stdin, "<stdin>");
		add_open_file(stdout, "<stdout>");
		add_open_file(stderr, "<stderr>");
	}
}

static void deinit(void)
{
	utarray_free(open_files);
}

static void add_open_file(FILE *stream, const char *filename)
{
	init();
	assert(stream);
	size_t fno = fileno(stream);
	if (fno >= utarray_len(open_files))
		utarray_resize(open_files, fno + 1);
	free(*(char**)utarray_eltptr(open_files, fno));
	*(char**)utarray_eltptr(open_files, fno) = xstrdup(filename);
}

static char *get_filename(FILE *fp)
{
	init();
	size_t fno = fp ? fileno(fp) : -1;
	if (fno >= utarray_len(open_files))
		return "?";
	else
		return *(char**)utarray_eltptr(open_files, fno);
}

//-----------------------------------------------------------------------------
// file IO
//-----------------------------------------------------------------------------
FILE *xfopen(const char *filename, const char *mode)
{
	FILE *stream = fopen(filename, mode);
	if (!stream) {
		perror(filename);
		exit(EXIT_FAILURE);
	}
	add_open_file(stream, filename);
	return stream;
}

void xfclose(FILE *stream)
{
	int rv = fclose(stream);
	if (rv != 0)
		die("file '%s' close failed\n", get_filename(stream));
}

void xfclose_remove_empty(FILE *stream)
{
	char *filename = get_filename(stream);

	xfseek(stream, 0, SEEK_END);
	long size = ftell(stream);
	xfclose(stream);

	if (size == 0 && filename != NULL)
		remove(filename);
}

void xfwrite(const void *ptr, size_t size, size_t count, FILE *stream)
{
	size_t num = fwrite(ptr, size, count, stream);
	if (num != count)
		die("failed to write %u bytes to file '%s'\n", size*count, get_filename(stream));
}

void xfwrite_cstr(const char *str, FILE *stream)
{
	xfwrite_bytes(str, strlen(str), stream);
}

void xfwrite_str(str_t *str, FILE *stream)
{
	xfwrite_bytes(str_data(str), str_len(str), stream);
}

void xfwrite_bytes(const void *ptr, size_t count, FILE *stream)
{
	xfwrite(ptr, sizeof(byte_t), count, stream);
}

void xfwrite_bcount_str(str_t *str, FILE *stream)
{
	size_t len = str_len(str);
	if (len > 255)
		die("string '%.40s...' too long for byte counted string\n", str_data(str));
	xfwrite_byte(len & 0xFF, stream);
	xfwrite_str(str, stream);
}

void xfwrite_wcount_str(str_t * str, FILE * stream)
{
	size_t len = str_len(str);
	if (len > 0xFFFF)
		die("string '%.40s...' too long for word counted string\n", str_data(str));
	xfwrite_word(len, stream);
	xfwrite_str(str, stream);
}

void xfwrite_byte(byte_t value, FILE *stream)
{
	xfwrite_bytes(&value, 1, stream);
}

void xfwrite_word(int value, FILE *stream)
{
	byte_t word[2];
	word[0] = value & 0xFF; value >>= 8;
	word[1] = value & 0xFF; value >>= 8;
	xfwrite_bytes(word, sizeof(word), stream);
}

void xfwrite_dword(int value, FILE *stream)
{
	byte_t dword[4];
	dword[0] = value & 0xFF; value >>= 8;
	dword[1] = value & 0xFF; value >>= 8;
	dword[2] = value & 0xFF; value >>= 8;
	dword[3] = value & 0xFF; value >>= 8;
	xfwrite_bytes(dword, sizeof(dword), stream);
}

void xfread(void *ptr, size_t size, size_t count, FILE *stream)
{
	size_t num = fread(ptr, size, count, stream);
	if (num != count)
		die("failed to read %u bytes from file '%s'\n", size*count, get_filename(stream));
}

void xfread_str(size_t size, str_t *str, FILE *stream)
{
	str_reserve(str, size);
	xfread(str_data(str), sizeof(char), size, stream);
	str_len(str) = size;
	str_data(str)[str_len(str)] = '\0';
}

void xfread_bytes(void *ptr, size_t count, FILE *stream)
{
	xfread(ptr, sizeof(byte_t), count, stream);
}

void xfread_bcount_str(str_t *str, FILE *stream)
{
	size_t len = xfread_byte(stream);
	xfread_str(len, str, stream);
}

void xfread_wcount_str(str_t * str, FILE * stream)
{
	size_t len = xfread_word(stream);
	xfread_str(len, str, stream);
}

byte_t xfread_byte(FILE *stream)
{
	byte_t value;
	xfread(&value, sizeof(byte_t), 1, stream);
	return value;
}

word_t xfread_word(FILE * stream)
{
	byte_t word[2];
	xfread(word, sizeof(byte_t), sizeof(word), stream);
	int value =
		((word[0] << 0) & 0x00FF) |
		((word[1] << 8) & 0xFF00);
	if (value & 0x8000)
		value |= ~0xFFFF;			// sign-extend above bit 15

	return value;
}

int xfread_dword(FILE * stream)
{
	byte_t dword[4];
	xfread(dword, sizeof(byte_t), sizeof(dword), stream);
	int value =
		((dword[0] << 0) & 0x000000FFL) |
		((dword[1] << 8) & 0x0000FF00L) |
		((dword[2] << 16) & 0x00FF0000L) |
		((dword[3] << 24) & 0xFF000000L);
	if (value & 0x80000000L)
		value |= ~0xFFFFFFFFL;		// sign-extend above bit 31

	return value;
}

void xfseek(FILE *stream, long offset, int origin)
{
	if (fseek(stream, offset, origin) != 0)
		die("failed to seek to %ld in file '%s'\n", offset, get_filename(stream));
}
