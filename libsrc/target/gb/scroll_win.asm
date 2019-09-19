
;	.title	"CGB support"
;	.module	CGB

	MODULE	scroll_win

	PUBLIC	scroll_win
	PUBLIC	_scroll_win

	GLOBAL	set_xy_wtt

	SECTION	code_driver

	INCLUDE	"target/gb/def/gb_globals.def"

;void __LIB__ scroll_win(INT8 x, INT8 y) __smallc NONBANKED;
scroll_win:
_scroll_win:
        LD      HL,sp+4         ; Skip return address
        XOR     A
        CP      (HL)            ; Is x != 0
        JR      Z,scroll_1

        LDH     A,(WX)        ; Yes
        ADD     (HL)
        LDH     (WX),A
scroll_1:
        LD      HL,sp+2         ; Skip return address
        XOR     A
        CP      (HL)            ; Is y != 0
        JR      Z,scroll_2

        LDH     A,(WY)        ; Yes
        ADD     (HL)
        LDH     (WY),A
scroll_2:
        RET
