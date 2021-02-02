;
;	Startup for Pasopia 7


	MODULE pasopia7_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

	EXTERN	asm_im1_handler
	EXTERN	asm_nmi_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = 65280
        defc    TAR__fputc_cons_generic = 1
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

	INCLUDE	"crt/classic/crt_z80_rsts.asm"

program:
	di

        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
	ld	a,2
	ld	(__pasopia_page),a
	im	1
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	jp	cleanup


l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	bss_crt
	PUBLIC	__pasopia_page
__pasopia_page:	defb	0

	INCLUDE	"target/pasopia7/classic/bootstrap.asm"

