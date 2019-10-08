;
;       G850 library
;
;--------------------------------------------------------------
;
;       $Id: lcd_contrast.asm $
;
;----------------------------------------------------------------
;
; lcd_contrast(x) - set LCD contrast (0..17)
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    lcd_contrast
        PUBLIC    _lcd_contrast

lcd_contrast:
_lcd_contrast:
		cp	18
		ret	nc
		ld	a,128
		add	l
		out	(64),a
		ret
