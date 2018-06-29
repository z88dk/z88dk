;       CRT0 for the Multi8 (16k mode)
;

	IF      !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = 0xC000
	ENDIF


	defc	VRAM_IN = 0x17
	defc	VRAM_OUT = 0x0f

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
        INCLUDE "crt/classic/crt_rules.inc"
	org     CRT_ORG_CODE

start:

	ld	(start1+1),sp	;Save entry stack
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
	ld      (exitsp),sp


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


	call    _main	;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF CRT_ENABLE_STDIO = 1
	EXTERN	closeall
	call	closeall
ENDIF

	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	ret
