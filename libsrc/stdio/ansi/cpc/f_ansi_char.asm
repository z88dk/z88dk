;
; 	ANSI Video handling for the Amstrad CPC
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.6 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR

    INCLUDE "cpcfirm.def"
               
	
	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	INVRS
	EXTERN	UNDRL
	
.text_cols   defb 80

.text_rows   defb 25

.ansi_CHAR
        push	af
        ld      a,(ansi_COLUMN)
        inc     a
        ld      h,a
        ld      a,(ansi_ROW)
        inc     a
        ld      l,a
        push	hl
        call    firmware
        defw    txt_set_cursor
        pop	hl
        pop	af
        push	hl
        call    firmware
        defw    txt_output
        pop     hl
        ld      a,(UNDRL)
        and     a
        ret     z
        call    firmware
        defw    txt_set_cursor
        ld      a,1
        call    firmware
        defw    txt_set_back
        ld      a,'_'
        call    firmware
        defw    txt_output
        xor     a
        call    firmware
        defw    txt_set_back
        ret
