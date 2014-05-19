
; Select crt0 from startup option

IF !startup

   ; STARTUP undefined so select a default
   
   defc startup = 0

ENDIF

IF startup = 0

   ; CPM test target
   
   ; myzorg selects org address, default 32768
   
   ; STDIN attached to bdos driver
   ; STDOUT attached to bdos driver
   ; STDERR attached to bdos driver
   
   INCLUDE "startup/cpm_crt0.asm"

ENDIF
