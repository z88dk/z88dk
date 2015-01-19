;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_cursor_x()
;
;       $Id: get_cursor_y.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;

        PUBLIC    get_cursor_y

get_cursor_y:
				call $2018
				ld	l,h
				ld	h,0
                ret
