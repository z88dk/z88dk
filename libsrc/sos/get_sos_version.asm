;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_sos_version()
;
;       $Id: get_sos_version.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

        PUBLIC    get_sos_version

get_sos_version:
				call $1ff7
				ld	h,0
                ret
