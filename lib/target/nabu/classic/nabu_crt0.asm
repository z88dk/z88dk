;
;	Startup for Nabu
;

    module  nabu_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF


    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 3570000

    PUBLIC  PSG_AY_REG
    PUBLIC  PSG_AY_DATA
    defc    PSG_AY_REG = $40
    defc    PSG_AY_DATA = $41

    EXTERN  cpm_platform_init
    EXTERN  vdp_set_mode

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = $ff00
    defc    TAR__fputc_cons_generic = 1

    defc    CRT_ORG_CODE = $140d

IFNDEF CLIB_DEFAULT_SCREEN_MODE
    defc    CLIB_DEFAULT_SCREEN_MODE = 2
ENDIF

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    defb    0,0,0

start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    di
    ld      a,$ff
    ld      i,a
    im      2
    call    crt0_init
    ; Code is shared with CP/M. This is a noop, but pulls in code
    ; into crt0_init and crt0_exit
    call    cpm_platform_init 
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    push    hl
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"

    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

    INCLUDE	"crt/classic/crt_section.inc"
    INCLUDE "target/nabu/classic/nabu_hccabuf.asm"

