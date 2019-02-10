/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clearsid.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* clear all sid registers */

void clearsid(void)
{
  register ushort I;

  for(I = sidVoice1; I <= sidEnvGen3; I++)
    outp(I,0);
}

