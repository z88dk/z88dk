;       NEC PC-8001 stub
;
;       Based on the PC-8801 monitor-mode stub
;
;       CRT_ORG_CODE is set by the subtype (-subtype=16k / -subtype=32k)
;

    MODULE  pc8001_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main

    PUBLIC  l_dcal
    PUBLIC  __Exit

    defc    __CPU_CLOCK = 4000000

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
    PUBLIC  __pc8001_hires_init
    PUBLIC  __pc8001_hires_printc
    PUBLIC  __pc8001_hires_vpeek
    PUBLIC  __pc8001_hires_scrollup
    PUBLIC  __pc8001_hires_cls
    PUBLIC  __pc8001_hires_setmode
    PUBLIC  __pc8001_hires_plot
    PUBLIC  __pc8001_hires_unplot
    PUBLIC  __pc8001_hires_xor
    PUBLIC  __pc8001_hires_point
    defc    __pc8001_hires_init = l_ret
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

    IFNDEF CRT_ORG_CODE
        defc CRT_ORG_CODE  = $8000
    ENDIF

    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 25
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__fputc_cons_generic = 1
    ; -1 = leave sp as N-BASIC set it. Override with -pragma-define:REGISTER_SP=
    ; (text VRAM is at $F300, so that is the highest usable stack address)
    defc    TAR__register_sp = -1
    INCLUDE "crt/classic/crt_rules.inc"

    org CRT_ORG_CODE

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

    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"
