; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

	MODULE	code_clib
	PUBLIC	conio_map_colour

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c

	and	15
	ld	c,a
	ld	b,0
	ld	hl,table_rgb
	add	hl,bc
	ld	a,(hl)
	ret

	SECTION	rodata_clib
table_rgb:
        defb    $0	;BLACK -> BLACK
	defb	$6	;BLUE -> DARK BLUE
	defb	$5	;GREEN -> GREEN
	defb	$3	;CYAN -> CYAN
	defb	$2	;RED -> RED
	defb	$4	;MAGENTA -> MAGENTA
	defb	$9	;BROWN -> ORANGE 
	defb	$f	;LIGHTGRAY -> LIGHT GREY
	defb	$b 	;DARKGRAY -> DARK GREY
	defb	$e	;LIGHTBLUE -> BLUE
	defb	$d	;LIGHTGREEN -> LIGHT GREEN
	defb	$c	;LIGHTCYAN -> GREY 2
	defb	$a	;LIGHTRED -> LIGHT YELLOW
	defb	$8 	;LIGHTMAGENTA -> ORANGE
	defb	$7	;YELLOW -> YELLOW
	defb	$1	;WHITE -> WHITE

