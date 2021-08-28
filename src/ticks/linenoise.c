#ifndef STRINGBUF_H
#define STRINGBUF_H
/**
 * resizable string buffer
 *
 * (c) 2017-2020 Steve Bennett <steveb@workware.net.au>
 *
 * See utf8.c for licence details.
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @file
 * A stringbuf is a resizing, null terminated string buffer.
 *
 * The buffer is reallocated as necessary.
 *
 * In general it is *not* OK to call these functions with a NULL pointer
 * unless stated otherwise.
 *
 * If USE_UTF8 is defined, supports utf8.
 */

/**
 * The stringbuf structure should not be accessed directly.
 * Use the functions below.
 */
typedef struct {
	int remaining;	/**< Allocated, but unused space */
	int last;		/**< Index of the null terminator (and thus the length of the string) */
#ifdef USE_UTF8
	int chars;		/**< Count of characters */
#endif
	char *data;		/**< Allocated memory containing the string or NULL for empty */
} stringbuf;

/**
 * Allocates and returns a new stringbuf with no elements.
 */
stringbuf *sb_alloc(void);

/**
 * Frees a stringbuf.
 * It is OK to call this with NULL.
 */
void sb_free(stringbuf *sb);

/**
 * Returns an allocated copy of the stringbuf
 */
stringbuf *sb_copy(stringbuf *sb);

/**
 * Returns the byte length of the buffer.
 * 
 * Returns 0 for both a NULL buffer and an empty buffer.
 */
static inline int sb_len(stringbuf *sb) {
	return sb->last;
}

/**
 * Returns the utf8 character length of the buffer.
 * 
 * Returns 0 for both a NULL buffer and an empty buffer.
 */
static inline int sb_chars(stringbuf *sb) {
#ifdef USE_UTF8
	return sb->chars;
#else
	return sb->last;
#endif
}

/**
 * Appends a null terminated string to the stringbuf
 */
void sb_append(stringbuf *sb, const char *str);

/**
 * Like sb_append() except does not require a null terminated string.
 * The length of 'str' is given as 'len'
 *
 * Note that in utf8 mode, characters will *not* be counted correctly
 * if a partial utf8 sequence is added with sb_append_len()
 */
void sb_append_len(stringbuf *sb, const char *str, int len);

/**
 * Returns a pointer to the null terminated string in the buffer.
 *
 * Note this pointer only remains valid until the next modification to the
 * string buffer.
 *
 * The returned pointer can be used to update the buffer in-place
 * as long as care is taken to not overwrite the end of the buffer.
 */
static inline char *sb_str(const stringbuf *sb)
{
	return sb->data;
}

/**
 * Inserts the given string *before* (zero-based) byte 'index' in the stringbuf.
 * If index is past the end of the buffer, the string is appended,
 * just like sb_append()
 */
void sb_insert(stringbuf *sb, int index, const char *str);

/**
 * Delete 'len' bytes in the string at the given index.
 *
 * Any bytes past the end of the buffer are ignored.
 * The buffer remains null terminated.
 *
 * If len is -1, deletes to the end of the buffer.
 */
void sb_delete(stringbuf *sb, int index, int len);

/**
 * Clear to an empty buffer.
 */
void sb_clear(stringbuf *sb);

/**
 * Return an allocated copy of buffer and frees 'sb'.
 *
 * If 'sb' is empty, returns an allocated copy of "".
 */
char *sb_to_string(stringbuf *sb);

#ifdef __cplusplus
}
#endif

#endif
/**
 * resizable string buffer
 *
 * (c) 2017-2020 Steve Bennett <steveb@workware.net.au>
 *
 * See utf8.c for licence details.
 */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <assert.h>

#ifndef STRINGBUF_H
#include "stringbuf.h"
#endif
#ifdef USE_UTF8
#include "utf8.h"
#endif

#define SB_INCREMENT 200

stringbuf *sb_alloc(void)
{
	stringbuf *sb = (stringbuf *)malloc(sizeof(*sb));
	sb->remaining = 0;
	sb->last = 0;
#ifdef USE_UTF8
	sb->chars = 0;
#endif
	sb->data = NULL;

	return(sb);
}

void sb_free(stringbuf *sb)
{
	if (sb) {
		free(sb->data);
	}
	free(sb);
}

void sb_realloc(stringbuf *sb, int newlen)
{
	sb->data = (char *)realloc(sb->data, newlen);
	sb->remaining = newlen - sb->last;
}

void sb_append(stringbuf *sb, const char *str)
{
	sb_append_len(sb, str, strlen(str));
}

void sb_append_len(stringbuf *sb, const char *str, int len)
{
	if (sb->remaining < len + 1) {
		sb_realloc(sb, sb->last + len + 1 + SB_INCREMENT);
	}
	memcpy(sb->data + sb->last, str, len);
	sb->data[sb->last + len] = 0;

	sb->last += len;
	sb->remaining -= len;
#ifdef USE_UTF8
	sb->chars += utf8_strlen(str, len);
#endif
}

char *sb_to_string(stringbuf *sb)
{
	if (sb->data == NULL) {
		/* Return an allocated empty string, not null */
		return strdup("");
	}
	else {
		/* Just return the data and free the stringbuf structure */
		char *pt = sb->data;
		free(sb);
		return pt;
	}
}

/* Insert and delete operations */

/* Moves up all the data at position 'pos' and beyond by 'len' bytes
 * to make room for new data
 *
 * Note: Does *not* update sb->chars
 */
static void sb_insert_space(stringbuf *sb, int pos, int len)
{
	assert(pos <= sb->last);

	/* Make sure there is enough space */
	if (sb->remaining < len) {
		sb_realloc(sb, sb->last + len + SB_INCREMENT);
	}
	/* Now move it up */
	memmove(sb->data + pos + len, sb->data + pos, sb->last - pos);
	sb->last += len;
	sb->remaining -= len;
	/* And null terminate */
	sb->data[sb->last] = 0;
}

/**
 * Move down all the data from pos + len, effectively
 * deleting the data at position 'pos' of length 'len'
 */
static void sb_delete_space(stringbuf *sb, int pos, int len)
{
	assert(pos < sb->last);
	assert(pos + len <= sb->last);

#ifdef USE_UTF8
	sb->chars -= utf8_strlen(sb->data + pos, len);
#endif

	/* Now move it up */
	memmove(sb->data + pos, sb->data + pos + len, sb->last - pos - len);
	sb->last -= len;
	sb->remaining += len;
	/* And null terminate */
	sb->data[sb->last] = 0;
}

void sb_insert(stringbuf *sb, int index, const char *str)
{
	if (index >= sb->last) {
		/* Inserting after the end of the list appends. */
		sb_append(sb, str);
	}
	else {
		int len = strlen(str);

		sb_insert_space(sb, index, len);
		memcpy(sb->data + index, str, len);
#ifdef USE_UTF8
		sb->chars += utf8_strlen(str, len);
#endif
	}
}

/**
 * Delete the bytes at index 'index' for length 'len'
 * Has no effect if the index is past the end of the list.
 */
void sb_delete(stringbuf *sb, int index, int len)
{
	if (index < sb->last) {
		char *pos = sb->data + index;
		if (len < 0) {
			len = sb->last;
		}

		sb_delete_space(sb, pos - sb->data, len);
	}
}

void sb_clear(stringbuf *sb)
{
	if (sb->data) {
		/* Null terminate */
		sb->data[0] = 0;
		sb->last = 0;
#ifdef USE_UTF8
		sb->chars = 0;
#endif
	}
}
#ifndef UTF8_UTIL_H
#define UTF8_UTIL_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * UTF-8 utility functions
 *
 * (c) 2010-2019 Steve Bennett <steveb@workware.net.au>
 *
 * See utf8.c for licence details.
 */

#ifndef USE_UTF8
#include <ctype.h>

#define MAX_UTF8_LEN 1

/* No utf-8 support. 1 byte = 1 char */
#define utf8_strlen(S, B) ((B) < 0 ? (int)strlen(S) : (B))
#define utf8_strwidth(S, B) utf8_strlen((S), (B))
#define utf8_tounicode(S, CP) (*(CP) = (unsigned char)*(S), 1)
#define utf8_index(C, I) (I)
#define utf8_charlen(C) 1
 #define utf8_width(C) 1

#else

#define MAX_UTF8_LEN 4

/**
 * Converts the given unicode codepoint (0 - 0x1fffff) to utf-8
 * and stores the result at 'p'.
 *
 * Returns the number of utf-8 characters
 */
int utf8_fromunicode(char *p, unsigned uc);

/**
 * Returns the length of the utf-8 sequence starting with 'c'.
 *
 * Returns 1-4, or -1 if this is not a valid start byte.
 *
 * Note that charlen=4 is not supported by the rest of the API.
 */
int utf8_charlen(int c);

/**
 * Returns the number of characters in the utf-8
 * string of the given byte length.
 *
 * Any bytes which are not part of an valid utf-8
 * sequence are treated as individual characters.
 *
 * The string *must* be null terminated.
 *
 * Does not support unicode code points > \u1fffff
 */
int utf8_strlen(const char *str, int bytelen);

/**
 * Calculates the display width of the first 'charlen' characters in 'str'.
 * See utf8_width()
 */
int utf8_strwidth(const char *str, int charlen);

/**
 * Returns the byte index of the given character in the utf-8 string.
 *
 * The string *must* be null terminated.
 *
 * This will return the byte length of a utf-8 string
 * if given the char length.
 */
int utf8_index(const char *str, int charindex);

/**
 * Returns the unicode codepoint corresponding to the
 * utf-8 sequence 'str'.
 *
 * Stores the result in *uc and returns the number of bytes
 * consumed.
 *
 * If 'str' is null terminated, then an invalid utf-8 sequence
 * at the end of the string will be returned as individual bytes.
 *
 * If it is not null terminated, the length *must* be checked first.
 *
 * Does not support unicode code points > \u1fffff
 */
int utf8_tounicode(const char *str, int *uc);

/**
 * Returns the width (in characters) of the given unicode codepoint.
 * This is 1 for normal letters and 0 for combining characters and 2 for wide characters.
 */
int utf8_width(int ch);

#endif

#ifdef __cplusplus
}
#endif

#endif
/**
 * UTF-8 utility functions
 *
 * (c) 2010-2019 Steve Bennett <steveb@workware.net.au>
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "utf8.h"

#ifdef USE_UTF8
int utf8_fromunicode(char *p, unsigned uc)
{
    if (uc <= 0x7f) {
        *p = uc;
        return 1;
    }
    else if (uc <= 0x7ff) {
        *p++ = 0xc0 | ((uc & 0x7c0) >> 6);
        *p = 0x80 | (uc & 0x3f);
        return 2;
    }
    else if (uc <= 0xffff) {
        *p++ = 0xe0 | ((uc & 0xf000) >> 12);
        *p++ = 0x80 | ((uc & 0xfc0) >> 6);
        *p = 0x80 | (uc & 0x3f);
        return 3;
    }
    /* Note: We silently truncate to 21 bits here: 0x1fffff */
    else {
        *p++ = 0xf0 | ((uc & 0x1c0000) >> 18);
        *p++ = 0x80 | ((uc & 0x3f000) >> 12);
        *p++ = 0x80 | ((uc & 0xfc0) >> 6);
        *p = 0x80 | (uc & 0x3f);
        return 4;
    }
}

int utf8_charlen(int c)
{
    if ((c & 0x80) == 0) {
        return 1;
    }
    if ((c & 0xe0) == 0xc0) {
        return 2;
    }
    if ((c & 0xf0) == 0xe0) {
        return 3;
    }
    if ((c & 0xf8) == 0xf0) {
        return 4;
    }
    /* Invalid sequence */
    return -1;
}

int utf8_strlen(const char *str, int bytelen)
{
    int charlen = 0;
    if (bytelen < 0) {
        bytelen = strlen(str);
    }
    while (bytelen > 0) {
        int c;
        int l = utf8_tounicode(str, &c);
        charlen++;
        str += l;
        bytelen -= l;
    }
    return charlen;
}

int utf8_strwidth(const char *str, int charlen)
{
    int width = 0;
    while (charlen) {
        int c;
        int l = utf8_tounicode(str, &c);
        width += utf8_width(c);
        str += l;
        charlen--;
    }
    return width;
}

int utf8_index(const char *str, int index)
{
    const char *s = str;
    while (index--) {
        int c;
        s += utf8_tounicode(s, &c);
    }
    return s - str;
}

int utf8_tounicode(const char *str, int *uc)
{
    unsigned const char *s = (unsigned const char *)str;

    if (s[0] < 0xc0) {
        *uc = s[0];
        return 1;
    }
    if (s[0] < 0xe0) {
        if ((s[1] & 0xc0) == 0x80) {
            *uc = ((s[0] & ~0xc0) << 6) | (s[1] & ~0x80);
            if (*uc >= 0x80) {
                return 2;
            }
            /* Otherwise this is an invalid sequence */
        }
    }
    else if (s[0] < 0xf0) {
        if (((str[1] & 0xc0) == 0x80) && ((str[2] & 0xc0) == 0x80)) {
            *uc = ((s[0] & ~0xe0) << 12) | ((s[1] & ~0x80) << 6) | (s[2] & ~0x80);
            if (*uc >= 0x800) {
                return 3;
            }
            /* Otherwise this is an invalid sequence */
        }
    }
    else if (s[0] < 0xf8) {
        if (((str[1] & 0xc0) == 0x80) && ((str[2] & 0xc0) == 0x80) && ((str[3] & 0xc0) == 0x80)) {
            *uc = ((s[0] & ~0xf0) << 18) | ((s[1] & ~0x80) << 12) | ((s[2] & ~0x80) << 6) | (s[3] & ~0x80);
            if (*uc >= 0x10000) {
                return 4;
            }
            /* Otherwise this is an invalid sequence */
        }
    }

    /* Invalid sequence, so just return the byte */
    *uc = *s;
    return 1;
}

struct utf8range {
    int lower;     /* lower inclusive */
    int upper;     /* upper exclusive */
};

/* From http://unicode.org/Public/UNIDATA/UnicodeData.txt */
static const struct utf8range unicode_range_combining[] = {
        { 0x0300, 0x0370 },     { 0x0483, 0x048a },     { 0x0591, 0x05d0 },     { 0x0610, 0x061b },
        { 0x064b, 0x0660 },     { 0x0670, 0x0671 },     { 0x06d6, 0x06dd },     { 0x06df, 0x06e5 },
        { 0x06e7, 0x06ee },     { 0x0711, 0x0712 },     { 0x0730, 0x074d },     { 0x07a6, 0x07b1 },
        { 0x07eb, 0x07f4 },     { 0x0816, 0x0830 },     { 0x0859, 0x085e },     { 0x08d4, 0x0904 },
        { 0x093a, 0x0958 },     { 0x0962, 0x0964 },     { 0x0981, 0x0985 },     { 0x09bc, 0x09ce },
        { 0x09d7, 0x09dc },     { 0x09e2, 0x09e6 },     { 0x0a01, 0x0a05 },     { 0x0a3c, 0x0a59 },
        { 0x0a70, 0x0a72 },     { 0x0a75, 0x0a85 },     { 0x0abc, 0x0ad0 },     { 0x0ae2, 0x0ae6 },
        { 0x0afa, 0x0b05 },     { 0x0b3c, 0x0b5c },     { 0x0b62, 0x0b66 },     { 0x0b82, 0x0b83 },
        { 0x0bbe, 0x0bd0 },     { 0x0bd7, 0x0be6 },     { 0x0c00, 0x0c05 },     { 0x0c3e, 0x0c58 },
        { 0x0c62, 0x0c66 },     { 0x0c81, 0x0c85 },     { 0x0cbc, 0x0cde },     { 0x0ce2, 0x0ce6 },
        { 0x0d00, 0x0d05 },     { 0x0d3b, 0x0d4e },     { 0x0d57, 0x0d58 },     { 0x0d62, 0x0d66 },
        { 0x0d82, 0x0d85 },     { 0x0dca, 0x0de6 },     { 0x0df2, 0x0df4 },     { 0x0e31, 0x0e32 },
        { 0x0e34, 0x0e3f },     { 0x0e47, 0x0e4f },     { 0x0eb1, 0x0eb2 },     { 0x0eb4, 0x0ebd },
        { 0x0ec8, 0x0ed0 },     { 0x0f18, 0x0f1a },     { 0x0f35, 0x0f3a },     { 0x0f3e, 0x0f40 },
        { 0x0f71, 0x0f88 },     { 0x0f8d, 0x0fbe },     { 0x0fc6, 0x0fc7 },     { 0x102b, 0x103f },
        { 0x1056, 0x105a },     { 0x105e, 0x1065 },     { 0x1067, 0x106e },     { 0x1071, 0x1075 },
        { 0x1082, 0x1090 },     { 0x109a, 0x109e },     { 0x135d, 0x1360 },     { 0x1712, 0x1720 },
        { 0x1732, 0x1735 },     { 0x1752, 0x1760 },     { 0x1772, 0x1780 },     { 0x17b4, 0x17d4 },
        { 0x17dd, 0x17e0 },     { 0x180b, 0x180e },     { 0x1885, 0x1887 },     { 0x18a9, 0x18aa },
        { 0x1920, 0x1940 },     { 0x1a17, 0x1a1e },     { 0x1a55, 0x1a80 },     { 0x1ab0, 0x1b05 },
        { 0x1b34, 0x1b45 },     { 0x1b6b, 0x1b74 },     { 0x1b80, 0x1b83 },     { 0x1ba1, 0x1bae },
        { 0x1be6, 0x1bfc },     { 0x1c24, 0x1c3b },     { 0x1cd0, 0x1ce9 },     { 0x1ced, 0x1cee },
        { 0x1cf2, 0x1cf5 },     { 0x1cf7, 0x1d00 },     { 0x1dc0, 0x1e00 },     { 0x20d0, 0x2100 },
        { 0x2cef, 0x2cf2 },     { 0x2d7f, 0x2d80 },     { 0x2de0, 0x2e00 },     { 0x302a, 0x3030 },
        { 0x3099, 0x309b },     { 0xa66f, 0xa67e },     { 0xa69e, 0xa6a0 },     { 0xa6f0, 0xa6f2 },
        { 0xa802, 0xa803 },     { 0xa806, 0xa807 },     { 0xa80b, 0xa80c },     { 0xa823, 0xa828 },
        { 0xa880, 0xa882 },     { 0xa8b4, 0xa8ce },     { 0xa8e0, 0xa8f2 },     { 0xa926, 0xa92e },
        { 0xa947, 0xa95f },     { 0xa980, 0xa984 },     { 0xa9b3, 0xa9c1 },     { 0xa9e5, 0xa9e6 },
        { 0xaa29, 0xaa40 },     { 0xaa43, 0xaa44 },     { 0xaa4c, 0xaa50 },     { 0xaa7b, 0xaa7e },
        { 0xaab0, 0xaab5 },     { 0xaab7, 0xaab9 },     { 0xaabe, 0xaac2 },     { 0xaaeb, 0xaaf0 },
        { 0xaaf5, 0xab01 },     { 0xabe3, 0xabf0 },     { 0xfb1e, 0xfb1f },     { 0xfe00, 0xfe10 },
        { 0xfe20, 0xfe30 },
};

/* From http://unicode.org/Public/UNIDATA/EastAsianWidth.txt */
static const struct utf8range unicode_range_wide[] = {
        { 0x1100, 0x115f },     { 0x231a, 0x231b },     { 0x2329, 0x232a },     { 0x23e9, 0x23ec },
        { 0x23f0, 0x23f0 },     { 0x23f3, 0x23f3 },     { 0x25fd, 0x25fe },     { 0x2614, 0x2615 },
        { 0x2648, 0x2653 },     { 0x267f, 0x267f },     { 0x2693, 0x2693 },     { 0x26a1, 0x26a1 },
        { 0x26aa, 0x26ab },     { 0x26bd, 0x26be },     { 0x26c4, 0x26c5 },     { 0x26ce, 0x26ce },
        { 0x26d4, 0x26d4 },     { 0x26ea, 0x26ea },     { 0x26f2, 0x26f3 },     { 0x26f5, 0x26f5 },
        { 0x26fa, 0x26fa },     { 0x26fd, 0x26fd },     { 0x2705, 0x2705 },     { 0x270a, 0x270b },
        { 0x2728, 0x2728 },     { 0x274c, 0x274c },     { 0x274e, 0x274e },     { 0x2753, 0x2755 },
        { 0x2757, 0x2757 },     { 0x2795, 0x2797 },     { 0x27b0, 0x27b0 },     { 0x27bf, 0x27bf },
        { 0x2b1b, 0x2b1c },     { 0x2b50, 0x2b50 },     { 0x2b55, 0x2b55 },     { 0x2e80, 0x2e99 },
        { 0x2e9b, 0x2ef3 },     { 0x2f00, 0x2fd5 },     { 0x2ff0, 0x2ffb },     { 0x3001, 0x303e },
        { 0x3041, 0x3096 },     { 0x3099, 0x30ff },     { 0x3105, 0x312e },     { 0x3131, 0x318e },
        { 0x3190, 0x31ba },     { 0x31c0, 0x31e3 },     { 0x31f0, 0x321e },     { 0x3220, 0x3247 },
        { 0x3250, 0x32fe },     { 0x3300, 0x4dbf },     { 0x4e00, 0xa48c },     { 0xa490, 0xa4c6 },
        { 0xa960, 0xa97c },     { 0xac00, 0xd7a3 },     { 0xf900, 0xfaff },     { 0xfe10, 0xfe19 },
        { 0xfe30, 0xfe52 },     { 0xfe54, 0xfe66 },     { 0xfe68, 0xfe6b },     { 0x16fe0, 0x16fe1 },
        { 0x17000, 0x187ec },   { 0x18800, 0x18af2 },   { 0x1b000, 0x1b11e },   { 0x1b170, 0x1b2fb },
        { 0x1f004, 0x1f004 },   { 0x1f0cf, 0x1f0cf },   { 0x1f18e, 0x1f18e },   { 0x1f191, 0x1f19a },
        { 0x1f200, 0x1f202 },   { 0x1f210, 0x1f23b },   { 0x1f240, 0x1f248 },   { 0x1f250, 0x1f251 },
        { 0x1f260, 0x1f265 },   { 0x1f300, 0x1f320 },   { 0x1f32d, 0x1f335 },   { 0x1f337, 0x1f37c },
        { 0x1f37e, 0x1f393 },   { 0x1f3a0, 0x1f3ca },   { 0x1f3cf, 0x1f3d3 },   { 0x1f3e0, 0x1f3f0 },
        { 0x1f3f4, 0x1f3f4 },   { 0x1f3f8, 0x1f43e },   { 0x1f440, 0x1f440 },   { 0x1f442, 0x1f4fc },
        { 0x1f4ff, 0x1f53d },   { 0x1f54b, 0x1f54e },   { 0x1f550, 0x1f567 },   { 0x1f57a, 0x1f57a },
        { 0x1f595, 0x1f596 },   { 0x1f5a4, 0x1f5a4 },   { 0x1f5fb, 0x1f64f },   { 0x1f680, 0x1f6c5 },
        { 0x1f6cc, 0x1f6cc },   { 0x1f6d0, 0x1f6d2 },   { 0x1f6eb, 0x1f6ec },   { 0x1f6f4, 0x1f6f8 },
        { 0x1f910, 0x1f93e },   { 0x1f940, 0x1f94c },   { 0x1f950, 0x1f96b },   { 0x1f980, 0x1f997 },
        { 0x1f9c0, 0x1f9c0 },   { 0x1f9d0, 0x1f9e6 },   { 0x20000, 0x2fffd },   { 0x30000, 0x3fffd },
};

#define ARRAYSIZE(A) sizeof(A) / sizeof(*(A))

static int cmp_range(const void *key, const void *cm)
{
    const struct utf8range *range = (const struct utf8range *)cm;
    int ch = *(int *)key;
    if (ch < range->lower) {
        return -1;
    }
    if (ch >= range->upper) {
        return 1;
    }
    return 0;
}

static int utf8_in_range(const struct utf8range *range, int num, int ch)
{
    const struct utf8range *r =
        bsearch(&ch, range, num, sizeof(*range), cmp_range);

    if (r) {
        return 1;
    }
    return 0;
}

int utf8_width(int ch)
{
    /* short circuit for common case */
    if (isascii(ch)) {
        return 1;
    }
    if (utf8_in_range(unicode_range_combining, ARRAYSIZE(unicode_range_combining), ch)) {
        return 0;
    }
    if (utf8_in_range(unicode_range_wide, ARRAYSIZE(unicode_range_wide), ch)) {
        return 2;
    }
    return 1;
}
#endif
/* linenoise.c -- guerrilla line editing library against the idea that a
 * line editing lib needs to be 20,000 lines of C code.
 *
 * You can find the latest source code at:
 *
 *   http://github.com/msteveb/linenoise
 *   (forked from http://github.com/antirez/linenoise)
 *
 * Does a number of crazy assumptions that happen to be true in 99.9999% of
 * the 2010 UNIX computers around.
 *
 * ------------------------------------------------------------------------
 *
 * Copyright (c) 2010, Salvatore Sanfilippo <antirez at gmail dot com>
 * Copyright (c) 2010, Pieter Noordhuis <pcnoordhuis at gmail dot com>
 * Copyright (c) 2011, Steve Bennett <steveb at workware dot net dot au>
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *  *  Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *  *  Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ------------------------------------------------------------------------
 *
 * References:
 * - http://invisible-island.net/xterm/ctlseqs/ctlseqs.html
 * - http://www.3waylabs.com/nw/WWW/products/wizcon/vt220.html
 *
 * Bloat:
 * - Completion?
 *
 * Unix/termios
 * ------------
 * List of escape sequences used by this program, we do everything just
 * a few sequences. In order to be so cheap we may have some
 * flickering effect with some slow terminal, but the lesser sequences
 * the more compatible.
 *
 * EL (Erase Line)
 *    Sequence: ESC [ 0 K
 *    Effect: clear from cursor to end of line
 *
 * CUF (CUrsor Forward)
 *    Sequence: ESC [ n C
 *    Effect: moves cursor forward n chars
 *
 * CR (Carriage Return)
 *    Sequence: \r
 *    Effect: moves cursor to column 1
 *
 * The following are used to clear the screen: ESC [ H ESC [ 2 J
 * This is actually composed of two sequences:
 *
 * cursorhome
 *    Sequence: ESC [ H
 *    Effect: moves the cursor to upper left corner
 *
 * ED2 (Clear entire screen)
 *    Sequence: ESC [ 2 J
 *    Effect: clear the whole screen
 *
 * == For highlighting control characters, we also use the following two ==
 * SO (enter StandOut)
 *    Sequence: ESC [ 7 m
 *    Effect: Uses some standout mode such as reverse video
 *
 * SE (Standout End)
 *    Sequence: ESC [ 0 m
 *    Effect: Exit standout mode
 *
 * == Only used if TIOCGWINSZ fails ==
 * DSR/CPR (Report cursor position)
 *    Sequence: ESC [ 6 n
 *    Effect: reports current cursor position as ESC [ NNN ; MMM R
 *
 * == Only used in multiline mode ==
 * CUU (Cursor Up)
 *    Sequence: ESC [ n A
 *    Effect: moves cursor up n chars.
 *
 * CUD (Cursor Down)
 *    Sequence: ESC [ n B
 *    Effect: moves cursor down n chars.
 *
 * win32/console
 * -------------
 * If __MINGW32__ is defined, the win32 console API is used.
 * This could probably be made to work for the msvc compiler too.
 * This support based in part on work by Jon Griffiths.
 */

#ifdef _WIN32 /* Windows platform, either MinGW or Visual Studio (MSVC) */
#include <windows.h>
#include <fcntl.h>
#define USE_WINCONSOLE
#ifdef __MINGW32__
#define HAVE_UNISTD_H
#else
/* Microsoft headers don't like old POSIX names */
#define strdup _strdup
#define snprintf _snprintf
#endif
#else
#include <termios.h>
#include <sys/ioctl.h>
#include <poll.h>
#define USE_TERMIOS
#define HAVE_UNISTD_H
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <assert.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>

#include "linenoise.h"
#ifndef STRINGBUF_H
#include "stringbuf.h"
#endif
#include "utf8.h"

#define LINENOISE_DEFAULT_HISTORY_MAX_LEN 100

#define ctrl(C) ((C) - '@')

/* Use -ve numbers here to co-exist with normal unicode chars */
enum {
    SPECIAL_NONE,
    /* don't use -1 here since that indicates error */
    SPECIAL_UP = -20,
    SPECIAL_DOWN = -21,
    SPECIAL_LEFT = -22,
    SPECIAL_RIGHT = -23,
    SPECIAL_DELETE = -24,
    SPECIAL_HOME = -25,
    SPECIAL_END = -26,
    SPECIAL_INSERT = -27,
    SPECIAL_PAGE_UP = -28,
    SPECIAL_PAGE_DOWN = -29,

    /* Some handy names for other special keycodes */
    CHAR_ESCAPE = 27,
    CHAR_DELETE = 127,
};

static int history_max_len = LINENOISE_DEFAULT_HISTORY_MAX_LEN;
static int history_len = 0;
static char **history = NULL;

/* Structure to contain the status of the current (being edited) line */
struct current {
    stringbuf *buf; /* Current buffer. Always null terminated */
    int pos;    /* Cursor position, measured in chars */
    int cols;   /* Size of the window, in chars */
    int nrows;  /* How many rows are being used in multiline mode (>= 1) */
    int rpos;   /* The current row containing the cursor - multiline mode only */
    int colsright; /* refreshLine() cached cols for insert_char() optimisation */
    int colsleft;  /* refreshLine() cached cols for remove_char() optimisation */
    const char *prompt;
    stringbuf *capture; /* capture buffer, or NULL for none. Always null terminated */
    stringbuf *output;  /* used only during refreshLine() - output accumulator */
#if defined(USE_TERMIOS)
    int fd;     /* Terminal fd */
#elif defined(USE_WINCONSOLE)
    HANDLE outh; /* Console output handle */
    HANDLE inh; /* Console input handle */
    int rows;   /* Screen rows */
    int x;      /* Current column during output */
    int y;      /* Current row */
#ifdef USE_UTF8
    #define UBUF_MAX_CHARS 132
    WORD ubuf[UBUF_MAX_CHARS + 1];  /* Accumulates utf16 output - one extra for final surrogate pairs */
    int ubuflen;      /* length used in ubuf */
    int ubufcols;     /* how many columns are represented by the chars in ubuf? */
#endif
#endif
};

static int fd_read(struct current *current);
static int getWindowSize(struct current *current);
static void cursorDown(struct current *current, int n);
static void cursorUp(struct current *current, int n);
static void eraseEol(struct current *current);
static void refreshLine(struct current *current);
static void refreshLineAlt(struct current *current, const char *prompt, const char *buf, int cursor_pos);
static void setCursorPos(struct current *current, int x);
static void setOutputHighlight(struct current *current, const int *props, int nprops);
static void set_current(struct current *current, const char *str);

void linenoiseHistoryFree(void) {
    if (history) {
        int j;

        for (j = 0; j < history_len; j++)
            free(history[j]);
        free(history);
        history = NULL;
        history_len = 0;
    }
}

typedef enum {
    EP_START,   /* looking for ESC */
    EP_ESC,     /* looking for [ */
    EP_DIGITS,  /* parsing digits */
    EP_PROPS,   /* parsing digits or semicolons */
    EP_END,     /* ok */
    EP_ERROR,   /* error */
} ep_state_t;

struct esc_parser {
    ep_state_t state;
    int props[5];   /* properties are stored here */
    int maxprops;   /* size of the props[] array */
    int numprops;   /* number of properties found */
    int termchar;   /* terminator char, or 0 for any alpha */
    int current;    /* current (partial) property value */
};

/**
 * Initialise the escape sequence parser at *parser.
 *
 * If termchar is 0 any alpha char terminates ok. Otherwise only the given
 * char terminates successfully.
 * Run the parser state machine with calls to parseEscapeSequence() for each char.
 */
static void initParseEscapeSeq(struct esc_parser *parser, int termchar)
{
    parser->state = EP_START;
    parser->maxprops = sizeof(parser->props) / sizeof(*parser->props);
    parser->numprops = 0;
    parser->current = 0;
    parser->termchar = termchar;
}

/**
 * Pass character 'ch' into the state machine to parse:
 *   'ESC' '[' <digits> (';' <digits>)* <termchar>
 *
 * The first character must be ESC.
 * Returns the current state. The state machine is done when it returns either EP_END
 * or EP_ERROR.
 *
 * On EP_END, the "property/attribute" values can be read from parser->props[]
 * of length parser->numprops.
 */
static int parseEscapeSequence(struct esc_parser *parser, int ch)
{
    switch (parser->state) {
        case EP_START:
            parser->state = (ch == '\x1b') ? EP_ESC : EP_ERROR;
            break;
        case EP_ESC:
            parser->state = (ch == '[') ? EP_DIGITS : EP_ERROR;
            break;
        case EP_PROPS:
            if (ch == ';') {
                parser->state = EP_DIGITS;
donedigits:
                if (parser->numprops + 1 < parser->maxprops) {
                    parser->props[parser->numprops++] = parser->current;
                    parser->current = 0;
                }
                break;
            }
            /* fall through */
        case EP_DIGITS:
            if (ch >= '0' && ch <= '9') {
                parser->current = parser->current * 10 + (ch - '0');
                parser->state = EP_PROPS;
                break;
            }
            /* must be terminator */
            if (parser->termchar != ch) {
                if (parser->termchar != 0 || !((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))) {
                    parser->state = EP_ERROR;
                    break;
                }
            }
            parser->state = EP_END;
            goto donedigits;
        case EP_END:
            parser->state = EP_ERROR;
            break;
        case EP_ERROR:
            break;
    }
    return parser->state;
}

/*#define DEBUG_REFRESHLINE*/

#ifdef DEBUG_REFRESHLINE
#define DRL(ARGS...) fprintf(dfh, ARGS)
static FILE *dfh;

static void DRL_CHAR(int ch)
{
    if (ch < ' ') {
        DRL("^%c", ch + '@');
    }
    else if (ch > 127) {
        DRL("\\u%04x", ch);
    }
    else {
        DRL("%c", ch);
    }
}
static void DRL_STR(const char *str)
{
    while (*str) {
        int ch;
        int n = utf8_tounicode(str, &ch);
        str += n;
        DRL_CHAR(ch);
    }
}
#else
#define DRL(...)
#define DRL_CHAR(ch)
#define DRL_STR(str)
#endif

#if defined(USE_WINCONSOLE)
#include "linenoise-win32.c"
#endif

#if defined(USE_TERMIOS)
static void linenoiseAtExit(void);
static struct termios orig_termios; /* in order to restore at exit */
static int rawmode = 0; /* for atexit() function to check if restore is needed*/
static int atexit_registered = 0; /* register atexit just 1 time */

static const char *unsupported_term[] = {"dumb","cons25","emacs",NULL};

static int isUnsupportedTerm(void) {
    char *term = getenv("TERM");

    if (term) {
        int j;
        for (j = 0; unsupported_term[j]; j++) {
            if (strcmp(term, unsupported_term[j]) == 0) {
                return 1;
            }
        }
    }
    return 0;
}

static int enableRawMode(struct current *current) {
    struct termios raw;

    current->fd = STDIN_FILENO;
    current->cols = 0;

    if (!isatty(current->fd) || isUnsupportedTerm() ||
        tcgetattr(current->fd, &orig_termios) == -1) {
fatal:
        errno = ENOTTY;
        return -1;
    }

    if (!atexit_registered) {
        atexit(linenoiseAtExit);
        atexit_registered = 1;
    }

    raw = orig_termios;  /* modify the original mode */
    /* input modes: no break, no CR to NL, no parity check, no strip char,
     * no start/stop output control. */
    raw.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    /* output modes - actually, no need to disable post processing */
    /*raw.c_oflag &= ~(OPOST);*/
    /* control modes - set 8 bit chars */
    raw.c_cflag |= (CS8);
    /* local modes - choing off, canonical off, no extended functions,
     * no signal chars (^Z,^C) */
    raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
    /* control chars - set return condition: min number of bytes and timer.
     * We want read to return every single byte, without timeout. */
    raw.c_cc[VMIN] = 1; raw.c_cc[VTIME] = 0; /* 1 byte, no timer */

    /* put terminal in raw mode after flushing */
    if (tcsetattr(current->fd,TCSADRAIN,&raw) < 0) {
        goto fatal;
    }
    rawmode = 1;
    return 0;
}

static void disableRawMode(struct current *current) {
    /* Don't even check the return value as it's too late. */
    if (rawmode && tcsetattr(current->fd,TCSADRAIN,&orig_termios) != -1)
        rawmode = 0;
}

/* At exit we'll try to fix the terminal to the initial conditions. */
static void linenoiseAtExit(void) {
    if (rawmode) {
        tcsetattr(STDIN_FILENO, TCSADRAIN, &orig_termios);
    }
    linenoiseHistoryFree();
}

/* gcc/glibc insists that we care about the return code of write!
 * Clarification: This means that a void-cast like "(void) (EXPR)"
 * does not work.
 */
#define IGNORE_RC(EXPR) if (EXPR) {}

/**
 * Output bytes directly, or accumulate output (if current->output is set)
 */
static void outputChars(struct current *current, const char *buf, int len)
{
    if (len < 0) {
        len = strlen(buf);
    }
    if (current->output) {
        sb_append_len(current->output, buf, len);
    }
    else {
        IGNORE_RC(write(current->fd, buf, len));
    }
}

/* Like outputChars, but using printf-style formatting
 */
static void outputFormatted(struct current *current, const char *format, ...)
{
    va_list args;
    char buf[64];
    int n;

    va_start(args, format);
    n = vsnprintf(buf, sizeof(buf), format, args);
    /* This will never happen because we are sure to use outputFormatted() only for short sequences */
    assert(n < (int)sizeof(buf));
    va_end(args);
    outputChars(current, buf, n);
}

static void cursorToLeft(struct current *current)
{
    outputChars(current, "\r", -1);
}

static void setOutputHighlight(struct current *current, const int *props, int nprops)
{
    outputChars(current, "\x1b[", -1);
    while (nprops--) {
        outputFormatted(current, "%d%c", *props, (nprops == 0) ? 'm' : ';');
        props++;
    }
}

static void eraseEol(struct current *current)
{
    outputChars(current, "\x1b[0K", -1);
}

static void setCursorPos(struct current *current, int x)
{
    if (x == 0) {
        cursorToLeft(current);
    }
    else {
        outputFormatted(current, "\r\x1b[%dC", x);
    }
}

static void cursorUp(struct current *current, int n)
{
    if (n) {
        outputFormatted(current, "\x1b[%dA", n);
    }
}

static void cursorDown(struct current *current, int n)
{
    if (n) {
        outputFormatted(current, "\x1b[%dB", n);
    }
}

void linenoiseClearScreen(void)
{
    IGNORE_RC(write(STDOUT_FILENO, "\x1b[H\x1b[2J", 7));
}

/**
 * Reads a char from 'fd', waiting at most 'timeout' milliseconds.
 *
 * A timeout of -1 means to wait forever.
 *
 * Returns -1 if no char is received within the time or an error occurs.
 */
static int fd_read_char(int fd, int timeout)
{
    struct pollfd p;
    unsigned char c;

    p.fd = fd;
    p.events = POLLIN;

    if (poll(&p, 1, timeout) == 0) {
        /* timeout */
        return -1;
    }
    if (read(fd, &c, 1) != 1) {
        return -1;
    }
    return c;
}

/**
 * Reads a complete utf-8 character
 * and returns the unicode value, or -1 on error.
 */
static int fd_read(struct current *current)
{
#ifdef USE_UTF8
    char buf[MAX_UTF8_LEN];
    int n;
    int i;
    int c;

    if (read(current->fd, &buf[0], 1) != 1) {
        return -1;
    }
    n = utf8_charlen(buf[0]);
    if (n < 1) {
        return -1;
    }
    for (i = 1; i < n; i++) {
        if (read(current->fd, &buf[i], 1) != 1) {
            return -1;
        }
    }
    /* decode and return the character */
    utf8_tounicode(buf, &c);
    return c;
#else
    return fd_read_char(current->fd, -1);
#endif
}


/**
 * Stores the current cursor column in '*cols'.
 * Returns 1 if OK, or 0 if failed to determine cursor pos.
 */
static int queryCursor(struct current *current, int* cols)
{
    struct esc_parser parser;
    int ch;

    /* Should not be buffering this output, it needs to go immediately */
    assert(current->output == NULL);

    /* control sequence - report cursor location */
    outputChars(current, "\x1b[6n", -1);

    /* Parse the response: ESC [ rows ; cols R */
    initParseEscapeSeq(&parser, 'R');
    while ((ch = fd_read_char(current->fd, 100)) > 0) {
        switch (parseEscapeSequence(&parser, ch)) {
            default:
                continue;
            case EP_END:
                if (parser.numprops == 2 && parser.props[1] < 1000) {
                    *cols = parser.props[1];
                    return 1;
                }
                break;
            case EP_ERROR:
                break;
        }
        /* failed */
        break;
    }
    return 0;
}

/**
 * Updates current->cols with the current window size (width)
 */
static int getWindowSize(struct current *current)
{
    struct winsize ws;

    if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == 0 && ws.ws_col != 0) {
        current->cols = ws.ws_col;
        return 0;
    }

    /* Failed to query the window size. Perhaps we are on a serial terminal.
     * Try to query the width by sending the cursor as far to the right
     * and reading back the cursor position.
     * Note that this is only done once per call to linenoise rather than
     * every time the line is refreshed for efficiency reasons.
     *
     * In more detail, we:
     * (a) request current cursor position,
     * (b) move cursor far right,
     * (c) request cursor position again,
     * (d) at last move back to the old position.
     * This gives us the width without messing with the externally
     * visible cursor position.
     */

    if (current->cols == 0) {
        int here;

        /* If anything fails => default 80 */
        current->cols = 80;

        /* (a) */
        if (queryCursor (current, &here)) {
            /* (b) */
            setCursorPos(current, 999);

            /* (c). Note: If (a) succeeded, then (c) should as well.
             * For paranoia we still check and have a fallback action
             * for (d) in case of failure..
             */
            if (queryCursor (current, &current->cols)) {
                /* (d) Reset the cursor back to the original location. */
                if (current->cols > here) {
                    setCursorPos(current, here);
                }
            }
        }
    }

    return 0;
}

/**
 * If CHAR_ESCAPE was received, reads subsequent
 * chars to determine if this is a known special key.
 *
 * Returns SPECIAL_NONE if unrecognised, or -1 if EOF.
 *
 * If no additional char is received within a short time,
 * CHAR_ESCAPE is returned.
 */
static int check_special(int fd)
{
    int c = fd_read_char(fd, 50);
    int c2;

    if (c < 0) {
        return CHAR_ESCAPE;
    }

    c2 = fd_read_char(fd, 50);
    if (c2 < 0) {
        return c2;
    }
    if (c == '[' || c == 'O') {
        /* Potential arrow key */
        switch (c2) {
            case 'A':
                return SPECIAL_UP;
            case 'B':
                return SPECIAL_DOWN;
            case 'C':
                return SPECIAL_RIGHT;
            case 'D':
                return SPECIAL_LEFT;
            case 'F':
                return SPECIAL_END;
            case 'H':
                return SPECIAL_HOME;
        }
    }
    if (c == '[' && c2 >= '1' && c2 <= '8') {
        /* extended escape */
        c = fd_read_char(fd, 50);
        if (c == '~') {
            switch (c2) {
                case '2':
                    return SPECIAL_INSERT;
                case '3':
                    return SPECIAL_DELETE;
                case '5':
                    return SPECIAL_PAGE_UP;
                case '6':
                    return SPECIAL_PAGE_DOWN;
                case '7':
                    return SPECIAL_HOME;
                case '8':
                    return SPECIAL_END;
            }
        }
        while (c != -1 && c != '~') {
            /* .e.g \e[12~ or '\e[11;2~   discard the complete sequence */
            c = fd_read_char(fd, 50);
        }
    }

    return SPECIAL_NONE;
}
#endif

static void clearOutputHighlight(struct current *current)
{
    int nohighlight = 0;
    setOutputHighlight(current, &nohighlight, 1);
}

static void outputControlChar(struct current *current, char ch)
{
    int reverse = 7;
    setOutputHighlight(current, &reverse, 1);
    outputChars(current, "^", 1);
    outputChars(current, &ch, 1);
    clearOutputHighlight(current);
}

#ifndef utf8_getchars
static int utf8_getchars(char *buf, int c)
{
#ifdef USE_UTF8
    return utf8_fromunicode(buf, c);
#else
    *buf = c;
    return 1;
#endif
}
#endif

/**
 * Returns the unicode character at the given offset,
 * or -1 if none.
 */
static int get_char(struct current *current, int pos)
{
    if (pos >= 0 && pos < sb_chars(current->buf)) {
        int c;
        int i = utf8_index(sb_str(current->buf), pos);
        (void)utf8_tounicode(sb_str(current->buf) + i, &c);
        return c;
    }
    return -1;
}

static int char_display_width(int ch)
{
    if (ch < ' ') {
        /* control chars take two positions */
        return 2;
    }
    else {
        return utf8_width(ch);
    }
}

#ifndef NO_COMPLETION
static linenoiseCompletionCallback *completionCallback = NULL;
static void *completionUserdata = NULL;
static int showhints = 1;
static linenoiseHintsCallback *hintsCallback = NULL;
static linenoiseFreeHintsCallback *freeHintsCallback = NULL;
static void *hintsUserdata = NULL;

static void beep() {
#ifdef USE_TERMIOS
    fprintf(stderr, "\x7");
    fflush(stderr);
#endif
}

static void freeCompletions(linenoiseCompletions *lc) {
    size_t i;
    for (i = 0; i < lc->len; i++)
        free(lc->cvec[i]);
    free(lc->cvec);
}

static int completeLine(struct current *current) {
    linenoiseCompletions lc = { 0, NULL };
    int c = 0;

    completionCallback(sb_str(current->buf),&lc,completionUserdata);
    if (lc.len == 0) {
        beep();
    } else {
        size_t stop = 0, i = 0;

        while(!stop) {
            /* Show completion or original buffer */
            if (i < lc.len) {
                int chars = utf8_strlen(lc.cvec[i], -1);
                refreshLineAlt(current, current->prompt, lc.cvec[i], chars);
            } else {
                refreshLine(current);
            }

            c = fd_read(current);
            if (c == -1) {
                break;
            }

            switch(c) {
                case '\t': /* tab */
                    i = (i+1) % (lc.len+1);
                    if (i == lc.len) beep();
                    break;
                case CHAR_ESCAPE: /* escape */
                    /* Re-show original buffer */
                    if (i < lc.len) {
                        refreshLine(current);
                    }
                    stop = 1;
                    break;
                default:
                    /* Update buffer and return */
                    if (i < lc.len) {
                        set_current(current,lc.cvec[i]);
                    }
                    stop = 1;
                    break;
            }
        }
    }

    freeCompletions(&lc);
    return c; /* Return last read character */
}

/* Register a callback function to be called for tab-completion.
   Returns the prior callback so that the caller may (if needed)
   restore it when done. */
linenoiseCompletionCallback * linenoiseSetCompletionCallback(linenoiseCompletionCallback *fn, void *userdata) {
    linenoiseCompletionCallback * old = completionCallback;
    completionCallback = fn;
    completionUserdata = userdata;
    return old;
}

void linenoiseAddCompletion(linenoiseCompletions *lc, const char *str) {
    lc->cvec = (char **)realloc(lc->cvec,sizeof(char*)*(lc->len+1));
    lc->cvec[lc->len++] = strdup(str);
}

void linenoiseSetHintsCallback(linenoiseHintsCallback *callback, void *userdata)
{
    hintsCallback = callback;
    hintsUserdata = userdata;
}

void linenoiseSetFreeHintsCallback(linenoiseFreeHintsCallback *callback)
{
    freeHintsCallback = callback;
}

#endif


static const char *reduceSingleBuf(const char *buf, int availcols, int *cursor_pos)
{
    /* We have availcols columns available.
     * If necessary, strip chars off the front of buf until *cursor_pos
     * fits within availcols
     */
    int needcols = 0;
    int pos = 0;
    int new_cursor_pos = *cursor_pos;
    const char *pt = buf;

    DRL("reduceSingleBuf: availcols=%d, cursor_pos=%d\n", availcols, *cursor_pos);

    while (*pt) {
        int ch;
        int n = utf8_tounicode(pt, &ch);
        pt += n;

        needcols += char_display_width(ch);

        /* If we need too many cols, strip
         * chars off the front of buf to make it fit.
         * We keep 3 extra cols to the right of the cursor.
         * 2 for possible wide chars, 1 for the last column that
         * can't be used.
         */
        while (needcols >= availcols - 3) {
            n = utf8_tounicode(buf, &ch);
            buf += n;
            needcols -= char_display_width(ch);
            DRL_CHAR(ch);

            /* and adjust the apparent cursor position */
            new_cursor_pos--;

            if (buf == pt) {
                /* can't remove more than this */
                break;
            }
        }

        if (pos++ == *cursor_pos) {
            break;
        }

    }
    DRL("<snip>");
    DRL_STR(buf);
    DRL("\nafter reduce, needcols=%d, new_cursor_pos=%d\n", needcols, new_cursor_pos);

    /* Done, now new_cursor_pos contains the adjusted cursor position
     * and buf points to he adjusted start
     */
    *cursor_pos = new_cursor_pos;
    return buf;
}

static int mlmode = 0;

void linenoiseSetMultiLine(int enableml)
{
    mlmode = enableml;
}

/* Helper of refreshSingleLine() and refreshMultiLine() to show hints
 * to the right of the prompt.
 * Returns 1 if a hint was shown, or 0 if not
 * If 'display' is 0, does no output. Just returns the appropriate return code.
 */
static int refreshShowHints(struct current *current, const char *buf, int availcols, int display)
{
    int rc = 0;
    if (showhints && hintsCallback && availcols > 0) {
        int bold = 0;
        int color = -1;
        char *hint = hintsCallback(buf, &color, &bold, hintsUserdata);
        if (hint) {
            rc = 1;
            if (display) {
                const char *pt;
                if (bold == 1 && color == -1) color = 37;
                if (bold || color > 0) {
                    int props[3] = { bold, color, 49 }; /* bold, color, fgnormal */
                    setOutputHighlight(current, props, 3);
                }
                DRL("<hint bold=%d,color=%d>", bold, color);
                pt = hint;
                while (*pt) {
                    int ch;
                    int n = utf8_tounicode(pt, &ch);
                    int width = char_display_width(ch);

                    if (width >= availcols) {
                        DRL("<hinteol>");
                        break;
                    }
                    DRL_CHAR(ch);

                    availcols -= width;
                    outputChars(current, pt, n);
                    pt += n;
                }
                if (bold || color > 0) {
                    clearOutputHighlight(current);
                }
                /* Call the function to free the hint returned. */
                if (freeHintsCallback) freeHintsCallback(hint, hintsUserdata);
            }
        }
    }
    return rc;
}

#ifdef USE_TERMIOS
static void refreshStart(struct current *current)
{
    /* We accumulate all output here */
    assert(current->output == NULL);
    current->output = sb_alloc();
}

static void refreshEnd(struct current *current)
{
    /* Output everything at once */
    IGNORE_RC(write(current->fd, sb_str(current->output), sb_len(current->output)));
    sb_free(current->output);
    current->output = NULL;
}

static void refreshStartChars(struct current *current)
{
    (void)current;
}

static void refreshNewline(struct current *current)
{
    DRL("<nl>");
    outputChars(current, "\n", 1);
}

static void refreshEndChars(struct current *current)
{
    (void)current;
}
#endif

static void refreshLineAlt(struct current *current, const char *prompt, const char *buf, int cursor_pos)
{
    int i;
    const char *pt;
    int displaycol;
    int displayrow;
    int visible;
    int currentpos;
    int notecursor;
    int cursorcol = 0;
    int cursorrow = 0;
    int hint;
    struct esc_parser parser;

#ifdef DEBUG_REFRESHLINE
    dfh = fopen("linenoise.debuglog", "a");
#endif

    /* Should intercept SIGWINCH. For now, just get the size every time */
    getWindowSize(current);

    refreshStart(current);

    DRL("wincols=%d, cursor_pos=%d, nrows=%d, rpos=%d\n", current->cols, cursor_pos, current->nrows, current->rpos);

    /* Here is the plan:
     * (a) move the the bottom row, going down the appropriate number of lines
     * (b) move to beginning of line and erase the current line
     * (c) go up one line and do the same, until we have erased up to the first row
     * (d) output the prompt, counting cols and rows, taking into account escape sequences
     * (e) output the buffer, counting cols and rows
     *   (e') when we hit the current pos, save the cursor position
     * (f) move the cursor to the saved cursor position
     * (g) save the current cursor row and number of rows
     */

    /* (a) - The cursor is currently at row rpos */
    cursorDown(current, current->nrows - current->rpos - 1);
    DRL("<cud=%d>", current->nrows - current->rpos - 1);

    /* (b), (c) - Erase lines upwards until we get to the first row */
    for (i = 0; i < current->nrows; i++) {
        if (i) {
            DRL("<cup>");
            cursorUp(current, 1);
        }
        DRL("<clearline>");
        cursorToLeft(current);
        eraseEol(current);
    }
    DRL("\n");

    /* (d) First output the prompt. control sequences don't take up display space */
    pt = prompt;
    displaycol = 0; /* current display column */
    displayrow = 0; /* current display row */
    visible = 1;

    refreshStartChars(current);

    while (*pt) {
        int width;
        int ch;
        int n = utf8_tounicode(pt, &ch);

        if (visible && ch == CHAR_ESCAPE) {
            /* The start of an escape sequence, so not visible */
            visible = 0;
            initParseEscapeSeq(&parser, 'm');
            DRL("<esc-seq-start>");
        }

        if (ch == '\n' || ch == '\r') {
            /* treat both CR and NL the same and force wrap */
            refreshNewline(current);
            displaycol = 0;
            displayrow++;
        }
        else {
            width = visible * utf8_width(ch);

            displaycol += width;
            if (displaycol >= current->cols) {
                /* need to wrap to the next line because of newline or if it doesn't fit
                 * XXX this is a problem in single line mode
                 */
                refreshNewline(current);
                displaycol = width;
                displayrow++;
            }

            DRL_CHAR(ch);
#ifdef USE_WINCONSOLE
            if (visible) {
                outputChars(current, pt, n);
            }
#else
            outputChars(current, pt, n);
#endif
        }
        pt += n;

        if (!visible) {
            switch (parseEscapeSequence(&parser, ch)) {
                case EP_END:
                    visible = 1;
                    setOutputHighlight(current, parser.props, parser.numprops);
                    DRL("<esc-seq-end,numprops=%d>", parser.numprops);
                    break;
                case EP_ERROR:
                    DRL("<esc-seq-err>");
                    visible = 1;
                    break;
            }
        }
    }

    /* Now we are at the first line with all lines erased */
    DRL("\nafter prompt: displaycol=%d, displayrow=%d\n", displaycol, displayrow);


    /* (e) output the buffer, counting cols and rows */
    if (mlmode == 0) {
        /* In this mode we may need to trim chars from the start of the buffer until the
         * cursor fits in the window.
         */
        pt = reduceSingleBuf(buf, current->cols - displaycol, &cursor_pos);
    }
    else {
        pt = buf;
    }

    currentpos = 0;
    notecursor = -1;

    while (*pt) {
        int ch;
        int n = utf8_tounicode(pt, &ch);
        int width = char_display_width(ch);

        if (currentpos == cursor_pos) {
            /* (e') wherever we output this character is where we want the cursor */
            notecursor = 1;
        }

        if (displaycol + width >= current->cols) {
            if (mlmode == 0) {
                /* In single line mode stop once we print as much as we can on one line */
                DRL("<slmode>");
                break;
            }
            /* need to wrap to the next line since it doesn't fit */
            refreshNewline(current);
            displaycol = 0;
            displayrow++;
        }

        if (notecursor == 1) {
            /* (e') Save this position as the current cursor position */
            cursorcol = displaycol;
            cursorrow = displayrow;
            notecursor = 0;
            DRL("<cursor>");
        }

        displaycol += width;

        if (ch < ' ') {
            outputControlChar(current, ch + '@');
        }
        else {
            outputChars(current, pt, n);
        }
        DRL_CHAR(ch);
        if (width != 1) {
            DRL("<w=%d>", width);
        }

        pt += n;
        currentpos++;
    }

    /* If we didn't see the cursor, it is at the current location */
    if (notecursor) {
        DRL("<cursor>");
        cursorcol = displaycol;
        cursorrow = displayrow;
    }

    DRL("\nafter buf: displaycol=%d, displayrow=%d, cursorcol=%d, cursorrow=%d\n", displaycol, displayrow, cursorcol, cursorrow);

    /* (f) show hints */
    hint = refreshShowHints(current, buf, current->cols - displaycol, 1);

    /* Remember how many many cols are available for insert optimisation */
    if (prompt == current->prompt && hint == 0) {
        current->colsright = current->cols - displaycol;
        current->colsleft = displaycol;
    }
    else {
        /* Can't optimise */
        current->colsright = 0;
        current->colsleft = 0;
    }
    DRL("\nafter hints: colsleft=%d, colsright=%d\n\n", current->colsleft, current->colsright);

    refreshEndChars(current);

    /* (g) move the cursor to the correct place */
    cursorUp(current, displayrow - cursorrow);
    setCursorPos(current, cursorcol);

    /* (h) Update the number of rows if larger, but never reduce this */
    if (displayrow >= current->nrows) {
        current->nrows = displayrow + 1;
    }
    /* And remember the row that the cursor is on */
    current->rpos = cursorrow;

    refreshEnd(current);

#ifdef DEBUG_REFRESHLINE
    fclose(dfh);
#endif
}

static void refreshLine(struct current *current)
{
    refreshLineAlt(current, current->prompt, sb_str(current->buf), current->pos);
}

static void set_current(struct current *current, const char *str)
{
    sb_clear(current->buf);
    sb_append(current->buf, str);
    current->pos = sb_chars(current->buf);
}

/**
 * Removes the char at 'pos'.
 *
 * Returns 1 if the line needs to be refreshed, 2 if not
 * and 0 if nothing was removed
 */
static int remove_char(struct current *current, int pos)
{
    if (pos >= 0 && pos < sb_chars(current->buf)) {
        int offset = utf8_index(sb_str(current->buf), pos);
        int nbytes = utf8_index(sb_str(current->buf) + offset, 1);
        int rc = 1;

        /* Now we try to optimise in the simple but very common case that:
         * - outputChars() can be used directly (not win32)
         * - we are removing the char at EOL
         * - the buffer is not empty
         * - there are columns available to the left
         * - the char being deleted is not a wide or utf-8 character
         * - no hints are being shown
         */
        if (current->output && current->pos == pos + 1 && current->pos == sb_chars(current->buf) && pos > 0) {
#ifdef USE_UTF8
            /* Could implement utf8_prev_len() but simplest just to not optimise this case */
            char last = sb_str(current->buf)[offset];
#else
            char last = 0;
#endif
            if (current->colsleft > 0 && (last & 0x80) == 0) {
                /* Have cols on the left and not a UTF-8 char or continuation */
                /* Yes, can optimise */
                current->colsleft--;
                current->colsright++;
                rc = 2;
            }
        }

        sb_delete(current->buf, offset, nbytes);

        if (current->pos > pos) {
            current->pos--;
        }
        if (rc == 2) {
            if (refreshShowHints(current, sb_str(current->buf), current->colsright, 0)) {
                /* A hint needs to be shown, so can't optimise after all */
                rc = 1;
            }
            else {
                /* optimised output */
                outputChars(current, "\b \b", 3);
            }
        }
        return rc;
        return 1;
    }
    return 0;
}

/**
 * Insert 'ch' at position 'pos'
 *
 * Returns 1 if the line needs to be refreshed, 2 if not
 * and 0 if nothing was inserted (no room)
 */
static int insert_char(struct current *current, int pos, int ch)
{
    if (pos >= 0 && pos <= sb_chars(current->buf)) {
        char buf[MAX_UTF8_LEN + 1];
        int offset = utf8_index(sb_str(current->buf), pos);
        int n = utf8_getchars(buf, ch);
        int rc = 1;

        /* null terminate since sb_insert() requires it */
        buf[n] = 0;

        /* Now we try to optimise in the simple but very common case that:
         * - outputChars() can be used directly (not win32)
         * - we are inserting at EOL
         * - there are enough columns available
         * - no hints are being shown
         */
        if (current->output && pos == current->pos && pos == sb_chars(current->buf)) {
            int width = char_display_width(ch);
            if (current->colsright > width) {
                /* Yes, can optimise */
                current->colsright -= width;
                current->colsleft -= width;
                rc = 2;
            }
        }
        sb_insert(current->buf, offset, buf);
        if (current->pos >= pos) {
            current->pos++;
        }
        if (rc == 2) {
            if (refreshShowHints(current, sb_str(current->buf), current->colsright, 0)) {
                /* A hint needs to be shown, so can't optimise after all */
                rc = 1;
            }
            else {
                /* optimised output */
                outputChars(current, buf, n);
            }
        }
        return rc;
    }
    return 0;
}

/**
 * Captures up to 'n' characters starting at 'pos' for the cut buffer.
 *
 * This replaces any existing characters in the cut buffer.
 */
static void capture_chars(struct current *current, int pos, int nchars)
{
    if (pos >= 0 && (pos + nchars - 1) < sb_chars(current->buf)) {
        int offset = utf8_index(sb_str(current->buf), pos);
        int nbytes = utf8_index(sb_str(current->buf) + offset, nchars);

        if (nbytes > 0) {
            if (current->capture) {
                sb_clear(current->capture);
            }
            else {
                current->capture = sb_alloc();
            }
            sb_append_len(current->capture, sb_str(current->buf) + offset, nbytes);
        }
    }
}

/**
 * Removes up to 'n' characters at cursor position 'pos'.
 *
 * Returns 0 if no chars were removed or non-zero otherwise.
 */
static int remove_chars(struct current *current, int pos, int n)
{
    int removed = 0;

    /* First save any chars which will be removed */
    capture_chars(current, pos, n);

    while (n-- && remove_char(current, pos)) {
        removed++;
    }
    return removed;
}
/**
 * Inserts the characters (string) 'chars' at the cursor position 'pos'.
 *
 * Returns 0 if no chars were inserted or non-zero otherwise.
 */
static int insert_chars(struct current *current, int pos, const char *chars)
{
    int inserted = 0;

    while (*chars) {
        int ch;
        int n = utf8_tounicode(chars, &ch);
        if (insert_char(current, pos, ch) == 0) {
            break;
        }
        inserted++;
        pos++;
        chars += n;
    }
    return inserted;
}

/**
 * Returns the keycode to process, or 0 if none.
 */
static int reverseIncrementalSearch(struct current *current)
{
    /* Display the reverse-i-search prompt and process chars */
    char rbuf[50];
    char rprompt[80];
    int rchars = 0;
    int rlen = 0;
    int searchpos = history_len - 1;
    int c;

    rbuf[0] = 0;
    while (1) {
        int n = 0;
        const char *p = NULL;
        int skipsame = 0;
        int searchdir = -1;

        snprintf(rprompt, sizeof(rprompt), "(reverse-i-search)'%s': ", rbuf);
        refreshLineAlt(current, rprompt, sb_str(current->buf), current->pos);
        c = fd_read(current);
        if (c == ctrl('H') || c == CHAR_DELETE) {
            if (rchars) {
                int p_ind = utf8_index(rbuf, --rchars);
                rbuf[p_ind] = 0;
                rlen = strlen(rbuf);
            }
            continue;
        }
#ifdef USE_TERMIOS
        if (c == CHAR_ESCAPE) {
            c = check_special(current->fd);
        }
#endif
        if (c == ctrl('P') || c == SPECIAL_UP) {
            /* Search for the previous (earlier) match */
            if (searchpos > 0) {
                searchpos--;
            }
            skipsame = 1;
        }
        else if (c == ctrl('N') || c == SPECIAL_DOWN) {
            /* Search for the next (later) match */
            if (searchpos < history_len) {
                searchpos++;
            }
            searchdir = 1;
            skipsame = 1;
        }
        else if (c >= ' ') {
            /* >= here to allow for null terminator */
            if (rlen >= (int)sizeof(rbuf) - MAX_UTF8_LEN) {
                continue;
            }

            n = utf8_getchars(rbuf + rlen, c);
            rlen += n;
            rchars++;
            rbuf[rlen] = 0;

            /* Adding a new char resets the search location */
            searchpos = history_len - 1;
        }
        else {
            /* Exit from incremental search mode */
            break;
        }

        /* Now search through the history for a match */
        for (; searchpos >= 0 && searchpos < history_len; searchpos += searchdir) {
            p = strstr(history[searchpos], rbuf);
            if (p) {
                /* Found a match */
                if (skipsame && strcmp(history[searchpos], sb_str(current->buf)) == 0) {
                    /* But it is identical, so skip it */
                    continue;
                }
                /* Copy the matching line and set the cursor position */
                set_current(current,history[searchpos]);
                current->pos = utf8_strlen(history[searchpos], p - history[searchpos]);
                break;
            }
        }
        if (!p && n) {
            /* No match, so don't add it */
            rchars--;
            rlen -= n;
            rbuf[rlen] = 0;
        }
    }
    if (c == ctrl('G') || c == ctrl('C')) {
        /* ctrl-g terminates the search with no effect */
        set_current(current, "");
        c = 0;
    }
    else if (c == ctrl('J')) {
        /* ctrl-j terminates the search leaving the buffer in place */
        c = 0;
    }

    /* Go process the char normally */
    refreshLine(current);
    return c;
}

static int linenoiseEdit(struct current *current) {
    int history_index = 0;

    /* The latest history entry is always our current buffer, that
     * initially is just an empty string. */
    linenoiseHistoryAdd("");

    set_current(current, "");
    refreshLine(current);

    while(1) {
        int dir = -1;
        int c = fd_read(current);

#ifndef NO_COMPLETION
        /* Only autocomplete when the callback is set. It returns < 0 when
         * there was an error reading from fd. Otherwise it will return the
         * character that should be handled next. */
        if (c == '\t' && current->pos == sb_chars(current->buf) && completionCallback != NULL) {
            c = completeLine(current);
        }
#endif
        if (c == ctrl('R')) {
            /* reverse incremental search will provide an alternative keycode or 0 for none */
            c = reverseIncrementalSearch(current);
            /* go on to process the returned char normally */
        }

#ifdef USE_TERMIOS
        if (c == CHAR_ESCAPE) {   /* escape sequence */
            c = check_special(current->fd);
        }
#endif
        if (c == -1) {
            /* Return on errors */
            return sb_len(current->buf);
        }

        switch(c) {
        case SPECIAL_NONE:
            break;
        case '\r':    /* enter/CR */
        case '\n':    /* LF */
            history_len--;
            free(history[history_len]);
            current->pos = sb_chars(current->buf);
            if (mlmode || hintsCallback) {
                showhints = 0;
                refreshLine(current);
                showhints = 1;
            }
            return sb_len(current->buf);
        case ctrl('C'):     /* ctrl-c */
#ifdef SIGINT
            /* send ourselves SIGINT */
            disableRawMode(current);
            raise(SIGINT);
            /* and resume */
            enableRawMode(current);
            refreshLine(current);
#endif
            continue;
        case ctrl('Z'):     /* ctrl-z */
#ifdef SIGTSTP
            /* send ourselves SIGSUSP */
            disableRawMode(current);
            raise(SIGTSTP);
            /* and resume */
            enableRawMode(current);
            refreshLine(current);
#endif
            continue;
        case CHAR_DELETE:   /* backspace */
        case ctrl('H'):
            if (remove_char(current, current->pos - 1) == 1) {
                refreshLine(current);
            }
            break;
        case ctrl('D'):     /* ctrl-d */
            if (sb_len(current->buf) == 0) {
                /* Empty line, so EOF */
                history_len--;
                free(history[history_len]);
                return -1;
            }
            /* Otherwise fall through to delete char to right of cursor */
        case SPECIAL_DELETE:
            if (remove_char(current, current->pos) == 1) {
                refreshLine(current);
            }
            break;
        case SPECIAL_INSERT:
            /* Ignore. Expansion Hook.
             * Future possibility: Toggle Insert/Overwrite Modes
             */
            break;
        case ctrl('W'):    /* ctrl-w, delete word at left. save deleted chars */
            /* eat any spaces on the left */
            {
                int pos = current->pos;
                while (pos > 0 && get_char(current, pos - 1) == ' ') {
                    pos--;
                }

                /* now eat any non-spaces on the left */
                while (pos > 0 && get_char(current, pos - 1) != ' ') {
                    pos--;
                }

                if (remove_chars(current, pos, current->pos - pos)) {
                    refreshLine(current);
                }
            }
            break;
        case ctrl('T'):    /* ctrl-t */
            if (current->pos > 0 && current->pos <= sb_chars(current->buf)) {
                /* If cursor is at end, transpose the previous two chars */
                int fixer = (current->pos == sb_chars(current->buf));
                c = get_char(current, current->pos - fixer);
                remove_char(current, current->pos - fixer);
                insert_char(current, current->pos - 1, c);
                refreshLine(current);
            }
            break;
        case ctrl('V'):    /* ctrl-v */
            /* Insert the ^V first */
            if (insert_char(current, current->pos, c)) {
                refreshLine(current);
                /* Now wait for the next char. Can insert anything except \0 */
                c = fd_read(current);

                /* Remove the ^V first */
                remove_char(current, current->pos - 1);
                if (c > 0) {
                    /* Insert the actual char, can't be error or null */
                    insert_char(current, current->pos, c);
                }
                refreshLine(current);
            }
            break;
        case ctrl('B'):
        case SPECIAL_LEFT:
            if (current->pos > 0) {
                current->pos--;
                refreshLine(current);
            }
            break;
        case ctrl('F'):
        case SPECIAL_RIGHT:
            if (current->pos < sb_chars(current->buf)) {
                current->pos++;
                refreshLine(current);
            }
            break;
        case SPECIAL_PAGE_UP:
          dir = history_len - history_index - 1; /* move to start of history */
          goto history_navigation;
        case SPECIAL_PAGE_DOWN:
          dir = -history_index; /* move to 0 == end of history, i.e. current */
          goto history_navigation;
        case ctrl('P'):
        case SPECIAL_UP:
            dir = 1;
          goto history_navigation;
        case ctrl('N'):
        case SPECIAL_DOWN:
history_navigation:
            if (history_len > 1) {
                /* Update the current history entry before to
                 * overwrite it with tne next one. */
                free(history[history_len - 1 - history_index]);
                history[history_len - 1 - history_index] = strdup(sb_str(current->buf));
                /* Show the new entry */
                history_index += dir;
                if (history_index < 0) {
                    history_index = 0;
                    break;
                } else if (history_index >= history_len) {
                    history_index = history_len - 1;
                    break;
                }
                set_current(current, history[history_len - 1 - history_index]);
                refreshLine(current);
            }
            break;
        case ctrl('A'): /* Ctrl+a, go to the start of the line */
        case SPECIAL_HOME:
            current->pos = 0;
            refreshLine(current);
            break;
        case ctrl('E'): /* ctrl+e, go to the end of the line */
        case SPECIAL_END:
            current->pos = sb_chars(current->buf);
            refreshLine(current);
            break;
        case ctrl('U'): /* Ctrl+u, delete to beginning of line, save deleted chars. */
            if (remove_chars(current, 0, current->pos)) {
                refreshLine(current);
            }
            break;
        case ctrl('K'): /* Ctrl+k, delete from current to end of line, save deleted chars. */
            if (remove_chars(current, current->pos, sb_chars(current->buf) - current->pos)) {
                refreshLine(current);
            }
            break;
        case ctrl('Y'): /* Ctrl+y, insert saved chars at current position */
            if (current->capture && insert_chars(current, current->pos, sb_str(current->capture))) {
                refreshLine(current);
            }
            break;
        case ctrl('L'): /* Ctrl+L, clear screen */
            linenoiseClearScreen();
            /* Force recalc of window size for serial terminals */
            current->cols = 0;
            current->rpos = 0;
            refreshLine(current);
            break;
        default:
            /* Only tab is allowed without ^V */
            if (c == '\t' || c >= ' ') {
                if (insert_char(current, current->pos, c) == 1) {
                    refreshLine(current);
                }
            }
            break;
        }
    }
    return sb_len(current->buf);
}

int linenoiseColumns(void)
{
    struct current current;
    current.output = NULL;
    enableRawMode (&current);
    getWindowSize (&current);
    disableRawMode (&current);
    return current.cols;
}

/**
 * Reads a line from the file handle (without the trailing NL or CRNL)
 * and returns it in a stringbuf.
 * Returns NULL if no characters are read before EOF or error.
 *
 * Note that the character count will *not* be correct for lines containing
 * utf8 sequences. Do not rely on the character count.
 */
static stringbuf *sb_getline(FILE *fh)
{
    stringbuf *sb = sb_alloc();
    int c;
    int n = 0;

    while ((c = getc(fh)) != EOF) {
        char ch;
        n++;
        if (c == '\r') {
            /* CRLF -> LF */
            continue;
        }
        if (c == '\n' || c == '\r') {
            break;
        }
        ch = c;
        /* ignore the effect of character count for partial utf8 sequences */
        sb_append_len(sb, &ch, 1);
    }
    if (n == 0) {
        sb_free(sb);
        return NULL;
    }
    return sb;
}

char *linenoise(const char *prompt)
{
    int count;
    struct current current;
    stringbuf *sb;

    memset(&current, 0, sizeof(current));

    if (enableRawMode(&current) == -1) {
        printf("%s", prompt);
        fflush(stdout);
        sb = sb_getline(stdin);
    }
    else {
        current.buf = sb_alloc();
        current.pos = 0;
        current.nrows = 1;
        current.prompt = prompt;

        count = linenoiseEdit(&current);

        disableRawMode(&current);
        printf("\n");

        sb_free(current.capture);
        if (count == -1) {
            sb_free(current.buf);
            return NULL;
        }
        sb = current.buf;
    }
    return sb ? sb_to_string(sb) : NULL;
}

/* Using a circular buffer is smarter, but a bit more complex to handle. */
int linenoiseHistoryAddAllocated(char *line) {

    if (history_max_len == 0) {
notinserted:
        free(line);
        return 0;
    }
    if (history == NULL) {
        history = (char **)calloc(sizeof(char*), history_max_len);
    }

    /* do not insert duplicate lines into history */
    if (history_len > 0 && strcmp(line, history[history_len - 1]) == 0) {
        goto notinserted;
    }

    if (history_len == history_max_len) {
        free(history[0]);
        memmove(history,history+1,sizeof(char*)*(history_max_len-1));
        history_len--;
    }
    history[history_len] = line;
    history_len++;
    return 1;
}

int linenoiseHistoryAdd(const char *line) {
    return linenoiseHistoryAddAllocated(strdup(line));
}

int linenoiseHistoryGetMaxLen(void) {
    return history_max_len;
}

int linenoiseHistorySetMaxLen(int len) {
    char **newHistory;

    if (len < 1) return 0;
    if (history) {
        int tocopy = history_len;

        newHistory = (char **)calloc(sizeof(char*), len);

        /* If we can't copy everything, free the elements we'll not use. */
        if (len < tocopy) {
            int j;

            for (j = 0; j < tocopy-len; j++) free(history[j]);
            tocopy = len;
        }
        memcpy(newHistory,history+(history_len-tocopy), sizeof(char*)*tocopy);
        free(history);
        history = newHistory;
    }
    history_max_len = len;
    if (history_len > history_max_len)
        history_len = history_max_len;
    return 1;
}

/* Save the history in the specified file. On success 0 is returned
 * otherwise -1 is returned. */
int linenoiseHistorySave(const char *filename) {
    FILE *fp = fopen(filename,"w");
    int j;

    if (fp == NULL) return -1;
    for (j = 0; j < history_len; j++) {
        const char *str = history[j];
        /* Need to encode backslash, nl and cr */
        while (*str) {
            if (*str == '\\') {
                fputs("\\\\", fp);
            }
            else if (*str == '\n') {
                fputs("\\n", fp);
            }
            else if (*str == '\r') {
                fputs("\\r", fp);
            }
            else {
                fputc(*str, fp);
            }
            str++;
        }
        fputc('\n', fp);
    }

    fclose(fp);
    return 0;
}

/* Load the history from the specified file.
 *
 * If the file does not exist or can't be opened, no operation is performed
 * and -1 is returned.
 * Otherwise 0 is returned.
 */
int linenoiseHistoryLoad(const char *filename) {
    FILE *fp = fopen(filename,"r");
    stringbuf *sb;

    if (fp == NULL) return -1;

    while ((sb = sb_getline(fp)) != NULL) {
        /* Take the stringbuf and decode backslash escaped values */
        char *buf = sb_to_string(sb);
        char *dest = buf;
        const char *src;

        for (src = buf; *src; src++) {
            char ch = *src;

            if (ch == '\\') {
                src++;
                if (*src == 'n') {
                    ch = '\n';
                }
                else if (*src == 'r') {
                    ch = '\r';
                } else {
                    ch = *src;
                }
            }
            *dest++ = ch;
        }
        *dest = 0;

        linenoiseHistoryAddAllocated(buf);
    }
    fclose(fp);
    return 0;
}

/* Provide access to the history buffer.
 *
 * If 'len' is not NULL, the length is stored in *len.
 */
char **linenoiseHistory(int *len) {
    if (len) {
        *len = history_len;
    }
    return history;
}
