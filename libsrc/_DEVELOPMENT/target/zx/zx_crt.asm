;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMAND LINE OPTION ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IF !startup

   ; startup undefined so select a default
   
   defc startup = 1

ENDIF

IF startup = 1

   ; zx spectrum fzx target
   ; romless target by default
   
   ; command line:
   ;
   ; -zorg=nnnnn sets org address, default 32768
   
   ; c source:
   ;
   ; #pragma output STACKPTR=nnnnn sets initial stack address
   
   ; statically declared:
   ;
   ; global _fzx holds fzx state (extern struct fzx_state fzx)
   ; global _cons_attr_p holds background attribute (extern uint8_t cons_attr_p)
   
   ; stream drivers can be changed by re-making the crt
   ;
   ; STDIN attached to in_inkey driver, level 1 line mode with edit buffer
   ; STDOUT attached to fzx driver, default font is ff_ao_SoixanteQuatre
   ; STDERR attached to fzx driver, default font is ff_ao_SoixanteQuatre
   
   INCLUDE "startup/zx_crt1.asm"

ENDIF
