/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: donepcx.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <stdio.h>
#include <c128/vdc.h>
#include <c128/pcx.h>

extern FILE *pcxFile;

void donepcx(void)
{
  fclose(pcxFile);
}

