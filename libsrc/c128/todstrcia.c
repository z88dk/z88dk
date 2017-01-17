/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: todstrcia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* convert cia tod bcd format to string */

void todstrcia (uchar *TOD, char *TODStr)
{
  if((TOD[0] & 0x80) == 0)
  {
    todcharcia(TOD[0],&TODStr[0]);
    TODStr[9] = 'A';
  }
  else
  {
    todcharcia((TOD[0] & 0x7F),&TODStr[0]);
    TODStr[9] = 'P';
  }
  TODStr[8] = ' ';
  TODStr[10] = 'M';
  TODStr[2] = ':';
  todcharcia(TOD[1],&TODStr[3]);
  TODStr[5] = ':';
  todcharcia(TOD[2],&TODStr[6]);
  //TODStr[sizeof(ciaTODStr)-1] = 0;
  TODStr[11] = 0;
}

