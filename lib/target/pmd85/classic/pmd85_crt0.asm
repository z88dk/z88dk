;
;	Startup for pmd85
;
;	$Id: test_crt0.asm,v 1.12 2016-06-21 20:49:07 dom Exp $


    module pmd85_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  asm_im1_handler

    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

IFNDEF CLIB_FGETC_CONS_DELAY
    defc    CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = -1 
    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 2048000
    defc    CONSOLE_COLUMNS = 48
    defc    CONSOLE_ROWS = 32

    ; Interrupts are available in the emulator
    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler

    defc    TAR__crt_enable_eidi = 0x02     ;Enable interrupts on start
    defc    TAR__crt_on_exit = 0x8000       ;Just loop

    INCLUDE "crt/classic/crt_rules.inc"

    defc    CRT_ORG_CODE = 0x0000

    org	    CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di
    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.inc"


program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"
    ld      bc,0
    push    bc	;argv
    push    bc	;argc
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

    ;INCLUDE	"target/pmd85/classic/bootstrap.asm"

