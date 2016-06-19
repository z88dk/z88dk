;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_cursor_x()
;
;       $Id: get_cursor_y.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
        PUBLIC    get_cursor_y
        PUBLIC    _get_cursor_y

get_cursor_y:
_get_cursor_y:
		call $2018
		ld	l,h
		ld	h,0
                ret
