;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int break_key()
;
;       $Id: break_key.asm,v 1.1 2013-12-03 13:42:32 stefano Exp $
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
