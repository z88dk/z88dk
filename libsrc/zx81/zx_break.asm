;
;       ZX81 libraries
;
;       $Id: zx_break.asm,v 1.2 2012-01-09 16:02:36 stefano Exp $
;
;----------------------------------------------------------------
;
;	Check if the CAPS-SPACE (BREAK) key is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;----------------------------------------------------------------

        XLIB    zx_break

zx_break:
				call $f46	; BREAK-1
				ld	hl,0	; assume break is not pressed
                ret c
                inc l
                ret
