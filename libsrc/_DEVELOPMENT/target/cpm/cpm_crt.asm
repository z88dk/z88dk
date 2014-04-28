
; Select crt0 from __STARTUP option

IF !__STARTUP

   ; STARTUP undefined so select a default
   
   defc __STARTUP = 0

ENDIF

IF __STARTUP = 0

   ; CPM test target
   
   ; myzorg selects org address, default 32768
   
   ; STDIN attached to bdos driver
   ; STDOUT attached to bdos driver
   ; STDERR attached to bdos driver
   
   INCLUDE "startup/cpm_crt0.asm"

ENDIF
