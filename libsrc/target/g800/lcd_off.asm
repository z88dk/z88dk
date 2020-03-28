;
;       G850 library
;
;--------------------------------------------------------------
;
;       $Id: lcd_off.asm $
;
;----------------------------------------------------------------
;
; Turn off the LCD display
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    lcd_off
        PUBLIC    _lcd_off

lcd_off:
_lcd_off:
		ld	a,36
		out	(64),a
		ret
