;
; 	ANSI Video handling for the Philips VG-5000
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_char.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	vg5k_attr

.text_cols   defb 40
.text_rows   defb 25


.ansi_CHAR

	ld	 d,a
	
	ld	a,(vg5k_attr)
	ld	e,a		; white on black
	
	ld	 a,(ansi_ROW)
	and  a
	jr   z,zrow
	add  7
.zrow
	ld   h,a
	ld	 a,(ansi_COLUMN)
	ld   l,a

	jp   $92
