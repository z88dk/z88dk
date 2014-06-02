
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMAND LINE OPTION ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IF !startup

   ; STARTUP undefined so select a default
   
   defc startup = 0

ENDIF

IF startup = 0

   ; CPM test target
   
   ; command line:
   ;
   ; -zorg=nnnnn sets org address, default 32768

   ; c source:
   ;
   ; #pragma output noprotectmsdos
   ; removes MSDOS protect header from binary

   ; stream drivers can be changed by re-making the crt
   ;   
   ; STDIN attached to bdos_6 driver, level 1 line mode with edit buffer
   ; STDOUT attached to bdos_2 driver
   ; STDERR attached to bdos_2 driver
   
   INCLUDE "startup/cpm_crt0.asm"

ENDIF
