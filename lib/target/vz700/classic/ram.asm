


        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -1
	defc	CRT_ORG_CODE = 0x89a3 - 14


        INCLUDE "crt/classic/crt_rules.inc"


	; BASIC header for the vz
	defb	0xA3, 0x89                         ;// pointer to next basic line in memory (&H89A3)
	defb	0xE2, 0x07                         ;// 2018
	defb	0x41, 0xF0, 0x0C, 0xA3, 0x89, 0x3A ;// A=&H89A3
	defb	0xB6                               ;// :
	defb	0x20, 0x41                         ;// CALL A
	defb	0x00                               ;// line terminator


start:
	ld	(start1+1),sp
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
	ld	(exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
IF CRT_ENABLE_STDIO = 1
        EXTERN     closeall
        call    closeall
ENDIF
        pop     bc
start1:
        ld      sp,0
	ret

l_dcal:
        jp      (hl)



	defm  "Small C+ VZ"
	defb   0

