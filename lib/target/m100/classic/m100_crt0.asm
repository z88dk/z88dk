
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

    PUBLIC  ROMCALL_OP  ; Opcode to use for ROM calls

IFNDEF CLIB_FGETC_CONS_DELAY
    defc CLIB_FGETC_CONS_DELAY = 150
ENDIF

    defc    TAR__clib_exit_stack_size = 4
    ;   defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = -1
    defc    TAR__crt_enable_eidi = $02 ; ei on entry
    defc    CRT_KEY_DEL = 8
    defc    __CPU_CLOCK = 2400000

    defc    CONSOLE_COLUMNS = 40
    defc    CLIB_DISABLE_FGETS_CURSOR = 1


    INCLUDE "crt/classic/crt_rules.inc"

    ; ROM calls that the library use, they vary between the supported clones
    PUBLIC  KY_KYREAD
    PUBLIC  KY_KYPEND
    PUBLIC  KY_CLS
;    PUBLIC  KY_CHROUT
;    PUBLIC  KY_CURPOS
;    PUBLIC  KY_CSRX
;    PUBLIC  KY_CSRY
    PUBLIC  KY_CURSON
    PUBLIC  KY_CURSOFF
;    PUBLIC  KY_BEEP
;    PUBLIC  KY_LCDSET
;    PUBLIC  KY_LCDRES
    PUBLIC  KY_SHAPE
    PUBLIC  KY_SETINT_1D
    PUBLIC  KY_SET_LCD_ADDR
    PUBLIC  KY_GET_LCD
    PUBLIC  KY_PLOT_TBL
    PUBLIC  KY_PLOT_TBL2
    PUBLIC  KY_LCDSET_TAIL

IFDEF __M10
    INCLUDE "target/m100/def/m10_romcalls.def"
ELIFDEF __KC85
    INCLUDE "target/m100/def/kc85_romcalls.def"
ELIFDEF __PC8201
    INCLUDE "target/m100/def/pc8201_romcalls.def"
ELIFDEF __T200
    INCLUDE "target/m100/def/t200_romcalls.def"
ELSE
    INCLUDE "target/m100/def/m100_romcalls.def"
ENDIF

IF startup = 1 
    defc    ROMCALL_OP = $CD    ; CALL
    INCLUDE "target/m100/classic/ram.asm"
    ; This trick would save 20 bytes only
    ;defc  KY_PLOT_TBL = KYKYROM_PLOT_TBL
    ;defc  KY_PLOT_TBL2 = KYKYROM_PLOT_TBL2
ELSE
    defc    ROMCALL_OP = $F7    ; RST6
    INCLUDE "target/m100/classic/optrom.asm"
ENDIF


l_dcal: jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE "crt/classic/crt_section.inc"

