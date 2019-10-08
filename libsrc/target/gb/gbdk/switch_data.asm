
	SECTION	code_driver
        PUBLIC  _switch_data
        PUBLIC  switch_data

	GLOBAL	asm_switch_data
	GLOBAL	gmode
	GLOBAL	__mode

        INCLUDE "target/gb/def/gb_globals.def"


; void __LIB__ switch_data(uint8_t x, uint8_t y, unsigned char *src, unsigned char *dst) __smallc NONBANKED
;
_switch_data:                   ; Non Banked as pointer
switch_data:                    ; Non Banked as pointer
        PUSH    BC

        LD      A,(__mode)
        CP      G_MODE
        CALL    NZ,gmode

        LD      HL,sp+10        ; Skip return address and registers
        LD      A,(HL-) ; B = x
        LD      B,A
        DEC     HL
        LD      C,(HL)  ; C = y
        ld      hl,sp+7
        LD      A,(HL-) ; DE = src
        LD      D,A
        LD      A,(HL-)
        LD      E,A
        LD      A,(HL-) ; HL = dst
        LD      L,(HL)
        LD      H,A

        CALL    asm_switch_data

        POP     BC
        RET
