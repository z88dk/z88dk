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

; 0  = black
; 1  = red
; 2  = green
; 3  = yellow
; 4  = blue
; 5  = violet
; 6  = cyan
; 7  = white
; 8  = light grey
; 9  = blue green
; 10 = magenta
; 11 = dark blue
; 12 = light yellow
; 13 = light green
; 14 = orange
; 15 = dark gray


; We'll go with the RGB table
	SECTION	rodata_clib
table_rgb:
        defb    $0	;BLACK -> BLACK
	defb	$b	;BLUE -> DARK BLUE
	defb	$2	;GREEN -> GREEN
	defb	$6	;CYAN -> CYAN
	defb	$1	;RED -> RED
	defb	$a	;MAGENTA -> MAGENTA
	defb	$e	;BROWN -> ORANGE 
	defb	$8	;LIGHTGRAY -> LIGHT GREY
	defb	$f 	;DARKGRAY -> DARK GREY
	defb	$4	;LIGHTBLUE -> BLUE
	defb	$d	;LIGHTGREEN -> LIGHT GREEN
	defb	$9	;LIGHTCYAN -> BLUE GREEN
	defb	$c	;LIGHTRED -> LIGHT YELLOW
	defb	$5	;LIGHTMAGENTA -> VIOLET
	defb	$3	;YELLOW -> YELLOW
	defb	$7	;WHITE -> WHITE

