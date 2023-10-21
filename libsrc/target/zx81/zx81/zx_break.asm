;
;       ZX81 libraries
;
;       $Id: zx_break.asm $
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

		;call $f46	; BREAK-1

		LD A,$7F
		IN A,($FE)
		RRCA

		ld	hl,0	; assume break is not pressed
		ret c
		inc l
		ret
