/*
 *  Write the file offset into the FCB
 *
 *  27/1/2002 - djm
 *
 *  $Id: _putoffset.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */


#include <cpm.h>


void _putoffset(unsigned char *where,long offset)
{
    where[0] = ((int)offset) & 0xFF;
    where[1] = ((int)(offset >> 8 )) & 0xFF;
    where[2] = ((int)(offset >> 16)) & 0xFF;
}

