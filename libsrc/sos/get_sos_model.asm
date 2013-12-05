;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_sos_model()
;
;       $Id: get_sos_model.asm,v 1.1 2013-12-05 09:34:01 stefano Exp $
;

        XLIB    get_sos_model

get_sos_model:
				call $1ff7
				ld	l,h
				ld	h,0
                ret
