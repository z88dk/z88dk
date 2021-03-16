; CRT0 stub for high RAM

	defc    CRT_ORG_CODE  = 0x8000
        defc    TAR__register_sp = 0xfd00
        defc    TAR__clib_exit_stack_size = 4
	defc    TAR__fputc_cons_generic = 1

	; Where the screen is located
	defc	SCREEN_BASE = 0x0000

        INCLUDE "crt/classic/crt_rules.inc"

	EXTERN	asm_im1_handler

        org     CRT_ORG_CODE

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

	; Now, page the screen into 0000-0x7fff
	; We'll use mode0 so we can steal some +zx code
	; Switch to mode 0
	in	a,(VMPR)
	ld	b,a
	and	@10011111	;Switch to mode 0
	out	(VMPR),a
	ld	a,b
	and	@00011111
	or	@00100000	;Page video memory in low, turn off ROM
	out	(LMPR),a

	; We are in high RAM, we have to setup an interrupt handler
	; (we don't have access to NMI here)
	ld	hl,$fe00
	ld	de,$fe01
	ld	bc,257	
	ld	(hl),$fd
	ldir
	ld	a,195
	ld	($fdfd),a
	ld	hl,asm_im1_handler
	ld	($fdfe),hl
	ld	a,0xfe
	ld	i,a
	im	2
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

