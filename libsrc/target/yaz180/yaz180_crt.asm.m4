
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; YAZ180 CRT0 SELECTOR                                         ;
; Maps -startup=N / SUBTYPE to startup/* and __CRTCFG.         ;
; Full matrix: context.md Phase 1.                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUBTYPE   startup  CRTCFG  startup file         drivers
; (user)       -1       *    crt.asm.m4           user
; rom           0       0    yaz180_crt_0         asci0+asci1; dups
; app          16       1    yaz180_crt_16        asci0+asci1 (cfg default)
; cpm          64       2    yaz180_crt_64        cpm_00 cons + rdr/pun/lst
; none        256       3    yaz180_crt_256       no default drivers
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`zcc_opt.def')

ifdef(`__STARTUP',,`define(`__STARTUP', 16)')
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
;; yabios drivers ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0,
`
   ; yabios asci0 drivers installed on stdin, stdout, stderr
   ; yabios asci1 drivers installed on ttyin, ttyout, ttyerr

   IFNDEF __CRTCFG

      defc __CRTCFG = 0

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/yaz180_crt_0.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; app drivers;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 16,
`
   ; yabios asci0 drivers installed on stdin, stdout, stderr
   ; yabios asci1 drivers installed on ttyin, ttyout, ttyerr

   IFNDEF __CRTCFG

      defc __CRTCFG = 1

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/yaz180_crt_16.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cp/m native console ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 64,
`

   ; stdin  = cpm_00_input_cons (bdos function 10)
   ; stdout = cpm_00_output_cons (bdos function 2)
   ; stderr = dup(stdout)
   ; stdrdr = cpm_00_input_reader (bdos function 3)
   ; stdpun = cpm_00_output_punch (bdos function 4)
   ; stdlst = cpm_00_output_list (bdos function 5)

   IFNDEF __CRTCFG

      defc __CRTCFG = 2

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/yaz180_crt_64.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; none ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 256,
`
   ; nothing on stdin, stdout, stderr

   IFNDEF __CRTCFG

      defc __CRTCFG = 3

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/yaz180_crt_256.asm.m4')
')
