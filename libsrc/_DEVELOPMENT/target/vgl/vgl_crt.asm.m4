
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`zcc_opt.def')

ifdef(`__STARTUP',,`define(`__STARTUP', 1)')
ifdef(`__STARTUP_OFFSET',`define(`__STARTUP', eval(__STARTUP + __STARTUP_OFFSET))')

IFNDEF startup

   ; startup undefined so select a default
   defc startup = __STARTUP

ENDIF


ifelse(__STARTUP, -1, `
   ; STARTUP = -1
   ;
   ; V-Tech Genius Leader
   ; user supplied CRT
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = -1
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   include(`crt.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ram model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0, `
   ; STARTUP = 0
   ;
   ; V-Tech Genius Leader
   ;
   ; RAM payload
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = 0
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   defc __VGL_MODEL = 0
   defc __VGL_ROM_AUTOSTART = 1
   
   include(`startup/vgl_crt_0.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rom model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 1, `
   ; STARTUP = 1
   ;
   ; V-Tech Genius Leader (all)
   ;
   ; ROM code (minimal)
   ;
   ; stdin = --
   ; stdout = --
   ; stderr = --
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = 1
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   defc __VGL_MODEL = 0
   defc __VGL_ROM_AUTOSTART = 1
   
   include(`startup/vgl_crt_1.asm.m4')
')


ifelse(__STARTUP, 2000, `
   ; STARTUP = 2000
   ;
   ; V-Tech Genius Leader 2000
   ;
   ; ROM code
   ;
   ; stdin = terminal/vgl_01_input_2000
   ; stdout = terminal/vgl_01_output_2000
   ; stderr = dup
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = 1
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   defc __VGL_MODEL = 2000
   defc __VGL_ROM_AUTOSTART = 0
   
   include(`startup/vgl_crt_2001.asm.m4')
')


ifelse(__STARTUP, 2001, `
   ; STARTUP = 2001
   ;
   ; V-Tech Genius Leader 2000
   ;
   ; ROM code autostart
   ;
   ; stdin = terminal/vgl_01_input_2000
   ; stdout = terminal/vgl_01_output_2000
   ; stderr = dup
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = 1
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   defc __VGL_MODEL = 2000
   defc __VGL_ROM_AUTOSTART = 1
   
   include(`startup/vgl_crt_2001.asm.m4')
')


ifelse(__STARTUP, 4000, `
   ; STARTUP = 4000
   ;
   ; V-Tech Genius Leader 4000
   ;
   ; ROM code
   ;
   ; stdin = terminal/vgl_01_input_4000
   ; stdout = terminal/vgl_01_output_4000
   ; stderr = dup
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = 1
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   defc __VGL_MODEL = 4000
   defc __VGL_ROM_AUTOSTART = 0
   
   include(`startup/vgl_crt_4001.asm.m4')
')


ifelse(__STARTUP, 4001, `
   ; STARTUP = 4001
   ;
   ; V-Tech Genius Leader 4000
   ;
   ; ROM code autostart
   ;
   ; stdin = terminal/vgl_01_input_4000
   ; stdout = terminal/vgl_01_output_4000
   ; stderr = dup
   ;
   
   IFNDEF __CRTCFG
      defc __CRTCFG = 1
   ENDIF
   
   IFNDEF __MMAP
      defc __MMAP = 0
   ENDIF
   
   defc __VGL_MODEL = 4000
   defc __VGL_ROM_AUTOSTART = 1
   
   include(`startup/vgl_crt_4001.asm.m4')
')

