;
; 	ANSI Video handling for the Amstrad CPC
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.6 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR

    INCLUDE "target/cpc/def/cpcfirm.def"
               
	
	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN	INVRS
	EXTERN	UNDRL
	
.ansi_CHAR
        push	af
        ld      a,(__console_x)
        inc     a
        ld      h,a
        ld      a,(__console_y)
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
