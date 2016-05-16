;       CRT0 for the NASCOM1/2
;
;       Stefano Bodrato May 2003
;
;
; - - - - - - -
;
;       $Id: nascom_crt0.asm,v 1.18 2016-05-16 20:11:32 dom Exp $
;
; - - - - - - -


	MODULE  nascom_crt0

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


	PUBLIC    exitsp          ;atexit() variables
	PUBLIC    exitcount

	PUBLIC    __sgoioblk      ;stdio info block

	PUBLIC	heaplast	;Near malloc heap variables
	PUBLIC	heapblocks

	PUBLIC    base_graphics   ;Graphical variables (useless with NASCOM)
	PUBLIC    coords          ;Current xy position

	PUBLIC    montest         ;NASCOM: check the monitor type


	;org	0C80h
	org	1000h
	;org	0E000h
	
; NASSYS1..NASSYS3
;  IF (startup=1) | (startup=2) | (startup=3)
;
;
;  ENDIF

start:

	ld	(start1+1),sp	;Save entry stack

	; search for the top of writeble memory and set the stack pointer
	ld	hl,0ffffh
	ld	a,55
stackloop:
	ld	(hl),a
	cp	(hl)
	dec	hl
	jr	nz,stackloop
	ld	hl,0xe000
	ld      sp,hl
	ld      (exitsp),sp

        call    crt_init_start  ;Initialise any data setup by sdcc

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


	call    _main	;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF

	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	rst	18h
	defb	5bh
	;ret

l_dcal:	jp	(hl)		;Used for function pointer calls
        jp      (hl)


;------------------------------------
; Check which monitor we have in ROM
;------------------------------------

montest: ld	a,(1)	; "T" monitor or NAS-SYS?
         cp	33h	; 31 00 10     / 31 33 0C
         ret


         defm  "Small C+ NASCOM"	;Unnecessary file signature
         defb	0

        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"

