;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IF !startup

   ; startup undefined so select a default
   
   defc startup = 1

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = 1

   ; zx spectrum
   ; comments here
   
   INCLUDE "startup/zx_crt_1.asm"

ENDIF
