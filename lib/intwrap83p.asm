; Ti82 interrupt 'wrapper' - by Henk Poley
;-----------------------------------------------------------------------------
; The z88dk makes extensively use of the shadow registers (EXX and EX AF,AF)
; The Ti82 system interrupt doesn't preserve (any of) these regs and
;  could thus crash your program. The workaround is to use this interrupt
;  all the time, it saves and restores the (shadow-)registers for the
;  system interrupt.
; We need the system interrupt when scanning keys (in an easy way), also
;  some (other) ROM calls make use of the system interrupt. if the interrupt
;  is then not running, the calculator would crash.
;-----------------------------------------------------------------------------

IF !TI83PLUSAPP				; Else already in DEFVAR block
defc intcount = $8A8D			; 1 byte needed
ENDIF

	INCLUDE "int83p.asm"		; Put interrupt loader here
					;
	xor	a			; We need to intialize variables
	ld	(intcount),a		;  by ourself.
					;
	jr	jump_over		; Jump over the interrupt code

;-----------------
; Actual interrupt
;-----------------
IntProcStart:
	push	af			;
	ld	a,(intcount)		; Check if own interrupt has quited
	bit	7,a			;  correctly, then bit 7 is zero
	jr	nz,int_fix		; If not zero, fix stack...
	push	hl			;
	push	de			;
	push	bc			;
	push	iy			;
	ld	iy,_IY_TABLE		;
	ld	hl,intcount		; If a 'direct interrupt' occures    
	set	7,(hl)			;  right after the TIOS-int, then
					;  we want bit 7 to be set...
exit_interrupt:
	exx				; Swap to shadow registers.
	ex	af,af			; So the TIOS swaps back to the
					;  normal ones... (the ones we saved
					;  with push/pops)
	rst	$38			;
	di				; 'BIG' HOLE HERE... (TIOS does ei...)
	di				;
	ex	af,af			;
	exx				;
					;
	ld	hl,intcount		; Interrupt returned correctly, so
	res	7,(hl)			;  we reset our error-condition...
					;
	pop	iy			;
	pop	bc			;
	pop	de			;
	pop	hl			;
	pop	af			;
	ei				;
	ret				;
int_fix:
	pop	af			; Pop AF back
	ex	af,af			; Fix shadowregs back
	exx				;
	pop	bc			; Pop the returnpoint of RST $38
					;  from the stack
	jr	exit_interrupt		; Continue with interrupt
IntProcEnd:
jump_over:

; Memory usage in statvars:
; -------------------------------------------
; $858F / $85FF - 113 bytes - free
; $8600 / $8700 - 256 bytes - IV table
; $8701 / $8786 - 134 bytes - free
; $8787 / $8789 -   3 bytes - JP IntProcStart
; $878A         -   1 byte  - intcount        <--
; $878B / $87A2 -  24 bytes - free
; -------------------------------------------
