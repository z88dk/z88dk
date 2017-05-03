;       CRT0 for the SORD M5
;
;       Stefano Bodrato Maj. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: m5_crt0.asm,v 1.22 2016-07-15 21:03:25 dom Exp $
;


        MODULE  m5_crt0


;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

        EXTERN    _main

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal

; Graphics stuff
        PUBLIC	pixelbyte	; Temp store for non-buffered mode

; MSX platform specific stuff
;
        PUBLIC    msxbios


; Now, getting to the real stuff now!

IF      !DEFINED_CRT_ORG_CODE
	defc    CRT_ORG_CODE  = $7300
ENDIF

        org     CRT_ORG_CODE

start:
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

        exx
        push	hl


        call    _main
        
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

	pop	bc
	exx
	pop	hl
	exx

start1:
	ld      sp,0
	ret


l_dcal:
	jp      (hl)

; Safe BIOS call
msxbios:
	push	ix
	ret


	defm  "Small C+ SORD M5"
	defb	0

        INCLUDE "crt0_runtime_selection.asm"

        INCLUDE "crt0_section.asm"

	SECTION	bss_crt

	PUBLIC	RG0SAV		;keeping track of VDP register values
	PUBLIC	RG1SAV
	PUBLIC	RG2SAV
	PUBLIC	RG3SAV
	PUBLIC	RG4SAV
	PUBLIC	RG5SAV
	PUBLIC	RG6SAV
	PUBLIC	RG7SAV
RG0SAV:		defb	0	;keeping track of VDP register values
RG1SAV:		defb	0
RG2SAV:		defb	0
RG3SAV:		defb	0
RG4SAV:		defb	0
RG5SAV:		defb	0
RG6SAV:		defb	0
RG7SAV:		defb	0


