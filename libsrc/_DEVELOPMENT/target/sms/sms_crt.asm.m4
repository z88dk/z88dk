
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
;; sms standard model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0,
`
   ; sms standard model
   ; no files, no fds

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/sms_crt_0.asm.m4')
')

ifelse(__STARTUP, 1,
`
   ; sms standard model
	;
   ; stdin  = unconnected
	; stdout = sms_01_output_terminal
	; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/sms_crt_1.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; devkitSMS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 16,
`
   ; sms standard model with devkitSMS page zero
   ; no files, no fds

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/sms_crt_16.asm.m4')
')

ifelse(__STARTUP, 17,
`
   ; sms standard model with devkitSMS page zero
	;
   ; stdin  = unconnected
	; stdout = sms_01_output_terminal
	; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/sms_crt_17.asm.m4')
')
