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
;; cp/m native console ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = 0

   IFNDEF __CRTDEF
   
      defc __CRTDEF = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   ; stdin  = cpm_00_input_cons (bdos function 10)
   ; stdout = cpm_00_output_cons (bdos function 2)
   ; stderr = dup(stdout)
   ; stdrdr = cpm_00_input_reader (bdos function 3)
   ; stdpun = cpm_00_output_punch (bdos function 4)
   ; stdlst = cpm_00_output_list (bdos function 5)

   INCLUDE "startup/cpm_crt_0.asm"

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cp/m z88dk console (one window) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF startup = 4

   IFNDEF __CRTDEF
   
      defc __CRTDEF = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   ; stdin  = cpm_01_input_kbd_dcio (bdos function 6)
   ; stdout = cpm_01_output_dcio (bdos function 6)
   ; stderr = dup(stdout)
   ; stdrdr = cpm_00_input_reader (bdos function 3)
   ; stdpun = cpm_00_output_punch (bdos function 4)
   ; stdlst = cpm_00_output_list (bdos function 5)

   INCLUDE "startup/cpm_crt_4.asm"

ENDIF
