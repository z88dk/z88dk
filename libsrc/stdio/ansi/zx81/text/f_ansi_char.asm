;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000 / Oct 2017
;
;	set it up with:
;	.console_w = max columns
;	.console_h = max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	asctozx81
	
	EXTERN __console_x
	EXTERN __console_y

	EXTERN	zx_inverse



.ansi_CHAR
	ld	hl,mychar
	ld	(hl),a
	call	asctozx81
	bit	 6,a		; filter the dangerous codes
	ret	 nz

	ld	hl,zx_inverse
	sub	(hl)

	push	af
IF FORlambda
	ld	hl,16510
ELSE
	ld	hl,(16396)	; D_FILE
	inc	hl
ENDIF
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,33	; 32+1. Every text line ends with an HALT
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret
	
	SECTION	bss_clib
.mychar
defb 0
