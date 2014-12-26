;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IFNDEF startup

   ; startup undefined so select a default
   
   defc startup = 0

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = 0

   ; generic embedded system
   ; no files, no fds

   INCLUDE "startup/embedded_crt_0.asm"

ENDIF
