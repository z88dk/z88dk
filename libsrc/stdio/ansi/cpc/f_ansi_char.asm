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
;	$Id: f_ansi_char.asm,v 1.3 2008-03-27 18:24:42 stefano Exp $
;

	XLIB	ansi_CHAR

    INCLUDE "#cpcfirm.def"
               
	
	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XDEF	text_cols
	XDEF	text_rows

	XREF	INVRS
	XREF	UNDRL
	
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
