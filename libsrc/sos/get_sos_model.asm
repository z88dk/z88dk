;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_sos_model()
;
;       $Id: get_sos_model.asm,v 1.3 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
        PUBLIC    get_sos_model
        PUBLIC    _get_sos_model

get_sos_model:
_get_sos_model:
		call $1ff7
		ld	l,h
		ld	h,0
                ret
