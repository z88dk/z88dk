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
;	$Id: f_ansi_char.asm,v 1.5 2016-07-14 17:44:18 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
    INCLUDE "flos.def"
	
	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	PUBLIC	text_cols
	PUBLIC	text_rows

;	EXTERN	cursor_y
;	EXTERN	cursor_x
	
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
	
