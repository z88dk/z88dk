
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

ifelse(__STARTUP, 16,
`
   ; standard 64 column timex hi-res display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_16.asm.m4')
')

ifelse(__STARTUP, 20,
`
   ; standard 128 column timex hi-res display using 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_128 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_20.asm.m4')
')

ifelse(__STARTUP, 24,
`
   ; fzx terminal using ff_ind_Termino font in timex hi-res mode
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_24.asm.m4')
')

ifelse(__STARTUP, 30,
`
   ; standard 32 column display using rst 0x10
   ;
   ; stdin  = none
   ; stdout = zx_01_output_rom_rst full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_30.asm.m4')
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; esxdos dot command ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 256,
`
   ; standard 32 column display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_256.asm.m4')
')

ifelse(__STARTUP, 257,
`
   ; standard 32 column display tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_257.asm.m4')
')

ifelse(__STARTUP, 260,
`
   ; 64 column display using fixed width 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_260.asm.m4')
')

ifelse(__STARTUP, 261,
`
   ; 64 column display using fixed width 4x8 font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_261.asm.m4')
')

ifelse(__STARTUP, 264,
`
   ; fzx terminal using ff_ind_Termino font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_264.asm.m4')
')

ifelse(__STARTUP, 265,
`
   ; fzx terminal using ff_ind_Termino font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_265.asm.m4')
')

ifelse(__STARTUP, 272,
`
   ; standard 64 column timex hi-res display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_272.asm.m4')
')

ifelse(__STARTUP, 276,
`
   ; standard 128 column timex hi-res display using 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_128 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_276.asm.m4')
')

ifelse(__STARTUP, 280,
`
   ; fzx terminal using ff_ind_Termino font in timex hi-res mode
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_280.asm.m4')
')

ifelse(__STARTUP, 286,
`
   ; standard 32 column display using rst 0x10
   ;
   ; stdin  = none
   ; stdout = zx_01_output_rom_rst full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_286.asm.m4')
')

ifelse(__STARTUP, 287,
`
   ; no instantiated FILEs

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/zxn_crt_287.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; esxdos extended dot command ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 512,
`
   ; standard 32 column display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_512.asm.m4')
')

ifelse(__STARTUP, 513,
`
   ; standard 32 column display tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_513.asm.m4')
')

ifelse(__STARTUP, 516,
`
   ; 64 column display using fixed width 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_516.asm.m4')
')

ifelse(__STARTUP, 517,
`
   ; 64 column display using fixed width 4x8 font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_517.asm.m4')
')

ifelse(__STARTUP, 520,
`
   ; fzx terminal using ff_ind_Termino font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_520.asm.m4')
')

ifelse(__STARTUP, 521,
`
   ; fzx terminal using ff_ind_Termino font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_521.asm.m4')
')

ifelse(__STARTUP, 528,
`
   ; standard 64 column timex hi-res display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_528.asm.m4')
')

ifelse(__STARTUP, 532,
`
   ; standard 128 column timex hi-res display using 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_128 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_532.asm.m4')
')

ifelse(__STARTUP, 536,
`
   ; fzx terminal using ff_ind_Termino font in timex hi-res mode
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_536.asm.m4')
')

ifelse(__STARTUP, 542,
`
   ; standard 32 column display using rst 0x10
   ;
   ; stdin  = none
   ; stdout = zx_01_output_rom_rst full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_542.asm.m4')
')

ifelse(__STARTUP, 543,
`
   ; no instantiated FILEs

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 1
   
   ENDIF

   include(`startup/zxn_crt_543.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; nextos extended dot command ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 768,
`
   ; standard 32 column display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_768.asm.m4')
')

ifelse(__STARTUP, 769,
`
   ; standard 32 column display tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_32_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_769.asm.m4')
')

ifelse(__STARTUP, 772,
`
   ; 64 column display using fixed width 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_772.asm.m4')
')

ifelse(__STARTUP, 773,
`
   ; 64 column display using fixed width 4x8 font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_char_64_tty_z88dk full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_773.asm.m4')
')

ifelse(__STARTUP, 776,
`
   ; fzx terminal using ff_ind_Termino font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_776.asm.m4')
')

ifelse(__STARTUP, 777,
`
   ; fzx terminal using ff_ind_Termino font tty_z88dk terminal
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = zx_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_777.asm.m4')
')

ifelse(__STARTUP, 784,
`
   ; standard 64 column timex hi-res display
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_64 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_784.asm.m4')
')

ifelse(__STARTUP, 788,
`
   ; standard 128 column timex hi-res display using 4x8 font
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_char_128 full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_788.asm.m4')
')

ifelse(__STARTUP, 792,
`
   ; fzx terminal using ff_ind_Termino font in timex hi-res mode
   ;
   ; stdin  = zx_01_input_kbd_inkey
   ; stdout = tshr_01_output_fzx full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_792.asm.m4')
')

ifelse(__STARTUP, 798,
`
   ; standard 32 column display using rst 0x10
   ;
   ; stdin  = none
   ; stdout = zx_01_output_rom_rst full screen
   ; stderr = dup(stdout)

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_798.asm.m4')
')

ifelse(__STARTUP, 799,
`
   ; no instantiated FILEs

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 3
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 2
   
   ENDIF

   include(`startup/zxn_crt_799.asm.m4')
')
