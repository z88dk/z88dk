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
	ld	hl,table
	add	hl,bc
	ld	a,(hl)
	ret

	SECTION	rodata_clib
table:
        defb    $0	;BLACK -> BLACK
	defb	$1	;BLUE -> BLUE
	defb	$2	;GREEN -> GREEN
	defb	$3	;CYAN -> CYAN
	defb	$4	;RED -> RED
	defb	$5	;MAGENTA -> MAGENTA
	defb	$6	;BROWN -> YELLOW
	defb	$7	;LIGHTGRAY -> BRIGHT GREY
	defb	$8	;DARKGRAY -> DARK GREY
	defb	$9	;LIGHTBLUE -> BRIGHT BLUE
	defb	$a 	;LIGHTGREEN -> BRIGHT GREEN
	defb	$b	;LIGHTCYAN -> BRIGHT CYAN
	defb	$c	;LIGHTRED -> BRIGHT RED
	defb	$d	;LIGHTMAGENTA -> BRIGHT MAGENTA
	defb	$e	;YELLOW -> BRIGHT YELLOW
	defb	$f	;WHITE -> WHITE

