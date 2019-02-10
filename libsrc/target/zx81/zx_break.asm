;
;       ZX81 libraries
;
;       $Id: zx_break.asm,v 1.4 2016-06-26 20:32:08 dom Exp $
;
;----------------------------------------------------------------
;
;	Check if the CAPS-SPACE (BREAK) key is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    zx_break
        PUBLIC    _zx_break

zx_break:
_zx_break:
		call $f46	; BREAK-1
		ld	hl,0	; assume break is not pressed
                ret c
                inc l
                ret
