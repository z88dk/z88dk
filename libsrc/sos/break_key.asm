;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int break_key()
;
;       $Id: break_key.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;
;----------------------------------------------------------------
;
;	Check if BREAK is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;----------------------------------------------------------------

	SECTION	  code_clib
        PUBLIC    break_key
        PUBLIC    _break_key

break_key:
_break_key:
				call $1fcd
				ld	hl,0	; assume break is not pressed
                ret nz
                inc l
                ret
