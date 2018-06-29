;       CRT0 for the Multi8
;


	MODULE multi8_crt0 

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

	EXTERN    _main           ;main() is always external to crt0 code

	PUBLIC    cleanup         ;jp'd to by exit()
	PUBLIC    l_dcal          ;jp(hl)



        defc    CONSOLE_ROWS = 20
        defc    CONSOLE_COLUMNS = 40
	defc	CRT_KEY_DEL = 8

	IF      !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = 0xC000
	ENDIF

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
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

l_dcal:	jp	(hl)		;Used for function pointer calls


         defm  "Small C+ Multi8"	;Unnecessary file signature
         defb	0

        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"

