;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000 / Oct 2017
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
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
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	zx_inverse

.text_cols   defb 32
.text_rows   defb 24


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
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,33	; 32+1. Every text line ends with an HALT
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(ansi_COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret
	
	SECTION	bss_clib
.mychar
defb 0
