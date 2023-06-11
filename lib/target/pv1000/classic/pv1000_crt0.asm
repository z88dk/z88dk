;
;	Startup for Casio PV-1000
;
;	The font is located from address 00000H - 01BFFH
;	- 32 bytes per character - 224 characters max
;	We need some space for startup etc, so initial characters
;	aren't available


    module  pv1000_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  im1_vectors
    EXTERN  nmi_vectors
    EXTERN  asm_interrupt_handler

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    ; 2 columns on left and 2 column on right are lost
    defc    CONSOLE_COLUMNS = 28
    defc    CONSOLE_ROWS = 24

    ; 256 bytes at bb00
    ; 1024 bytes at bc00 - shared with RAM character generator
    defc    CRT_ORG_BSS = 0xbb00	
    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xbfff
    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 3579000

    ; We want to intercept rst38 to our interrupt routine
    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler

    ; The machine doesn't have NMI
    defc    TAR__crt_enable_nmi = 0

    defc    TAR__crt_on_exit = 0x10001      ;Loop forever
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup 

    INCLUDE "crt/classic/crt_rules.inc"

    org	    CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif

    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.asm"

program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
    im      1
    INCLUDE "crt/classic/crt_start_eidi.inc"

    INCLUDE "crt/classic/crt_init_amalloc.asm"
    call    _main
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"


l_dcal: jp      (hl)            ;Used for function pointer calls

; Font location - this is far too generous - we should add in extra
; symbols
    defs    10 * 32-ASMPC
if (ASMPC<>(10 * 32))
    defs    CODE_ALIGNMENT_ERROR
endif

    ; Lores graphics
    INCLUDE	"target/pv1000/classic/lores.asm"

    ; Character map - TODO, redefining it
IF PV1000_CUSTOM_TILESET
    INCLUDE	"tileset.asm"
ELSE
    INCLUDE	"target/pv1000/classic/font.asm"
ENDIF




    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    defc	__crt_org_bss = CRT_ORG_BSS
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ELSE
    defc __crt_model = 1
ENDIF
    INCLUDE	"crt/classic/crt_section.asm"
