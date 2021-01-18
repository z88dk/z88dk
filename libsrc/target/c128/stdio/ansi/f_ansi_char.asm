;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	INVRS

	EXTERN	__console_y
	EXTERN	__console_x
	EXTERN	__c128_attr
	
	
.ansi_CHAR

	push	af
	ld	hl,$2000
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,40
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	
	cp	96
	jr	c,nolower
	sub	96
	jr	setout
.nolower

; These lines aren't needed when we use the alternate font
;	cp	64
;	jr	c,noupper
;	sub	64
;.noupper

.setout

.INVRS
	or	0	; This byte is set to 128 when INVERSE is ON
	ld	(hl),a

	ld	de,$1000
	sbc	hl,de		; Color map location
	ld	a,(__c128_attr)
	ld	(hl),a		; This byte is the current attribute

	ret
