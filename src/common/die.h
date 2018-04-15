//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "utstring.h"
#include <stdio.h>
#include <stdlib.h>

typedef unsigned char byte_t;

// error message and exit program
extern void die(char *msg, ...);

// check alloc result, die if error
extern void *check_alloc(void *p);
#define Check_alloc(type, p)	((type)(p))

#define xmalloc(size)		check_alloc(malloc(size))
#define xcalloc(count,size)	check_alloc(calloc((cout), (size)))
#define xrealloc(p,size)	check_alloc(realloc((p), (size)))
#define xfree(p)			(free(p), (p) = NULL)
#define xstrdup(s)			Check_alloc(char*, strdup(s))

#define xnew(type)			Check_alloc(type*, calloc(1, sizeof(type)))

// file IO, die if error
// maps internally FILE* -> fileno -> filename for error messages
extern FILE *xfopen(const char *filename, const char *mode);
extern void xfclose(FILE *stream);

// dies if error writing all elements
extern void xfwrite(const void *ptr, size_t size, size_t count, FILE *stream);
extern void xfwrite_str(UT_string *str, FILE *stream);

// byte/word length followed by string
extern void xfwrite_bcount_str(UT_string *str, FILE *stream);
extern void xfwrite_wcount_str(UT_string *str, FILE *stream);

extern void xfwrite_byte(byte_t value, FILE *stream);
extern void xfwrite_word(int value, FILE *stream);
extern void xfwrite_dword(int value, FILE *stream);

// dies if cannot read all expected elements; use fread() if this is expected
extern void xfread(void *ptr, size_t size, size_t count, FILE *stream);
extern void xfread_str(size_t size, UT_string *str, FILE *stream);

// byte/word length followed by string
extern void xfread_bcount_str(UT_string *str, FILE *stream);
extern void xfread_wcount_str(UT_string *str, FILE *stream);

extern byte_t xfread_byte(FILE *stream);
extern int xfread_word(FILE *stream);
extern int xfread_dword(FILE *stream);

// dies if fseek() fails
extern void xfseek(FILE *stream, long offset, int origin);
