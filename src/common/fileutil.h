//-----------------------------------------------------------------------------
// file utilities
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "strutil.h"
#include "types.h"
#include "utstring.h"
#include <stdio.h>
#include <stdlib.h>

// pathname manipulation - strings are allocated in spool, no need to free

// change to forward slashes, remove extra slashes and dots
extern const char *path_canon(const char *path);

// same as path_canon but with back-slashes on windows and forward slashes everywhere else
extern const char *path_os(const char *path);

// combine two paths "a","b" -> "a/b"
extern const char *path_combine(const char *path1, const char *path2);

// extract path components
extern const char *path_dir(const char *path);
extern const char *path_file(const char *path);
extern const char *path_ext(const char *path);

// manipulate extension
extern const char *path_remove_ext(const char *path);
extern const char *path_replace_ext(const char *path, const char *new_ext);

// file IO, die if error
// maps internally FILE* -> fileno -> filename for error messages
extern FILE *xfopen(const char *filename, const char *mode);
extern void xfclose(FILE *stream);
extern void xfclose_remove_empty(FILE *stream);

// dies if error writing all elements
extern void xfwrite(const void *ptr, size_t size, size_t count, FILE *stream);
extern void xfwrite_cstr(const char *str, FILE *stream);
extern void xfwrite_str(UT_string *str, FILE *stream);
extern void xfwrite_bytes(const void *ptr, size_t count, FILE *stream);

// byte/word length followed by string
extern void xfwrite_bcount_bytes(const void *str, size_t count, FILE *stream);
extern void xfwrite_bcount_cstr(const char *str, FILE *stream);
extern void xfwrite_bcount_str(UT_string *str, FILE *stream);

extern void xfwrite_wcount_bytes(const void *str, size_t count, FILE *stream);
extern void xfwrite_wcount_cstr(const char *str, FILE *stream);
extern void xfwrite_wcount_str(UT_string *str, FILE *stream);

extern void xfwrite_byte(byte_t value, FILE *stream);
extern void xfwrite_word(word_t value, FILE *stream);
extern void xfwrite_dword(int value, FILE *stream);

// dies if cannot read all expected elements; use fread() if this is expected
extern void xfread(void *ptr, size_t size, size_t count, FILE *stream);
extern void xfread_str(size_t size, UT_string *str, FILE *stream);
extern void xfread_bytes(void *ptr, size_t count, FILE *stream);

// byte/word length followed by string
extern void xfread_bcount_str(UT_string *str, FILE *stream);
extern void xfread_wcount_str(UT_string *str, FILE *stream);

extern byte_t xfread_byte(FILE *stream);
extern word_t xfread_word(FILE *stream);
extern int xfread_dword(FILE *stream);

// dies if fseek() fails
extern void xfseek(FILE *stream, long offset, int origin);

// write and read files in one go; die on error
extern void file_spew(const char *filename, const char *text);
extern void file_spew_n(const char *filename, const char *text, size_t size);
extern void file_spew_str(const char *filename, UT_string *str);

extern UT_string *file_slurp(const char *filename);			// user must free UT_string

// list files in directories, user must free argv_t
extern argv_t *path_find_all(const char *dirname, bool recursive);
extern argv_t *path_find_files(const char *dirname, bool recursive);
extern argv_t *path_find_glob(const char *pattern);

// create/remve a directory and all parents above/children below it
extern void path_mkdir(const char *path);
extern void path_rmdir(const char *path);

// check if file/directory exist
extern bool file_exists(const char *filename);
extern bool dir_exists(const char *dirname);
extern long file_size(const char *filename);		// -1 if not regular file

// search for a file on the given directory list, return full path name in strin pool
extern const char *path_search(const char *filename, argv_t *dir_list);
