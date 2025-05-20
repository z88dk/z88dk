;
;	Startup for the PK-8000
;


    module pk8000_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

IFNDEF CLIB_FGETC_CONS_DELAY
    defc CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = $f000
    defc	CRT_KEY_DEL = 12
    defc	__CPU_CLOCK = 1780000
    defc	CONSOLE_ROWS = 24
    defc	CONSOLE_COLUMNS = 40
    INCLUDE "crt/classic/crt_rules.inc"

    defc CRT_ORG_CODE = 0x4000

    org	  CRT_ORG_CODE



program:
    di
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      hl,0
    push    hl
    push    hl
    call    _main
    pop     bc
    pop     bc
__Exit:
    push    hl
    call    crt0_exit
    pop     hl
    INCLUDE "crt/classic/crt_exit_eidi.inc"
finished:
    ret


l_dcal: jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"

