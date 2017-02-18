
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
;; zx48 ram model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

   include(`startup/zx_crt_0.asm.m4')
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

   include(`startup/zx_crt_1.asm.m4')
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

   include(`startup/zx_crt_4.asm.m4')
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

   include(`startup/zx_crt_5.asm.m4')
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

   include(`startup/zx_crt_8.asm.m4')
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

   include(`startup/zx_crt_9.asm.m4')
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

   include(`startup/zx_crt_31.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; if 2 cartridge ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 32,
`
   ; if 2 cartridge
   ; standard 32 column display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_32.asm.m4')
')

ifelse(__STARTUP, 33,
`
   ; if 2 cartridge
   ; standard 32 column display tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_33.asm.m4')
')

ifelse(__STARTUP, 36,
`
   ; if 2 cartridge
   ; 64 column display using fixed width 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_36.asm.m4')
')

ifelse(__STARTUP, 37,
`
   ; if 2 cartridge
   ; 64 column display using fixed width 4x8 font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_37.asm.m4')
')

ifelse(__STARTUP, 40,
`
   ; if 2 cartridge
   ; fzx terminal using ff_ind_Termino font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_40.asm.m4')
')

ifelse(__STARTUP, 41,
`
   ; if 2 cartridge
   ; fzx terminal using ff_ind_Termino font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_41.asm.m4')
')

ifelse(__STARTUP, 63,
`
   ; if 2 cartridge
   ; no instantiated FILEs

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zx_crt_63.asm.m4')
')
