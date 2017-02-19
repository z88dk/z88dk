
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

ifdef(`__STARTUP',,`define(`__STARTUP', 0)')

IFNDEF startup

   ; startup undefined so select a default
   
   defc startup = 0

ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; user supplied crt ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, -1,
`
   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF
   
   include(`crt.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cp/m native console ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0,
`
   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
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

   include(`startup/cpm_crt_0.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cp/m z88dk console (one window) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 4,
`
   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
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

   include(`startup/cpm_crt_4.asm.m4')
')
