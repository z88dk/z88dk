;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int break_key()
;
;       $Id: break_key.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;
;----------------------------------------------------------------
;
;	Check if BREAK is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;----------------------------------------------------------------

        PUBLIC    break_key

break_key:
				call $1fcd
				ld	hl,0	; assume break is not pressed
                ret nz
                inc l
                ret
