

#include "tek.h"


static int current_mode = 0;
// GS = 0x1d
// FS = 0x1c
// US = 0x1f
void __tek_mode(int mode)
{
   if ( current_mode == mode ) return;

   switch ((unsigned char)((current_mode << 2) | mode) ) {
   case MODE_ALPHA:
   case (MODE_POINT << 2) | MODE_ALPHA:
   case (MODE_GRAPH << 2) | MODE_ALPHA:
       __tek_outc(0x1f);
       break;
   case (MODE_POINT << 2) | MODE_GRAPH:
       __tek_outc(0x1f);  // Go to alpha first of all
   case (MODE_ALPHA << 2) | MODE_GRAPH:
   case MODE_GRAPH:
       __tek_outc(0x1d);
       break;
   case (MODE_ALPHA << 2) | MODE_POINT:
   case (MODE_GRAPH << 2) | MODE_POINT:
   case MODE_POINT:
       __tek_outc(0x1c);
       break;
   }
   current_mode = mode;
}



