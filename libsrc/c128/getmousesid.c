/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: getmousesid.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <c128/sid.h>

extern uchar sidPot1X;
extern uchar sidPot1Y;
extern uchar sidPot2X;
extern uchar sidPot2Y;

extern uchar sidMouse1X;
extern uchar sidMouse1Y;
extern uchar sidMouse2X;
extern uchar sidMouse2Y;

uchar sidMouse1X = 0;
uchar sidMouse1Y = 0;
uchar sidMouse2X = 0;
uchar sidMouse2Y = 0;

/* read 1351 compatible mouse in port 1 and 2 */

void getmousesid(void)
{
  if((sidPot1X & 0x01) == 0)
    sidMouse1X = (sidPot1X & 0x7F) >> 1;
  if((sidPot1Y & 0x01) == 0)
    sidMouse1Y = (sidPot1Y & 0x7F) >> 1;
  if((sidPot2X & 0x01) == 0)
    sidMouse2X = (sidPot2X & 0x7F) >> 1;
  if((sidPot2Y & 0x01) == 0)
    sidMouse2Y = (sidPot2Y & 0x7F) >> 1;
}
