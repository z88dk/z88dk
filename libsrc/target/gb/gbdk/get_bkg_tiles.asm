


        MODULE  get_bkg_tiles

        PUBLIC  get_bkg_tiles
        PUBLIC  _get_bkg_tiles

	GLOBAL	get_xy_btt

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ get_bkg_tiles(uint8_t x, uint8_t y, uint8_t w, uint8_t h, unsigned char *tiles) __smallc NONBANKED;
get_bkg_tiles:
_get_bkg_tiles:
       PUSH    BC

        LD      HL,sp+12        ; Skip return address and registers
        LD      D,(HL)          ; D = x
	ld	hl,sp+10
        LD      E,(HL)          ; E = y
	ld	hl,sp+4
        LD      C,(HL)          ; BC = tiles
        INC     HL
        LD      B,(HL)
	ld	hl,sp+6
        LD      A,(HL)         ; A = h
	ld	hl,sp+8
        LD      H,(HL)          ; H = w
        LD      L,A             ; L = h

        CALL    get_xy_btt

        POP     BC
        RET
