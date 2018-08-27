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
; European colours:
;const rgb_t cgenie_state::m_palette_eu[] =
;{
;0        rgb_t(0x5e, 0x5e, 0x5e), // gray
;1        rgb_t(0x11, 0xff, 0xea), // cyan
;2        rgb_t(0xff, 0x00, 0x5e), // red
;3        rgb_t(0xea, 0xea, 0xea), // white
;4        rgb_t(0xff, 0xf9, 0x00), // yellow
;5        rgb_t(0x6e, 0xff, 0x00), // green
;6        rgb_t(0xff, 0x52, 0x00), // orange
;7        rgb_t(0xea, 0xff, 0x00), // light yellow
;8        rgb_t(0x02, 0x48, 0xff), // blue
;9        rgb_t(0x8e, 0xd4, 0xff), // light blue
;10       rgb_t(0xff, 0x12, 0xff), // pink
;11       rgb_t(0x88, 0x43, 0xff), // purple
;12       rgb_t(0x8c, 0x8c, 0x8c), // light gray
;13       rgb_t(0x00, 0xfb, 0x8c), // turquoise
;14       rgb_t(0xd2, 0x00, 0xff), // magenta
;15       rgb_t::white()           // bright white
;};

table:
        defb    $0	;BLACK -> GREY
	defb	$8	;BLUE -> BLUE
	defb	$5	;GREEN -> GREEN
	defb	$1	;CYAN -> CYAN
	defb	$2	;RED -> RED
	defb	$e	;MAGENTA -> MAGENTA
	defb	$6	;BROWN -> ORANGE
	defb	$3	;LIGHTGRAY -> WHITE
	defb	$c	;DARKGRAY -> LIGHT GREY
	defb	$9	;LIGHTBLUE -> LIGHT BLUE
	defb	$7	;LIGHTGREEN -> LIGHT YELLOW
	defb	$d	;LIGHTCYAN -> TURQUOISE
	defb	$a	;LIGHTRED -> PINK
	defb	$b	;LIGHTMAGENTA -> PURPLE
	defb	$4	;YELLOW -> YELLOW
	defb	$f	;WHITE -> BRIGHT WHITE

