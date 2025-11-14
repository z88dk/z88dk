;
;	Startup for Pasopia 7


	MODULE pasopia7_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ;main() is always external to crt0 code

    EXTERN	asm_im1_handler
    EXTERN	asm_nmi_handler

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 65280
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__crt_on_exit = $10001     ;loop forever
    defc	CRT_KEY_DEL = 12
    defc	CRT_ORG_CODE = 0
    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 25
    defc	__CPU_CLOCK = 4000000
    defc	CLIB_FGETC_CONS_DELAY = 150

    defc	GRAPHICS_CHAR_SET = 135
    defc	GRAPHICS_CHAR_UNSET = 32
    PUBLIC	GRAPHICS_CHAR_SET
    PUBLIC	GRAPHICS_CHAR_UNSET


    PUBLIC  __IO_SN76489_PORT
    defc    __IO_SN76489_PORT = $3a


    ; We want to intercept rst38 to our interrupt routine
    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler
    IFNDEF CRT_ENABLE_NMI
        defc        TAR__crt_enable_nmi = 1
        EXTERN      asm_nmi_handler
        defc        _z80_nmi = asm_nmi_handler
    ENDIF

    INCLUDE "crt/classic/crt_rules.inc"

	org	CRT_ORG_CODE	

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.inc"

program:
    di

    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    ld      a,2
    ld      (__pasopia_page),a
    im      1
    ei

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE "crt/classic/crt_section.inc"

    SECTION bss_crt
    PUBLIC  __pasopia_page
__pasopia_page:	defb	0

    INCLUDE "target/pasopia7/classic/bootstrap.asm"

