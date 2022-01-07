//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------

#include "zutils.h"
#include "die.h"
#include <ctype.h>
#include <stdarg.h>

char* strtoupper(char* str) {
	for (char* p = str; *p; p++) *p = toupper(*p);
	return str;
}

char* strtolower(char* str) {
	for (char* p = str; *p; p++) *p = tolower(*p);
	return str;
}

char* strchomp(char* str) {
	for (char* p = str + strlen(str) - 1; p >= str && isspace(*p); p--) *p = '\0';
	return str;
}

char* strstrip(char* str) {
	char* p;
	for (p = str; *p != '\0' && isspace(*p); p++) {}// skip begining spaces
	memmove(str, p, strlen(p) + 1);					// move also '\0'
	return strchomp(str);							// remove ending spaces	
}

static int char_digit(char c) {
	if (isdigit(c)) return c - '0';
	if (isxdigit(c)) return 10 + toupper(c) - 'A';
	return -1;
}

/* convert C-escape sequences - modify in place, return final length
to allow strings with '\0' characters
Accepts \a, \b, \e, \f, \n, \r, \t, \v, \xhh, \{any} \ooo
code borrowed from GLib */
size_t str_compress_escapes(char* str) {
	char* p = NULL, * q = NULL, * num = NULL;
	int base = 0, max_digits, digit;

	for (p = q = str; *p; p++)
	{
		if (*p == '\\')
		{
			p++;
			base = 0;							/* decision octal/hex */
			switch (*p)
			{
			case '\0':	p--; break;				/* trailing backslash - ignore */
			case 'a':	*q++ = '\a'; break;
			case 'b':	*q++ = '\b'; break;
			case 'e':	*q++ = '\x1B'; break;
			case 'f':	*q++ = '\f'; break;
			case 'n':	*q++ = '\n'; break;
			case 'r':	*q++ = '\r'; break;
			case 't':	*q++ = '\t'; break;
			case 'v':	*q++ = '\v'; break;
			case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7':
				num = p;				/* start of number */
				base = 8;
				max_digits = 3;
				/* fall through */
			case 'x':
				if (base == 0)		/* not octal */
				{
					num = ++p;
					base = 16;
					max_digits = 2;
				}
				/* convert octal or hex number */
				*q = 0;
				while (p < num + max_digits &&
					(digit = char_digit(*p)) >= 0 &&
					digit < base)
				{
					*q = *q * base + digit;
					p++;
				}
				p--;
				q++;
				break;
			default:	*q++ = *p;		/* any other char */
			}
		}
		else
		{
			*q++ = *p;
		}
	}
	*q = '\0';

	return q - str;
}


// UT_string

UT_string* utstr_new(void) {
	UT_string* str;
	utstring_new(str);
	return str;
}

UT_string* utstr_new_init(const char* src) {
	UT_string* str = utstr_new();
	utstr_append(str, src);
	return str;
}

bool utstr_fgets(UT_string* str, FILE* fp) {
	int c1, c2;
	utstr_clear(str);
	utstr_reserve(str, BUFSIZ);

	while ((c1 = getc(fp)) != EOF && c1 != '\n' && c1 != '\r')
		utstr_append_fmt(str, "%c", c1);
	if (c1 == EOF) {
		if (utstr_len(str) > 0)
			utstr_append(str, "\n");		// add missing newline
	}
	else {
		utstr_append(str, "\n");			// add end of line
		if (c1 == '\r' && (c2 = getc(fp)) != EOF && c2 != '\n')
			ungetc(c2, fp);					// push back to input
	}
	return utstr_len(str) > 0 ? true : false;
}

// utstring_reserve(x) allocates 100+x and does not take space for '\0' into account
// rewrite
void utstr_reserve(UT_string* str, size_t amt) {
	size_t new_size = str->i + amt + 1;		// space for null char
	if (new_size > str->n) {
		str->d = xrealloc(str->d, new_size);
		str->n = new_size;
	}
	str->d[str->n - 1] = '\0';
}

void utstr_set(UT_string* dst, const char* src) {
	utstr_set_n(dst, src, strlen(src));
}

void utstr_set_n(UT_string* dst, const char* src, size_t n) {
	utstr_clear(dst);
	utstr_append_n(dst, src, n);
}

void utstr_set_fmt(UT_string* str, const char* fmt, ...) {
	utstr_clear(str);
	va_list ap;
	va_start(ap, fmt);
	utstring_printf_va(str, fmt, ap);
	va_end(ap);
}

void utstr_set_str(UT_string* str, UT_string* src) {
	utstr_clear(str);
	utstr_append_str(str, src);
}

void utstr_toupper(UT_string* str) {
	strtoupper(utstr_body(str));
}

void utstr_tolower(UT_string* str) {
	strtolower(utstr_body(str));
}

void utstr_chomp(UT_string* str) {
	strchomp(utstr_body(str));
	utstr_sync_len(str);
}

void utstr_strip(UT_string* str) {
	strstrip(utstr_body(str));
	utstr_sync_len(str);
}

void utstr_compress_escapes(UT_string* str) {
	size_t len= str_compress_escapes(utstr_body(str));
	utstr_len(str) = len;
}
