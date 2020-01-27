; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

	MODULE	code_clib
	PUBLIC	conio_map_colour
	PUBLIC	conio_map_colour_bg

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
	ld	hl,excalibur_colour_1
get_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c
	and	15
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	and	a
	ret

conio_map_colour_bg:
	ld	hl,background_table
	call	get_colour
	ret	nc		;It was mapped
	and	7		;Just truncate
	ret


	SECTION	rodata_clib

excalibur_colour_1:
        defb    $0	;BLACK -> BLACK
	defb	$2	;BLUE -> BLUE
	defb	$4	;GREEN -> GREEN
	defb	$6	;CYAN -> CYAN
	defb	$1	;RED -> RED
	defb	$3	;MAGENTA -> MAGENTA
        defb    $b      ;BROWN -> TAWNY (RED/ORANGE)        - ok
        defb    $f      ;LIGHTGRAY -> 15 (a very dark green)
        defb    $c      ;DARKGRAY -> 12 (a very, very dark purple)
        defb    $2      ;LIGHTBLUE -> 2 (blue)
        defb    $d      ;LIGHTGREEN -> PALE GREEN    - ok
        defb    $6      ;LIGHTCYAN -> 6 (cyan)
        defb    $9      ;LIGHTRED -> 9 (orange)
        defb    $e      ;LIGHTMAGENTA -> 14 (pink/cerise)
	defb	$5	;YELLOW -> YELLOW
	defb	$7	;WHITE -> WHITE

excalibur_colour_2:
        defb    $0	;BLACK -> BLACK
	defb	$d	;BLUE -> SKY BLUE
	defb	$4	;GREEN -> VERY DARK GREEN
	defb	$6	;CYAN -> VERY PALE BLUE
	defb	$1	;RED -> RED
	defb	$3	;MAGENTA -> DARK PURPLE
	defb	$b	;BROWN -> DARK BROWN
	defb	$f	;LIGHTGRAY -> LIGHT GREY
	defb	$e	;DARKGRAY -> DARK GREY
	defb	$2	;LIGHTBLUE -> GREY BLUE
	defb	$5	;LIGHTGREEN -> YELLOW GREEN
	defb	$8	;LIGHTCYAN -> DARK RED
	defb	$9	;LIGHTRED -> PINK
	defb	$e	;LIGHTMAGENTA -> PURPLE
	defb	$b	;YELLOW -> YELLOW BROWN
	defb	$7	;WHITE -> WHITE

background_table:
	defb	$0	;BLACK -> BLACK
	defb	$2	;BLUE -> BLUE
	defb	$4	;GREEN -> GREEN
	defb	$6	;CYAN -> CYAN
	defb	$1	;RED -> RED
	defb	$3	;MAGENTA -> MAGENTA
	defb	$1	;BROWN -> RED
	defb	$7	;LIGHTGRAY -> WHITE
	defb	$7	;DARKGRAY -> WHITE
	defb	$2	;LIGHTBLUE -> BLUE
	defb	$4	;LIGHTGREEN -> GREEN
	defb	$6	;LIGHTCYAN -> CYAN
	defb	$1	;LIGHTRED -> RED
	defb	$3	;LIGHTMAGENTA -> MAGENTA	
	defb	$5	;YELLOW -> YELLOW
	defb	$7	;WHITE -> WHITE
