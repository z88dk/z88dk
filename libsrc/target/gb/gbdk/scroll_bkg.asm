
;	.title	"CGB support"
;	.module	CGB

	MODULE	scroll_bkg

	PUBLIC	scroll_bkg
	PUBLIC	_scroll_bkg

	GLOBAL	set_xy_wtt

	SECTION	code_driver

	INCLUDE	"target/gb/def/gb_globals.def"

;void __LIB__ scroll_bkg(INT8 x, INT8 y) __smallc NONBANKED;
scroll_bkg:
_scroll_bkg:
        LD      HL,sp+4         ; Skip return address
        XOR     A
        CP      (HL)            ; Is x != 0
        JR      Z,scroll_1

        LDH     A,(SCX)        ; Yes
        ADD     (HL)
        LDH     (SCX),A
scroll_1:
        LD      HL,sp+2         ; Skip return address
        XOR     A
        CP      (HL)            ; Is y != 0
        JR      Z,scroll_2

        LDH     A,(SCY)        ; Yes
        ADD     (HL)
        LDH     (SCY),A
scroll_2:
        RET
