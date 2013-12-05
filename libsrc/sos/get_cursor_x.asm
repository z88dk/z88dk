;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_cursor_x()
;
;       $Id: get_cursor_x.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
;

        XLIB    get_cursor_x

get_cursor_x:
				call $2018
				ld	h,0
                ret
