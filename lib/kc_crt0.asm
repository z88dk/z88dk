;
;       CRT0 for the Robotron KC85/2 .. KC85/5
;
;       Stefano Bodrato October 2016
;		few hints were found on the sdcc lib by Andreas Ziermann and Bert Lange
;
;		OPTIMIZATIONS:
;		#pragma output nosound   - Save few bytes not preserving IX on tape and sound interrupts
;
; - - - - - - -
;
;       $Id: kc_crt0.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -


	MODULE  kc_crt0

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


	IF      !DEFINED_CRT_ORG_CODE
			defc    CRT_ORG_CODE  = $1000
	ENDIF

	org     CRT_ORG_CODE


start:
	; Keyboard
	ld	hl,($01EE)
	ld	(INT01EE+7),hl
	ld	hl,INT01EE
	ld	($01EE),hl

	ld	hl,($01E6)
	ld	(INT01E6+7),hl
	ld	hl,INT01E6
	ld	($01E6),hl

IF !DEFINED_nosound
	; Sound
	ld	hl,($01EC)
	ld	(INT01EC+7),hl
	ld	hl,INT01EC
	ld	($01EC),hl

	; Cassette
	ld	hl,($01E4)
	ld	(INT01E4+7),hl
	ld	hl,INT01E4
	ld	($01E4),hl

	ld	hl,($01EA)
	ld	(INT01EA+7),hl
	ld	hl,INT01EA
	ld	($01EA),hl
ENDIF
	
	ld	(start1+1),sp	;Save entry stack
	
IF      STACKPTR
	ld  sp,STACKPTR
ELSE
	ld	sp,CRT_ORG_CODE-2
ENDIF
	
;	ld      hl,-64
;	add     hl,sp
;	ld      sp,hl
;	ld		sp,CRT_ORG_CODE
	
	call	crt0_init_bss
	ld      (exitsp),sp


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
	EXTERN	closeall
	call	closeall
ENDIF

	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	; use call LOOP instead of ret, works also
	; with direct load+start on simulator
	call $f003	; PV1 - parameter in regs, PVnr after callPV1
	defb $12	;FNLOOP - returns control to CAOS without memory initialization
	

l_dcal:	jp	(hl)		;Used for function pointer calls

	
	 defm  "Small C+ KC"	;Unnecessary file signature
	 defb	0
	 


;	Interrupt table
;	01D4..01E1	free for user
;	01E2	SIO channel B (if V24 module installed)
;	01E4	PIO channel A (cassette input)
;	01E6 	PIO channel B (keyboard input)
;	01E8 	CTC channel 0 (free)
;	01EA 	CTC channel 1 (cassette output)
;	01EC 	CTC channel 2 (sound duration)
;	01EE 	CTC channel 3 (keyboard input)

; CTC channel 3 (keyboard input)
INT01EE:
	push ix
	ld	ix,$01f0
	call 0
	pop ix
	ret

; PIO channel B (keyboard input)
INT01E6:
	push ix
	ld	ix,$01f0
	call 0
	pop ix
	ret

IF !DEFINED_nosound
; CTC channel 2 (sound duration)
INT01EC:
	push ix
	ld	ix,$01f0
	call 0
	pop ix
	ret

; CTC channel 1 (cassette input)
INT01E4:
	push ix
	ld	ix,$01f0
	call 0
	pop ix
	ret

; CTC channel 1 (cassette output)
INT01EA:
	push ix
	ld	ix,$01f0
	call 0
	pop ix
	ret
ENDIF

	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"

	SECTION code_crt_init
	ld	hl,$8000
	ld	(base_graphics),hl

