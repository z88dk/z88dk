
	SECTION	code_driver
	PUBLIC	gotogxy
	PUBLIC	_gotogxy

	GLOBAL	tx
	GLOBAL	ty

; void __LIB__ gotogxy(uint8_t x, uint8_t y) __smallc;
gotogxy:
_gotogxy:
        LD      HL,sp+4
        LD      A,(HL)          ; A = x
        LD      (tx),A
        ld      hl,sp+2
        LD      A,(HL)          ; A = y
        LD      (ty),A

        RET
