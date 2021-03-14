;	CRT0 stub for 64k Mode PC88


        defc    CONSOLE_COLUMNS = 80
        defc    CONSOLE_ROWS = 25
	defc    CRT_ORG_CODE  = 0x0000
        defc    TAR__register_sp = 0xc000
        defc    TAR__clib_exit_stack_size = 32
	defc    TAR__fputc_cons_generic = 1

	; No interrupts registered
        defc    TAR__crt_enable_rst = $0000
        IFNDEF CRT_ENABLE_NMI
            defc        TAR__crt_enable_nmi = 1
            EXTERN      asm_nmi_handler
            defc        _z80_nmi = asm_nmi_handler
        ENDIF

	EXTERN	asm_im1_handler

	INCLUDE	"crt/classic/crt_rules.inc"


        org     CRT_ORG_CODE

	jp	program

	INCLUDE	"crt/classic/crt_z80_rsts.asm"

program:
	di
	; Make room for the atexit() stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"

	call	crt0_init_bss
	ld      (exitsp),sp


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF

	ld	hl,asm_im1_handler
	ld	($f302),hl		;vsync interrupt
	ld	a,2			;Enable vsync interrupt only
	out	($e4),a
	out	($e6),a


	ei

; Entry to the user code
	call    _main

cleanup:
	call    crt0_exit
endloop:
	jr	endloop

l_dcal:
        jp      (hl)

; Make im1 init a noop in allram mode
im1_init:
_im1_init:
; Calling the bios should be noop too since it's not paged in
pc88bios:	
	ret

        INCLUDE "crt/classic/crt_runtime_selection.asm"
        INCLUDE "crt/classic/crt_section.asm"

	; Include the IPL bootstrap code
	INCLUDE "target/pc88/classic/bootstrap.asm"

