
	SECTION	code_driver

	PUBLIC	asm_cls

        INCLUDE "target/gb/def/gb_globals.def"

asm_cls:
        PUSH    DE
        PUSH    HL
        LD      HL,0x9800
        LD      E,0x20          ; E = height
cls_1:
        LD      D,0x20          ; D = width
cls_2:
        ldh     a,(STAT)
        bit     1,a
        jr      nz,cls_2

        LD      (HL),' '	; Always clear
        INC     HL
        DEC     D
        JR      NZ,cls_2
        DEC     E
        JR      NZ,cls_1
        POP     HL
        POP     DE
        RET
