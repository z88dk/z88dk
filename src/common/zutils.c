//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2023
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
