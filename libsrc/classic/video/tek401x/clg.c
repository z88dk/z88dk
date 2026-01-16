#include <graphics.h>

#include "tek.h"

/* Handy docs from PGPLOT

C Implementation Notes:
C
C Standard Tektronix codes:
C   graph mode: [GS]=char(29)
C   alpha mode: [US]=char(31)
C The emulators provide various extensions to basic Tektronix
C operation, using the following codes:
C    [SOH]=char(1),  [STX]=char(2),  [ETX]=char(3),
C    [DLE]=char(16), [CAN]=char(24), [ESC]=char(27)
C
C Enter Tektronix mode (from VT100 mode):
C   graphon: automatic on receipt of [GS]
C   gterm:   [GS]
C   tek:     not available
C   retro:   automatic on receipt of [GS]
C   xterm:   [ESC][?38h
C   zstem:   [ESC][?38h
C   v603:    [GS]
C   krm3:    [ESC][?38h
C Return to VT100 mode (from Tektronix mode):
C   graphon: [CAN]
C   gterm:   [CAN]
C   tek:     not available
C   xterm:   [ESC][ETX]
C   zstem:   [CAN]
C   v603:    [CAN][ESC][?38l
C   krm3:    [ESC][?38l
C Rectangle fill:
C   graphon: draw the diagonal in special rectangle mode, 
C     entered with [ESC][STX], exit with [ESC][ETX]
C   v603: bottom corner and rectangle width
C   krm3: bottom corner and rectangle width
C   vmac: use panel boundary commands [ESC]LP and [ESC]LE
C Color index zero (erase):
C   graphon select erase:        [ESC][DLE]
C   graphon unselect erase:      [ESC][SOH]
C   retro,v603 select erase:     [ESC]/1d
C   retro,v603 unselect erase:   [ESC]/0d
C   krm3, select erase:          [ESC][0;30m
C   krm3, unselect erase:        [ESC][0;37m

*/




void clg() {
  // Open the Tek window automatically for xterm
  char *msg = "\x1b[?38h";
  char *ptr = msg;
  
  while (*ptr) __tek_outc(*ptr++);

  __tek_outc(0x1d); // GC
  __tek_outc(0x1B);
  __tek_outc(0x0c);
//__tek_outc(0x0d);__tek_outc(0x0a);
}


