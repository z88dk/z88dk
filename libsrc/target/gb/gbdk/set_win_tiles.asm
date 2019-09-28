
;	.title	"CGB support"
;	.module	CGB

	MODULE	set_win_tiles

	PUBLIC	set_win_tiles
	PUBLIC	_set_win_tiles

	GLOBAL	set_xy_wtt

	SECTION	code_driver

	INCLUDE	"target/gb/def/gb_globals.def"

;void __LIB__ set_win_tiles(uint8_t x, uint8_t y, uint8_t w, uint8_t h, unsigned char *tiles) __smallc NONBANKED;

set_win_tiles:
_set_win_tiles:
        PUSH    BC

        LD      HL,sp+12        ; Skip return address and registers
        LD      D,(HL)          ; D = x
        DEC     HL
        DEC     HL
        LD      E,(HL)          ; E = y
        LD      HL,sp+4
        LD      C,(HL)          ; BC = tiles
        INC     HL
        LD      B,(HL)
        INC	HL
        LD      A,(HL+)         ; A = h
	INC	HL
        LD      H,(HL)          ; H = w
        LD      L,A             ; L = h

        CALL    set_xy_wtt

        POP     BC
        RET
