;
;	Startup for Ondra
;

    module ondra_crt0


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
    EXTERN  __BSS_END_tail


IFNDEF CLIB_FGETC_CONS_DELAY
    defc    CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    CONSOLE_ROWS = 32
    defc    CONSOLE_COLUMNS = 40
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 0xbfff
    defc    TAR__crt_on_exit = $0000
    defc	CRT_KEY_DEL = 127
    defc	__CPU_CLOCK = 2000000
    INCLUDE "crt/classic/crt_rules.inc"


IF      !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x4000
ENDIF

    org     CRT_ORG_CODE - 5

    defb    0x01		;data block
    defw    CRT_ORG_CODE  ;starting address
    defw    +((__BSS_END_tail - CRT_ORG_CODE - 3))

program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    ld      a, @00000001
    out     (3),a
    di
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      bc,0
    push    bc
    push    bc
    call    _main
    pop     bc
    pop     bc
__Exit:
    push    hl
    call    crt0_exit
    pop     hl
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"

    SECTION BSS_END
    defb	2
    defw	CRT_ORG_CODE
