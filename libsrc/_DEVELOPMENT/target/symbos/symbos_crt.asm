;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IFNDEF startup

   ; startup undefined so select a default
   
   defc startup = 0

ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; user supplied crt ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = -1

   INCLUDE "crt.asm"

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; symbos native console ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = 0

   IFNDEF __CRTDEF
   
      defc __CRTDEF = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   ; stdin  = 
   ; stdout = 
   ; stderr = dup(stdout)

   INCLUDE "startup/symbos_crt_0.asm"

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; symbos z88dk console (one window) ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = 4

   IFNDEF __CRTDEF
   
      defc __CRTDEF = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   ; stdin  = 
   ; stdout = 
   ; stderr = dup(stdout)

   INCLUDE "startup/symbos_crt_4.asm"

ENDIF
