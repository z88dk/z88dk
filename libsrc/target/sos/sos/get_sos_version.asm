;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_sos_version()
;
;       $Id: get_sos_version.asm,v 1.3 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
        PUBLIC    get_sos_version
        PUBLIC    _get_sos_version

get_sos_version:
_get_sos_version:
		call $1ff7
		ld	h,0
                ret
