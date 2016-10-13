;       Kludgey startup for nc100
;
;       djm 17/4/2000
;
; 	I've never used one of these brutes so I dunno if it's
;	correct at all, this is all taken from the file nciospec.doc
;	on nvg.unit.no, I assume that the PCMCIA RAM card is an
;	actual fact addressable RAM and we can overwrite variables
;	etc NB. Values of static variables are not reinitialised on
;	future entry.
;
;       $Id: nc100_crt0.asm,v 1.17 2016-10-13 07:47:20 stefano Exp $
;



	MODULE  nc100_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

		EXTERN    _main		;main() is always external to crt0 code

		PUBLIC    cleanup		;jp'd to by exit()
		PUBLIC    l_dcal		;jp(hl)



IF (startup=2)

		org     $8C00
		jp	start

ELSE

		org     $C000
		jp	start

IF DEFINED_USING_amalloc
;EXTERN ASMTAIL
PUBLIC _heap
; We have 509 bytes we can use here..
_heap:
		defw 0
		defw 0
_mblock:
		defs	505		; Few bytes for malloc() stuff
ELSE
		defs	509		; Waste 509 bytes of space
ENDIF

;--------
; Card header
;--------
	defm	"NC100PRG"	
	defb	0,0,0,0,0,0,0,0
	jp	start			;c210
	defm	"z88dk NC100"
	defb	0,0

ENDIF


start:				;Entry point at $c2220
        ld      (start1+1),sp   ;Save entry stack
        ld      hl,-64		;Create the atexit stack
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		ld hl,_heap
		; compact way to do "mallinit()"
		xor	a
		ld	(hl),a
		inc hl
		ld	(hl),a
		inc hl
		ld	(hl),a
		inc hl
		ld	(hl),a
		
		ld hl,_mblock
		push hl	; data block
		ld hl,505
		push hl	; area size
		EXTERN sbrk_callee
		call	sbrk_callee
	ENDIF


        call    _main		;Call user code
cleanup:
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall	;Close all opened files
	call	closeall
ENDIF
	pop	bc
start1:
	ld	sp,0
	ret

l_dcal:	jp	(hl)

        INCLUDE "crt0_runtime_selection.asm"
	UNDEFINE DEFINED_USING_amalloc
        INCLUDE "crt0_section.asm"
