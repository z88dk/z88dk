
    module m100_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code
    ;EXTERN    asm_im1_handler

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

    PUBLIC	ROMCALL_OP	; Opcode to use for ROM calls

IFNDEF CLIB_FGETC_CONS_DELAY
    defc CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__clib_exit_stack_size = 4
    ;	defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = -1 
    defc    CRT_KEY_DEL = 8
    defc    __CPU_CLOCK = 2400000

    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 8
    defc    CLIB_DISABLE_FGETS_CURSOR = 1


    INCLUDE "crt/classic/crt_rules.inc"

IF startup = 1 
    defc	ROMCALL_OP = $CD	; CALL
    INCLUDE	"target/m100/classic/ram.asm"
ELSE
    defc	ROMCALL_OP = $F7	; RST6
    INCLUDE	"target/m100/classic/optrom.asm"
ENDIF
 
l_dcal: jp      (hl)            ;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    INCLUDE	"crt/classic/crt_section.asm"

