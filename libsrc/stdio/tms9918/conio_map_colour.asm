; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  c,f
;

	MODULE	code_clib
	PUBLIC	conio_map_colour

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c

        and     7
        inc     a       ;(1,3,5,7: black, green, blue, cyan)
        bit     0,a
        ret     nz
        add     7       ; (2,4,6,8 -> 9,11,13,15; red, yellow, magenta, white)
        ret
