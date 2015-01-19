;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_sos_model()
;
;       $Id: get_sos_model.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

        PUBLIC    get_sos_model

get_sos_model:
				call $1ff7
				ld	l,h
				ld	h,0
                ret
