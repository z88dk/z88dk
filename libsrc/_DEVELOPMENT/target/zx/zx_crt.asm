
; Select crt0 from startup option

INCLUDE "zcc_opt.def"

IF !startup

   ; startup undefined so select a default
   
   defc startup = 1

ENDIF

IF startup = 1

   ; zx spectrum test target
   
   ; myzorg selects org address, default 32768
   
   ; STDIN attached to keyboard driver that reads LASTK for keypresses, no edit buffer
   ; STDOUT attached to fzx driver, default font is ff_ao_SoixanteQuatre
   ; STDERR attached to fzx driver, default font is ff_ao_SoixanteQuatre
   
   INCLUDE "startup/zx_crt1.asm"

ENDIF
