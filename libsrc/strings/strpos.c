/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 *
 *	$Id: strpos.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */


/*
 *      s t r p o s
 *
 *  Routine to search a string for occurence of a specified
 *  character and return its position in the string.
 *
 *  AMENDMENT HISTORY
 *  ~~~~~~~~~~~~~~~~~
 *  26 Jan 95   DJW   - Added 'const' keyword to parameter definitions
 *
 *   1 Mar 99   djm   - Converted to Small C
 */

#include <string.h>

#define NULL 0

strpos (s, c)
  unsigned char *s;
  int    c;
{
    unsigned *reply;

    if ((reply = strchr (s, c))==NULL) {
        return -1;
    }
    return (reply - s);
}

