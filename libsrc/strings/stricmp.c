/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */



/*
 *      s t r i c m p
 *
 *  compare string s1 to s2 - ignore case
 *
 *  returns:
 *      -ve     less than
 *      0       equal
 *      +ve     greater than
 *
 *  AMENDMENT HISTORY
 *  ~~~~~~~~~~~~~~~~~
 *  21 Jun 94   DJW   - Casts added to correctly handle characters with
 *                      internal values above 127.
 *
 *  28 Aug 94   DJW   - Changes to make certain that string treated as
 *                      'unsigned char' as required by ANSI.
 *
 *  26 Jan 95   DJW   - Added 'const' keywords to parameter definitions
 *
 *   1 Mar 99   djm   - Converted to Small C (no const etc)
 */


/*
 *      A little black magic..
 */


#include <string.h>


stricmp(scan1, scan2)
unsigned char *scan1;
unsigned char *scan2;
{
    unsigned char c1, c2;

    do {
        c1 = tolower(*scan1++);
        c2 = tolower(*scan2++);
    } while (c1 && (c1 == c2));

    return(c1 - c2);
}

