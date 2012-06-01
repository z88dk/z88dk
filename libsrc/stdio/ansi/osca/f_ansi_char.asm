;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	** alternate (smaller) 4bit font capability: 
;	** use the -DPACKEDFONT flag
;	** ROM font -DROMFONT
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;	.DOTS+1		= char size
;	.font		= font file
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.2 2012-06-01 10:26:17 stefano Exp $
;

	XLIB	ansi_CHAR
    INCLUDE "flos.def"
	
	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XDEF	text_cols
	XDEF	text_rows

;	XREF	cursor_y
;	XREF	cursor_x
	
;.mychar   defb 0
;          defb 0 ; string termination
	
.text_cols   defb 40
.text_rows   defb 25

.ansi_CHAR

;	ld (mychar),a
;	ld a,(ansi_ROW)
;	ld (cursor_y),a
;	ld a,(ansi_COLUMN)
;	ld (cursor_x),a
;	ld hl,mychar
;	jp kjt_print_string

	ld e,a
	ld a,(ansi_COLUMN)
	ld b,a
	ld a,(ansi_ROW)
	ld c,a
	ld a,e
	jp kjt_plot_char
	
