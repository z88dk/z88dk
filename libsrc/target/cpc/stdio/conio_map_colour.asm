;
;

	SECTION		code_clib
	PUBLIC		conio_map_colour

	EXTERN		__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c
	push	hl
	and	7
        ld      c,a
        ld      b,0
        ld      hl,ctable
        add     hl,bc
        ld      a,(hl)
	pop	hl
        ret

	SECTION		data_clib


.ctable defb    5,3,12,1,0,7,2,4

;0       Blue                    1
;1       Bright Yellow           24
;2       Bright Cyan             20
;3       Bright Red              6
;4       Bright White            26
;5       Black                   0
;6       Bright Blue             2
;7       Bright Magenta          8
;8       Cyan                    10
;9       Yellow                  12
;10      Pastel blue             14
;11      Pink                    16
;12      Bright Green            18
;13      Pastel Green            22
;
;0 black   5
;1 red     3
;2 green   12-13
;3 yellow  1
;4 blue    0
;5 magenta 7
;6 cyan    2
;7 white   4
