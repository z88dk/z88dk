
	defc	CRT_ORG_CODE = 0x89a3


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

