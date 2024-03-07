;
;	Startup for special


    module special_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

IFNDEF CLIB_FGETC_CONS_DELAY
    defc    CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = -1 
    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 2000000
    defc    CONSOLE_COLUMNS = 48
    defc    CONSOLE_ROWS = 32
    INCLUDE "crt/classic/crt_rules.inc"

    defc    CRT_ORG_CODE = 0x0000

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif

    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.inc"



program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
    ei
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"
    push    bc	;argv
    push    bc	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    push    hl
    call    crt0_exit
    pop     hl
    jp      $c800

l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"
