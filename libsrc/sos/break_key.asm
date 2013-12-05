;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int break_key()
;
;       $Id: break_key.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
;
;----------------------------------------------------------------
;
;	Check if BREAK is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;----------------------------------------------------------------

        XLIB    break_key

break_key:
				call $1fcd
				ld	hl,0	; assume break is not pressed
                ret nz
                inc l
                ret
