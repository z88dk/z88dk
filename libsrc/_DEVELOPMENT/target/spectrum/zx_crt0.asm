
; Select crt0 from STARTUP option

IF !STARTUP

   ; STARTUP undefined so select a default
   
   defc STARTUP = 0

ENDIF

IF STARTUP = 0

   ; zx spectrum test target
   
   ; myzorg selects org address, default 32768
   
   ; STDIN attached to keyboard driver that reads LASTK for keypresses, no edit buffer
   ; STDOUT attached to fzx driver, default font is ff_ao_SoixanteQuatre
   ; STDERR attached to fzx driver, default font is ff_ao_SoixanteQuatre
   
   INCLUDE "startup/zx_crt0.asm"

ENDIF
