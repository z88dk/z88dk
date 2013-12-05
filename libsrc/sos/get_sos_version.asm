;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int get_sos_version()
;
;       $Id: get_sos_version.asm,v 1.1 2013-12-05 09:34:01 stefano Exp $
;

        XLIB    get_sos_version

get_sos_version:
				call $1ff7
				ld	h,0
                ret
