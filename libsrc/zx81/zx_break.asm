;
;       ZX81 libraries
;
;       $Id: zx_break.asm,v 1.3 2015-01-19 01:33:26 pauloscustodio Exp $
;
;----------------------------------------------------------------
;
;	Check if the CAPS-SPACE (BREAK) key is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;----------------------------------------------------------------

        PUBLIC    zx_break

zx_break:
				call $f46	; BREAK-1
				ld	hl,0	; assume break is not pressed
                ret c
                inc l
                ret
