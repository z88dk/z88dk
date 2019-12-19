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
	and	a
	ret

;{  0,  0,  0} {  0,  0,255}, {  0,255,  0}, {  0,255,255}, {255,  0,  0}, {255,  0,255}, {255,255,  0}, {255,255,255},
;
; { 16, 64, 16} $8 - light green
; { 16,112, 32} $9 - light brown
; {208, 80, 32} $a - chocolate (brown)
; {224,144, 32} $b - light orange
; { 16, 80,128} $c - light cyan
; { 16,144,224} $d - light blue
; {240,112,144} $e - pink
; {128,128,128}	-$f - LIGHTGRAY
;

	SECTION	rodata_clib
table:
	; High nibble is 4 bit graphics colour
        defb    $00	;BLACK -> BLACK
	defb	$11	;BLUE -> BLUE
	defb	$22	;GREEN -> GREEN
	defb	$33	;CYAN -> CYAN
	defb	$44	;RED -> RED
	defb	$55	;MAGENTA -> MAGENTA
	defb	$a4	;BROWN -> RED
	defb	$b7	;LIGHTGRAY -> WHITE
	defb	$f7	;DARKGRAY -> WHITE
	defb	$d1	;LIGHTBLUE -> BLUE
	defb	$82	;LIGHTGREEN -> GREEN
	defb	$c3	;LIGHTCYAN -> CYAN
	defb	$94	;LIGHTRED -> RED
	defb	$e5	;LIGHTMAGENTA -> MAGENTA
	defb	$66	;YELLOW -> YELLOW
	defb	$77	;WHITE -> WHITE

