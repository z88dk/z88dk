
    module lviv_crt0


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


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 0xa000
    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 2500000

IFNDEF CLIB_FGETC_CONS_DELAY
    defc CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__crt_enable_rst = $8080
    EXTERN asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
    defc    TAR__crt_enable_nmi = -1		;Disable NMI


    INCLUDE "crt/classic/crt_rules.inc"
    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 32

IF      !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x0000
ENDIF

    org	  CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000
  IF (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
  ENDIF

    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.asm"
ENDIF

program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
    ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    jp      $e000

l_dcal: jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    INCLUDE	"crt/classic/crt_section.asm"
