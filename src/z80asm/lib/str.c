/*
Z88DK Z80 Macro Assembler

Dynamic strings based on vector.c

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "str.h"
#include <ctype.h>
#include <string.h>

/*-----------------------------------------------------------------------------
*   Utilities working on char *
*----------------------------------------------------------------------------*/

char *stoupper(char *str)
{
	char *p;

	for (p = str; *p; p++)
		*p = toupper(*p);

	return str;
}

char *stolower(char *str)
{
	char *p;

	for (p = str; *p; p++)
		*p = tolower(*p);

	return str;
}

int stricompare(char *s1, char *s2)
{
	if (s1 == s2)   return 0;
	if (s1 == NULL) return -1;
	if (s2 == NULL)	return 1;
	while (*s2 != '\0' && tolower(*s1) == tolower(*s2)) {
		s1++; s2++;
	}
	return (int)(tolower(*s1) - tolower(*s2));
}

int strnicompare(char *s1, char *s2, size_t n)
{
	char c1, c2;

	if (s1 == s2)   return 0;
	if (s1 == NULL) return -1;
	if (s2 == NULL)	return 1;
	if (n == 0)		return 0;
	do {
		c1 = tolower(*s1++);
		c2 = tolower(*s2++);
		n--;
	} while ((c1 != '\0') && (c1 == c2) && (n > 0));

	return (int)(c1 - c2);
}

char *chomp(char *str)
{
	char *p;

	p = str + strlen(str) - 1;	/* point at last char */

	while (p >= str && isspace(*p))
	{
		*p = '\0';
		p--;
	}

	return str;
}

char *strip(char *str)
{
	char *p;

	/* remove start spaces */
	p = str;

	while (*p != '\0' && isspace(*p))
		p++;

	memmove(str, p, strlen(p) + 1);	/* copy also '\0' */

	/* remove end spaces */
	return chomp(str);
}

static int char_digit(char c)
{
	if (isdigit(c)) return c - '0';
	if (isxdigit(c)) return 10 + toupper(c) - 'A';
	return -1;
}

/* convert C-escape sequences - modify in place, return final length
   to allow strings with '\0' characters
   Accepts \a, \b, \e, \f, \n, \r, \t, \v, \xhh, \{any} \ooo
   code borrowed from GLib */
int compress_escapes(char *str)
{
	char *p, *q, *num;
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

/*-----------------------------------------------------------------------------
*   initialize and delete
*----------------------------------------------------------------------------*/

static void str_remove_data(Str *str)
{
	if (str && str->flag.data_alloc)
		m_free(str->data);
	str->data = NULL;
	str->flag.data_alloc = FALSE;
}

Str *Str_new_(int size)
{
	Str *str;

	check(size > 1, "size=%d", size);

	str = m_new(Str);
	m_set_destructor(str, (destructor_t) str_remove_data);

	str->data = m_malloc(size);
	m_set_in_collection(str->data);
	str->size = size;

	str->flag.data_alloc = TRUE;
	str->flag.header_alloc = TRUE;

	Str_clear(str);

	return str;
error:
	return NULL;
}

void Str_delete_(Str *str)
{
	if (str) {
		str_remove_data(str);
		if (str->flag.header_alloc)
			m_free(str);
	}
}

/* expand string buffer if needed */
void Str_reserve(Str *str, int size)
{
	char *new_data;
	int   new_size;

	check_node(str);

	if (str->len + size + 1 > str->size) {
		new_size = (1 + ((str->len + size + 1) / STR_SIZE)) * STR_SIZE;

		if (str->flag.data_alloc) {
			str->data = m_realloc(str->data, new_size);
		}
		else {								/* points to char[], need to copy to heap */
			new_data = m_malloc(new_size);
			m_destroy_atexit(new_data);		/* no need to free explicitly */

			memcpy(new_data, str->data, str->size);
			str->data = new_data;

			str->flag.data_alloc = TRUE;
		}
		str->size = new_size;
	}
error:;
}

/*-----------------------------------------------------------------------------
*   Set strings
*----------------------------------------------------------------------------*/

/* clear the string, keep allocated space */
void Str_clear(Str *str)
{
	str->len = 0;
	str->data[0] = '\0';
}

/* sync length in case string was modified in place */
void Str_sync_len(Str *str)
{
	str->len = strlen(str->data);
}

/* set / append bytes */
void Str_set_bytes(Str *str, char *source, int size)
{
	Str_clear(str);
	Str_append_bytes(str, source, size);
}

void Str_append_bytes(Str *str, char *source, int size)
{
	/* expand string if needed */
	Str_reserve(str, size);

	/* copy buffer and add null terminator */
	memcpy(str->data + str->len, source, size);
	str->len += size;
	str->data[str->len] = '\0';					/* add zero terminator */
}

/* set / append string */
void Str_set(Str *str, char *source)
{
	Str_clear(str);
	Str_append(str, source);
}

void Str_append(Str *str, char *source)
{
	Str_append_bytes(str, source, strlen(source));
}

/* set / append substring */
void Str_set_n(Str *str, char *source, int count)
{
	Str_clear(str);
	Str_append_n(str, source, count);
}

void Str_append_n(Str *str, char *source, int count)
{
	int num_copy = strlen(source);

	Str_append_bytes(str, source, MIN(count, num_copy));
}

/* set / append char */
void Str_set_char(Str *str, char ch)
{
	Str_clear(str);
	Str_append_char(str, ch);
}

void Str_append_char(Str *str, char ch)
{
	/* expand string if needed */
	Str_reserve(str, 1);

	/* add bytes */
	str->data[str->len++] = ch;
	str->data[str->len] = '\0';
}

/* set / append with va_list argument */
void Str_vsprintf(Str *str, char *format, va_list argptr)
{
	Str_clear(str);
	Str_append_vsprintf(str, format, argptr);
}

void Str_append_vsprintf(Str *str, char *format, va_list argptr)
{
	int free_space;      /* may be negative */
	int need_space;
	va_list savearg;	/* save argptr before new invocations of vsnprintf */
	Bool ok;

	va_copy(savearg, argptr);
	do
	{
		/* NOTE: Linux vsnprintf always terminates string; Win32 only if there is enough space */
		free_space = str->size - str->len;

		if (free_space > 0)
			need_space = vsnprintf(str->data + str->len, free_space, format, argptr);
		else
			need_space = -1;

		/* printed OK? */
		ok = need_space >= 0 && need_space < free_space;

		if (ok)
		{
			str->len += need_space;
			str->data[str->len] = '\0';	/* string may not be terminated */
		}
		else
		{
			/* increase the size by STR_SIZE and retry */
			Str_reserve(str, str->size - str->len);
			va_copy(argptr, savearg);
		}
	} while (!ok);
}

/* set / append with printf-like parameters */
void Str_sprintf(Str *str, char *format, ...)
{
	va_list argptr;

	va_start(argptr, format);
	Str_vsprintf(str, format, argptr);
	va_end(argptr);
}

void Str_append_sprintf(Str *str, char *format, ...)
{
	va_list argptr;

	va_start(argptr, format);
	Str_append_vsprintf(str, format, argptr);
	va_end(argptr);
}

/*-----------------------------------------------------------------------------
*   Modify strings
*----------------------------------------------------------------------------*/

/* tolower, toupper, chomp, strip, compress_escapes */
void Str_toupper(Str *str)
{
	stoupper(str->data);
}

void Str_tolower(Str *str)
{
	stolower(str->data);
}

void Str_chomp(Str *str)
{
	chomp(str->data);
	Str_sync_len(str);
}

void Str_strip(Str *str)
{
	strip(str->data);
	Str_sync_len(str);
}

void Str_compress_escapes(Str *str)
{
	/* no Str_sync_len() as string may have '\0' */
	str->len = compress_escapes(str->data);
}

/* get one line from input, convert end-of-line sequences,
*  return string including one LF character
*  return FALSE on end of input */
Bool Str_getline(Str *str, FILE *fp)
{
	int c1, c2;

	Str_clear(str);

	while ((c1 = getc(fp)) != EOF && c1 != '\n' && c1 != '\r')
		Str_append_char(str, c1);

	if (c1 == EOF)
	{
		if (str->len > 0)				/* read some chars */
			Str_append_char(str, '\n');		/* missing newline at end of line */
	}
	else
	{
		Str_append_char(str, '\n');			/* end of line */

		if ((c2 = getc(fp)) != EOF &&
			!((c1 == '\n' && c2 == '\r') ||
			  (c1 == '\r' && c2 == '\n')))
		{
			ungetc(c2, fp);					/* push back to input */
		}
	}

	return str->len > 0 ? TRUE : FALSE;
}
