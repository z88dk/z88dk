
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`zcc_opt.def')

ifdef(`__STARTUP',,`define(`__STARTUP', 0)')
ifdef(`__STARTUP_OFFSET',`define(`__STARTUP', eval(__STARTUP + __STARTUP_OFFSET))')

IFNDEF startup

   ; startup undefined so select a default
   
   defc startup = __STARTUP

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
;; zx next ram model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0,
`
   ; standard 32 column display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_0.asm.m4')
')

ifelse(__STARTUP, 1,
`
   ; standard 32 column display tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_1.asm.m4')
')

ifelse(__STARTUP, 4,
`
   ; 64 column display using fixed width 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_4.asm.m4')
')

ifelse(__STARTUP, 5,
`
   ; 64 column display using fixed width 4x8 font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_5.asm.m4')
')

ifelse(__STARTUP, 8,
`
   ; fzx terminal using ff_ind_Termino font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_8.asm.m4')
')

ifelse(__STARTUP, 9,
`
   ; fzx terminal using ff_ind_Termino font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_9.asm.m4')
')

ifelse(__STARTUP, 31,
`
   ; no instantiated FILEs

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_31.asm.m4')
')
