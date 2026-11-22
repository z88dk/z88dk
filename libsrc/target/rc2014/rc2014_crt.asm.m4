
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RC2014 CRT0 SELECTOR                                         ;
; Maps -startup=N / SUBTYPE to startup/* and __CRTCFG.         ;
; Full matrix: context.md Phase 1.                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUBTYPE   startup  CRTCFG  CPU     startup file              drivers
; (user)       -1       *    —       crt.asm.m4 (user)         user
; acia          0       0    Z80     rc2014_crt_0              rc_01 acia; stderr dup
; acia85        2       1    8085    rc2014_crt_2              classic f*cons_acia
; sio           4       2    Z80     rc2014_crt_4              sioa+siob; stderr+ttyerr
; uart          8       3    Z80     rc2014_crt_8              uarta+uartb; dups
; uart85       16       4    8085    rc2014_crt_16             classic f*cons_uarta
; basic        32       5    Z80     rc2014_crt_32  (default)  rc_01 basic; stderr dup
; basic85      64       6    8085    rc2014_crt_64             classic f*cons_basic
; cpm         128       7    Z80     rc2014_crt_128            cpm_01 + rdr/pun/lst
; none        256       8    Z80     rc2014_crt_256            no default drivers
;
; Simplified serial (character_00): use -subtype=none +
; CRT_INCLUDE_DRIVER_INSTANTIATION + m4_rc_00_* (see context.md).
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`zcc_opt.def')

ifdef(`__STARTUP',,`define(`__STARTUP', 32)')
ifdef(`__STARTUP_OFFSET',`define(`__STARTUP', eval(__STARTUP + __STARTUP_OFFSET))')

IFNDEF startup

   ; startup undefined so select a default - basic for z80

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
;; acia driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0,
`
   ; acia drivers installed on stdin, stdout, stderr

   IFNDEF __CRTCFG

      defc __CRTCFG = 0

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_0.asm.m4')
')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8085 acia driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 2,
`
   ; acia drivers installed on stdin, stdout, stderr
   ; 8085 cpu

   IFNDEF __CRTCFG

      defc __CRTCFG = 1

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_2.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sio driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 4,
`
   ; sioa drivers installed on stdin, stdout, stderr
   ; siob drivers installed on ttyin, ttyout, ttyerr

   IFNDEF __CRTCFG

      defc __CRTCFG = 2

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_4.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; uart driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 8,
`
   ; uart 16550 drivers installed on stdin, stdout, stderr
   ; uart 16550 drivers installed on ttyin, ttyout, ttyerr

   IFNDEF __CRTCFG

      defc __CRTCFG = 3

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_8.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8085 uart driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 16,
`
   ; uart 16550 drivers installed on stdin, stdout, stderr
   ; uart 16550 drivers installed on ttyin, ttyout, ttyerr
   ; 8085 cpu

   IFNDEF __CRTCFG

      defc __CRTCFG = 4

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_16.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 32,
`
   ; basic drivers installed on stdin, stdout, stderr

   IFNDEF __CRTCFG

      defc __CRTCFG = 5

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_32.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8085 basic driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 64,
`
   ; basic drivers installed on stdin, stdout, stderr
   ; 8085 cpu

   IFNDEF __CRTCFG

      defc __CRTCFG = 6

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_64.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cp/m native console ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 128,
`

   ; stdin  = cpm_00_input_cons (bdos function 10)
   ; stdout = cpm_00_output_cons (bdos function 2)
   ; stderr = dup(stdout)
   ; stdrdr = cpm_00_input_reader (bdos function 3)
   ; stdpun = cpm_00_output_punch (bdos function 4)
   ; stdlst = cpm_00_output_list (bdos function 5)

   IFNDEF __CRTCFG

      defc __CRTCFG = 7

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_128.asm.m4')
')



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; none ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 256,
`
   ; nothing on stdin, stdout, stderr

   IFNDEF __CRTCFG

      defc __CRTCFG = 8

   ENDIF

   IFNDEF __MMAP

      defc __MMAP = 0

   ENDIF

   include(`startup/rc2014_crt_256.asm.m4')
')
