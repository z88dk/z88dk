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
;	.__console_w	= max columns
;	.__console_h	= max rows
;	.DOTS+1		= char size
;	.font		= font file
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.5 2016-07-14 17:44:18 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
    INCLUDE "target/osca/def/flos.def"
	
	EXTERN	__console_y
	EXTERN	__console_x


;	EXTERN	cursor_y
;	EXTERN	cursor_x
	
;.mychar   defb 0
;          defb 0 ; string termination
	

.ansi_CHAR

;	ld (mychar),a
;	ld a,(__console_y)
;	ld (cursor_y),a
;	ld a,(__console_x)
;	ld (cursor_x),a
;	ld hl,mychar
;	jp kjt_print_string

	ld e,a
	ld a,(__console_x)
	ld b,a
	ld a,(__console_y)
	ld c,a
	ld a,e
	jp kjt_plot_char
	
