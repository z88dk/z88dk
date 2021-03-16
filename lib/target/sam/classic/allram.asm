; CRT0 stub for allram Sam Coupe

	defc    CRT_ORG_CODE  = 0x0000
        defc    TAR__register_sp = 0x0000
        defc    TAR__clib_exit_stack_size = 4
	defc    TAR__fputc_cons_generic = 1

	defc	SCREEN_BASE = 0x8000

	; No interrupts registered
        defc    TAR__crt_enable_rst = $8080
        IFNDEF CRT_ENABLE_NMI
            defc        TAR__crt_enable_nmi = 1
            EXTERN      asm_nmi_handler
            defc        _z80_nmi = asm_nmi_handler
        ENDIF
	defc _z80_rst_38h = asm_im1_handler

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


	; Setup heap between end program and sp
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF

	; TODO: SAM initialisation

	ei

	; Entry to the user code
	call    _main
cleanup:
	call    crt0_exit
endloop:
	jr	endloop

l_dcal:
        jp      (hl)

        INCLUDE "crt/classic/crt_runtime_selection.asm"

        INCLUDE "crt/classic/crt_section.asm"

	; Include the bootstrap routine
	INCLUDE "target/sam/classic/bootstrap.asm"

