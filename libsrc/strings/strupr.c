/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 *
 *	$Id: strupr.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */



/*
 *      s t r u p r
 *
 * AMENDMENT HISTORY
 * ~~~~~~~~~~~~~~~~~
 *  28 Aug 94   DJW   - Fixed problem with cast needed for character values
 *                      outside the range 0 to 127.
 *
 *   1 Mar 99   djm   - Converted to Small C
 */


#include <string.h>
#include <ctype.h>


char *strupr(string)
unsigned char *string;
{
    unsigned char *p=string;

    while ((*p = toupper(*p) ) != '\0') {
        ++p;
    }
    return(string);
}

