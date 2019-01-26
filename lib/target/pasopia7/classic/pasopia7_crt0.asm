;
;	Startup for Pasopia 7
;
;	Just limited to 4k at the moment for experimentation
;	Will have a 64k loading mode as well


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

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = 65280
        defc    TAR__fputc_cons_generic = 1
	defc	CRT_KEY_DEL = 127
	defc	CRT_ORG_CODE = 0xd000
        defc    CONSOLE_COLUMNS = 40
        defc    CONSOLE_ROWS = 25
	defc	__CPU_CLOCK = 4000000

	defc	GRAPHICS_CHAR_SET = 135
	defc	GRAPHICS_CHAR_UNSET = 32
	PUBLIC	GRAPHICS_CHAR_SET
	PUBLIC	GRAPHICS_CHAR_UNSET
        INCLUDE "crt/classic/crt_rules.inc"

	org	CRT_ORG_CODE	

	di
	ld	hl,$d000	;Just read 2k into d000 to give us a bit extra
	ld	de,$0101
	ld	bc,$4012
	call	$41f9
	ld	c,$13
	call	$41f9
	ld	hl,$d800	;Just read 2k into d000 to give us a bit extra
	ld	de,$0201
	ld	bc,$4012
	call	$41f9
	ld	c,$13
	call	$41f9


	ld	a,0
	ld	(__pasopia_page),a
	out	($3c),a

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	jp	0


l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	bss_crt
	PUBLIC	__pasopia_page
__pasopia_page:	defb	0

	;INCLUDE	"target/pasopia7/classic/bootstrap.asm"

