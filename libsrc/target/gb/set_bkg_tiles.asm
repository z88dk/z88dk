
        MODULE  set_bkg_tiles

        PUBLIC  set_bkg_tiles
        PUBLIC  _set_bkg_tiles

	EXTERN	set_xy_btt

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ set_bkg_tiles(uint8_t x, uint8_t y, uint8_t w, uint8_t h, unsigned char *tiles) __smallc NONBANKED;
set_bkg_tiles:
_set_bkg_tiles:
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
        INC     HL
        LD      A,(HL+)         ; A = h
        INC     HL
        LD      H,(HL)          ; H = w
        LD      L,A             ; L = h

        CALL    set_xy_btt

        POP     BC
	ret
