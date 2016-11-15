;
;       Startup for Microbee in BASIC mode
;       RUNM "program"
;
;       Stefano Bodrato - 2016
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: bee_crt0.asm,v 1.1 2016-11-15 08:11:10 stefano Exp $
;



                MODULE  bee_crt0

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


        IF      !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = $900  ; clean binary block
        ENDIF


; Now, getting to the real stuff now!


		org     CRT_ORG_CODE




start:

	ld	hl,-64		; 32 pointers (ANSI standard)
	add	hl,sp
	ld	sp,hl
	call	crt0_init_bss
	ld	(exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

        call    _main
cleanup:

	LD	HL,vdutab
	LD  C,0
	LD	B,16
.vdloop
	LD	A,C
	OUT	($0C),A
	LD	A,(HL)
	OUT	($0D),A
	INC	HL
	INC C
	DJNZ	vdloop
;
;       Deallocate memory which has been allocated here!
;
;        push    hl
IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF
;        pop     bc
start1:
        ld      sp,0
		ret

l_dcal:
        jp      (hl)

.vdutab		; 64*16
	defb	107,64,81,55,18,9,16,17,$48,$0F,$2F,$0F,0,0,0,0  


	defm  "Small C+ MicroBEE"
	defb   0

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE "crt0_section.asm"


	SECTION	code_crt_init
	nop
	;ld	hl,$
	;ld	(base_graphics),hl
