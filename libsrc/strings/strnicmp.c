/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */




/*
 *  s t r n i c m p
 *
 *  Case independent comparison of strings
 *
 * AMENDMENT HISTORY
 * ~~~~~~~~~~~~~~~~~
 *  14 Oct 93   DJW   - Removed need for fancy comparison tests on exit path
 *                      by making c1 and c2 into unsigned values.
 *
 *  28 Aug 94   DJW   - Changes to make certain that string treated as
 *                      'unsigned char' as required by ANSI.
 *
 *  26 Jan 95   DJW   - Added 'const' keywords to parameters
 *
 *   1 Mar 99   djm   - Converted over to Small C
 */

#include <string.h>

strnicmp(str1, str2, len)
  unsigned char *str1;
  unsigned char *str2;
  int len;
{
    unsigned char c1,c2;

    do {
        if (--len < 0) {
            return 0;
        }
        c1 = tolower(*str1++);
        c2 = tolower(*str2++);
    } while(c1 && (c1 == c2));

    return(c1 - c2);
}

