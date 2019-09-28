
	SECTION	code_driver
	PUBLIC	gotogxy
	PUBLIC	_gotogxy

	GLOBAL	__console_x
	GLOBAL	__console_y

; void __LIB__ gotogxy(uint8_t x, uint8_t y) __smallc;
gotogxy:
_gotogxy:
        LD      HL,sp+4
        LD      A,(HL)          ; A = x
        LD      (__console_x),A
        ld      hl,sp+2
        LD      A,(HL)          ; A = y
        LD      (__console_y),A

        RET
