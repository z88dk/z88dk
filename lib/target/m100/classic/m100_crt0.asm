
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

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

    PUBLIC	ROMCALL_OP	; Opcode to use for ROM calls

IFNDEF CLIB_FGETC_CONS_DELAY
    defc CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__clib_exit_stack_size = 4
    ;	defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = -1 
    defc    TAR__crt_enable_eidi = $02 ; ei on entry
    defc    CRT_KEY_DEL = 8
    defc    __CPU_CLOCK = 2400000

    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 8
    defc    CLIB_DISABLE_FGETS_CURSOR = 1


    INCLUDE "crt/classic/crt_rules.inc"

    ; ROM calls that the library use, they vary between the supported clones
    PUBLIC  KYREAD
    PUBLIC  KYPEND
    PUBLIC  CLS
    PUBLIC  CHROUT
    PUBLIC  CURPOS
    PUBLIC  CURSON
    PUBLIC  CURSOFF
    PUBLIC  BEEP
    PUBLIC  LCDSET
    PUBLIC  LCDRES

IFDEF __M10
    INCLUDE "target/m100/def/m10_romcalls.def"
ELIFDEF __KC85
    INCLUDE "target/m100/def/kc85_romcalls.def"
ELSE
    INCLUDE "target/m100/def/m100_romcalls.def"
ENDIF

IF startup = 1 
    defc	ROMCALL_OP = $CD	; CALL
    INCLUDE	"target/m100/classic/ram.asm"
ELSE
    defc	ROMCALL_OP = $F7	; RST6
    INCLUDE	"target/m100/classic/optrom.asm"
ENDIF
 
l_dcal: jp      (hl)            ;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE	"crt/classic/crt_section.inc"

