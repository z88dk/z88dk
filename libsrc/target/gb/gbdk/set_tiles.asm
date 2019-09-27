


        MODULE  set_tiles

        PUBLIC  set_tiles
        PUBLIC  _set_tiles

	GLOBAL	set_xy_tt

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

; void __LIB__ set_tiles(uint8_t x, uint8_t y, uint8_t w, uint8_t h, unsigned char *vram_addr, unsigned char *tiles) __smallc  NONBANKED;
set_tiles:
_set_tiles:
        PUSH    BC

	ld	hl,sp+4
        LD      C,(HL)          ; BC = src
        INC     HL
        LD      B,(HL)
        INC     HL
        LD      E,(HL)          ; DE = dst
        DEC     HL
        LD      D,(HL)
	ld	hl,sp + 14
        PUSH    DE              ; Store address on stack for set_xy_tt
        LD      D,(HL)          ; D = x
	DEC	HL
        DEC     HL
        LD      E,(HL)          ; E = y
        DEC     HL
        DEC     HL
        LD      A,(HL-)         ; A = w
	DEC	HL
        LD      L,(HL)          ; L = h
        LD      H,A             ; H = w

        CALL    set_xy_tt

        POP     BC
        RET
