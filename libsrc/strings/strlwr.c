/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */


/*
 *      s t r l w r
 *
 *  Convert a string to lower case.
 *
 *  AMENDMENT HISTORY
 *  ~~~~~~~~~~~~~~~~~
 *  21 Jun 94   DJW   - Casts added to correctly handle characters with
 *                      internal values above 127.
 *
 *   1 Mar 99   djm   - Converted to Small C
 */

#include <string.h>
#include <ctype.h>

char *strlwr(string)
unsigned char *string;
{
    unsigned char *p=string;

    while ((*p = tolower(*p) ) != '\0') {
        ++p;
    }
    return(string);
}
