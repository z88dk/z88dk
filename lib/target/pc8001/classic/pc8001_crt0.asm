;       NEC PC-8001 stub
;
;       Based on the PC-8801 monitor-mode stub
;
;       The subtype chooses where the program runs from:
;         (none), 32k   $8000
;         16k           $C000  (PC8001_SUBTYPE_16K)
;         allram        $0000  (PC8001_ALLRAM), also what -clib=mk2 does
;         disk          $0000, allram that boots from a disc (PC8001_DISK)
;
;       Allram is for the PC-8001mkII. The program is built to run from $0000
;       with the ROM switched out. A bootstrap, the first file of the tape,
;       loads it over the ROM. The graphics RAM is paged in at $8000 - $BFFF,
;       which the program stays clear of: the routines that run with it paged in
;       are in code_driver, at the start of the program.
;

    MODULE  pc8001_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main

    PUBLIC  l_dcal
    PUBLIC  __Exit

    defc    __CPU_CLOCK = 4000000

IF DEFINED_PC8001_ALLRAM
    defc    __crt_pc8001_allram = 1
ELSE
    defc    __crt_pc8001_allram = 0
ENDIF

    ; -clib=mk2 enables the hires graphics of the PC-8001mkII. Without it the
    ; hires entry points are redirected to l_ret so none of that code is linked.
    PUBLIC  __CLIB_PC8001_HIRES
IF DEFINED_CLIB_PC8001_HIRES
    defc    __CLIB_PC8001_HIRES = CLIB_PC8001_HIRES
ELSE
    defc    __CLIB_PC8001_HIRES = 0
ENDIF

IF !__CLIB_PC8001_HIRES
    EXTERN  l_ret
    PUBLIC  __pc8001_hires_printc
    PUBLIC  __pc8001_hires_vpeek
    PUBLIC  __pc8001_hires_scrollup
    PUBLIC  __pc8001_hires_cls
    PUBLIC  __pc8001_hires_setmode
    PUBLIC  __pc8001_hires_plot
    PUBLIC  __pc8001_hires_unplot
    PUBLIC  __pc8001_hires_xor
    PUBLIC  __pc8001_hires_point
    defc    __pc8001_hires_printc = l_ret
    defc    __pc8001_hires_vpeek = l_ret
    defc    __pc8001_hires_scrollup = l_ret
    defc    __pc8001_hires_cls = l_ret
    defc    __pc8001_hires_setmode = l_ret
    defc    __pc8001_hires_plot = l_ret
    defc    __pc8001_hires_unplot = l_ret
    defc    __pc8001_hires_xor = l_ret
    defc    __pc8001_hires_point = l_ret
ENDIF

    ; The subtype sets where the program runs from (CRT_ORG_CODE can still be given)
    IFNDEF CRT_ORG_CODE
      IF __crt_pc8001_allram
        defc CRT_ORG_CODE  = $0000
      ELIF DEFINED_PC8001_SUBTYPE_16K
        defc CRT_ORG_CODE  = $c000
      ELSE
        defc CRT_ORG_CODE  = $8000
      ENDIF
    ENDIF

    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 25
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__fputc_cons_generic = 1

IF __crt_pc8001_allram
    ; The hires routines can only be linked into an allram program
    PUBLIC  PC8001_HIRES_NEEDS_ALLRAM
    defc    PC8001_HIRES_NEEDS_ALLRAM = 1
    ; There is no N-BASIC to return to. The stack goes below the text screen
    defc    TAR__register_sp = $f300
    ; No interrupts are used
    defc    TAR__crt_enable_eidi = $01
    defc    TAR__crt_on_exit = $10001
    defc    TAR__crt_enable_rst = $0000
  IFNDEF CRT_ENABLE_NMI
    defc    TAR__crt_enable_nmi = 1
    EXTERN  asm_nmi_handler
    defc    _z80_nmi = asm_nmi_handler
  ENDIF
    EXTERN  asm_im1_handler
ELSE
    ; -1 = leave sp as N-BASIC set it. Override with -pragma-define:REGISTER_SP=
    ; (text VRAM is at $F300, so that is the highest usable stack address)
    defc    TAR__register_sp = -1
ENDIF
    INCLUDE "crt/classic/crt_rules.inc"

    org CRT_ORG_CODE

IF __crt_pc8001_allram

    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.inc"

program:
    di
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init

    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)

ELSE

;----------------------
; Execution starts here
;----------------------
start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init

    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"

__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)

ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

IF __crt_pc8001_allram
  IF DEFINED_PC8001_DISK
    ; The boot sector of the disc
    INCLUDE "target/pc8001/classic/bootstrap_disk.asm"
  ELSE
    ; The bootstrap is a file of its own on the tape
    INCLUDE "target/pc8001/classic/bootstrap.asm"
  ENDIF
ENDIF
