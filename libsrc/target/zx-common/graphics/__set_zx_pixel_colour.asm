;
; Set the pixel colour in MODE0,1,2
;
	SECTION	code_graphics

	PUBLIC	__set_zx_pixel_colour

	EXTERN	__zx_screenmode
	EXTERN  __zx_console_attr
        EXTERN  SCREEN_BASE

; Entry: de, hl = screen address
; 
__set_zx_pixel_colour:
       ; Now set the attribute
        set     5,h             ;Assume we're in mode 2
        ld      a,(__zx_screenmode)
        cp      2
        jr      z,set_colour
        ld      a,d
        and     @00100000
        ld      d,a     ;Save flag bit
        ld      a,h
        rra
        rra
        rra
        and     3
IF FORsam
	or	+(SCREEN_BASE / 256) + 24
ELSE
        or      $58
ENDIF
        or      d
        ld      h,a
set_colour:
        ld      a,(__zx_console_attr)
        ld      (hl),a
	ret


