;       Startup fo SAM Coupe
;
;       Stefano 26/3/2001
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: sam_crt0.asm,v 1.20 2016-06-21 20:49:06 dom Exp $
;


        MODULE  sam_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this fileb

        EXTERN    _main

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal


        org     32768


start:
        ld      (start1+1),sp   ;Save entry stack
        ld      hl,-64		;Create the atexit stack
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init; it takes
; all the space between the end of the program and UDG
IF DEFINED_USING_amalloc
		ld	hl,_heap
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		inc bc
		; compact way to do "mallinit()"
		xor	a
		ld	(hl),a
		dec hl
		ld	(hl),a

		;  Stack is somewhere else, no need to reduce the size for malloc
		ld	hl,65535
		sbc hl,bc	; hl = total free memory

		push bc ; main address for malloc area
		push hl	; area size
		EXTERN sbrk_callee
		call	sbrk_callee
ENDIF


;       Special SAM stuff goes here

        ; Set screen to mode 0
        ld a,0
        call $15A ; JMODE

        ; set stream to channel 's' (upper screen)
        ld a,2
        call $112 ; JSETSTRM

;       End of SAM stuff




        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF

        pop     bc

;       Special SAM stuff goes here

;       End of SAM stuff



start1:
        ld      sp,0
        ret

l_dcal:
        jp      (hl)


        defm  "Small C+ SAM Coupe"
	defb	0

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

	SECTION	code_crt_init
	ld	hl,16384
	ld	(base_graphics),hl

