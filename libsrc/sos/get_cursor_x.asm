;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_cursor_x()
;
;       $Id: get_cursor_x.asm,v 1.1 2013-12-03 13:42:32 stefano Exp $
;

        XLIB    get_cursor_x

get_cursor_x:
				call $2018
				ld	h,0
                ret
