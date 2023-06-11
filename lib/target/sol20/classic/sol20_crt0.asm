;
;	Startup for the SOL20
;

    module  sol20_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

    IFNDEF CLIB_FGETC_CONS_DELAY
        defc CLIB_FGETC_CONS_DELAY = 150
    ENDIF

    PUBLIC  VDM_CAPS
    PUBLIC  VDM_CAPS_MASK
    INCLUDE "ioctl.def"
    defc    VDM_CAPS = CAP_GENCON_INVERSE
    defc    VDM_CAPS_MASK = @10000000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 0xbfff
    defc    CRT_KEY_DEL = 8
    defc    __CPU_CLOCK = 2000000
    defc    CONSOLE_ROWS = 16
    defc    CONSOLE_COLUMNS = 64
    INCLUDE "crt/classic/crt_rules.inc"

     IF !DEFINED_CRT_ORG_CODE
        defc CRT_ORG_CODE = 0x0000
     ENDIF

    org	  CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000
  if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
  endif
        jp      program
        INCLUDE "crt/classic/crt_z80_rsts.asm"
ENDIF


program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
cleanup:
    ld      hl,0
    push    hl
    push    hl
    call    _main
    pop     bc
    pop     bc
    push    hl
    call    crt0_exit
    pop     hl
finished:
    ret

l_dcal: jp      (hl)            ;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    INCLUDE "crt/classic/crt_section.asm"
