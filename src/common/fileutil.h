//-----------------------------------------------------------------------------
// file utilities
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "strutil.h"
#include "types.h"
#include <stdio.h>
#include <stdlib.h>

// pathname manipulation - strings are allocated in spool, no need to free

// change to forward slashes, remove extra slashes and dots
extern const char *path_canon(const char *path);

// same as path_canon but with back-slashes on windows and forward slashes everywhere else
extern const char *path_os(const char *path);

// combine two paths "a","b" -> "a/b"
extern const char *path_combine(const char *path1, const char *path2);

// remove file extension
extern const char *path_remove_ext(const char *path);

// replace file extension
extern const char *path_replace_ext(const char *path, const char *new_ext);

// extract directory
extern const char *path_dirname(const char *path);

// extract file name
extern const char *path_filename(const char *path);

// file IO, die if error
// maps internally FILE* -> fileno -> filename for error messages
extern FILE *xfopen(const char *filename, const char *mode);
extern void xfclose(FILE *stream);
extern void xfclose_remove_empty(FILE *stream);

// dies if error writing all elements
extern void xfwrite(const void *ptr, size_t size, size_t count, FILE *stream);
extern void xfwrite_cstr(const char *str, FILE *stream);
extern void xfwrite_str(str_t *str, FILE *stream);
extern void xfwrite_bytes(const void *ptr, size_t count, FILE *stream);

// byte/word length followed by string
extern void xfwrite_bcount_bytes(const void *str, size_t count, FILE *stream);
extern void xfwrite_bcount_cstr(const char *str, FILE *stream);
extern void xfwrite_bcount_str(str_t *str, FILE *stream);

extern void xfwrite_wcount_bytes(const void *str, size_t count, FILE *stream);
extern void xfwrite_wcount_cstr(const char *str, FILE *stream);
extern void xfwrite_wcount_str(str_t *str, FILE *stream);

extern void xfwrite_byte(byte_t value, FILE *stream);
extern void xfwrite_word(word_t value, FILE *stream);
extern void xfwrite_dword(int value, FILE *stream);

// dies if cannot read all expected elements; use fread() if this is expected
extern void xfread(void *ptr, size_t size, size_t count, FILE *stream);
extern void xfread_str(size_t size, str_t *str, FILE *stream);
extern void xfread_bytes(void *ptr, size_t count, FILE *stream);

// byte/word length followed by string
extern void xfread_bcount_str(str_t *str, FILE *stream);
extern void xfread_wcount_str(str_t *str, FILE *stream);

extern byte_t xfread_byte(FILE *stream);
extern word_t xfread_word(FILE *stream);
extern int xfread_dword(FILE *stream);

// dies if fseek() fails
extern void xfseek(FILE *stream, long offset, int origin);
