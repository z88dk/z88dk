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

; Nibble        Composite       RGB
;0      Black   Black
;1      Grey    Black
;2      Blue    Blue
;3      L.Yellow        L.Blue
;4      Green   Green
;5      L.Magenta       Bright Green
;6      Cyan    Cyan
;7      L.Red   Turquoise
;8      Red     Dark Red
;9      Dark Cyan       Red
;A      Magenta Purple
;B      L.Green Magenta
;C      Yellow  Lime
;D      Dark Blue       Yellow
;E      White   Off White
;F      Black   Bright White


; We'll go with the RGB table
	SECTION	rodata_clib
table_rgb:
        defb    $0	;BLACK -> BLACK
	defb	$2	;BLUE -> BLUE
	defb	$4	;GREEN -> GREEN
	defb	$6	;CYAN -> CYAN
	defb	$8	;RED -> RED
	defb	$b	;MAGENTA -> MAGENTA
	defb	$a	;BROWN -> PURPLE
	defb	$e	;LIGHTGRAY -> OFF WHITE
	defb	$1 	;DARKGRAY -> BLACK
	defb	$3	;LIGHTBLUE -> LIGHT BLUE
	defb	$5	;LIGHTGREEN -> BRIGHT GREEN
	defb	$7	;LIGHTCYAN -> TURQUOISE
	defb	$9	;LIGHTRED -> RED
	defb	$3	;LIGHTMAGENTA -> MAGENTA
	defb	$d	;YELLOW -> YELLOW
	defb	$f	;WHITE -> BRIGH WHITE

