;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_cursor_x()
;
;       $Id: get_cursor_x.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
        PUBLIC    get_cursor_x
        PUBLIC    _get_cursor_x

get_cursor_x:
_get_cursor_x:
		call $2018
		ld	h,0
                ret
