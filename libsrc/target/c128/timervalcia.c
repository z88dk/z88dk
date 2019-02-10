/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: timervalcia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* convert hz to timer latch value */

ushort timervalcia (ulong Hz)
{
  return(ciaTimerFreq / Hz);
}
