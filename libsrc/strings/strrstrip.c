/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 *
 *	$Id: strrstrip.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */


/*
 *          s t r r s t r i p
 *
 *  Routine to remove any occurrences of the given character
 *  from the end of a string.
 *
 *  AMENDMENT HISTORY
 *  ~~~~~~~~~~~~~~~~~
 *  25 OCT 96   DJW   - First version
 *
 *   1 Mar 99   djm   - Converted to Small C
 */

#include <string.h>


char *strrstrip(unsigned char *s, unsigned char ch)
{
    int len;
    len = strlen(s);

/*
 *      djm, was len > 0  here
 */
    while (len  && s[len-1] == ch)
    {
        len--;
    }
    s[len] = '\0';
    return s;
}

