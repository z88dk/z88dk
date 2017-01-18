/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: todcharcia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* convert bcd byte to 2 char base 10 */

void todcharcia (uchar Bcd, char *TODStr)
{
  TODStr[0] = (Bcd >> 4)+48;
  TODStr[1] = (Bcd & 0x0F)+48;
}

